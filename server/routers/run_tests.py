import subprocess
from os import path
from datetime import datetime

from sqlalchemy.orm import Session
from fastapi import APIRouter, Form, Request, Depends, HTTPException
from fastapi.templating import Jinja2Templates
from typing import Annotated, Union
from fastapi.responses import HTMLResponse, RedirectResponse

from config import LOG_DIR, TEST_DIR
from models.test_model import find_scop, project_list
from models.database import SessionLocal
from models import crud
templates = Jinja2Templates(directory="templates", autoescape=False)
router = APIRouter()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


router = APIRouter(
    tags=["tests"],
    dependencies=[],
    responses={404: {"description": "Not found"}},
)


@router.get("/")
async def get_test_history(request: Request, page: int = 1, page_size: int = 20, db: Session = Depends(get_db)):
    history_list = crud.get_test_list(db, page, page_size)
    return templates.TemplateResponse(
        request=request,
        name="test_history.html",
        context={
            "test_history_list": history_list['result'],
            "pagination": history_list['pagination']
        }
    )


@router.get("/api/test_histories/{test_id}")
async def get_test_item(test_id: int, db: Session = Depends(get_db)):
    history = crud.get_test(db, test_id)
    if history is None:
        raise HTTPException(status_code=404, detail="User not found")
    return history


@router.get("/api/project-list")
async def api_test_list():
    return {
        "results": project_list,
        "count": len(project_list)
    }


@router.get("/run-test")
async def read_root(request: Request):
    return templates.TemplateResponse(
        request=request,
        name="run_test.html",
        context={"project_list": project_list}
    )


@router.post("/run-test")
async def run_test(
    request: Request,
    stage_url: Annotated[str, Form()],
    project_name: Annotated[str, Form()],
    scope_name: Annotated[str, Form()],
    tag_list: Annotated[Union[str, None], Form()] = None,
    db: Session = Depends(get_db)
):
    scope = find_scop(project_name, scope_name)

    if scope is None:
        return HTMLResponse(status_code=404)
    start_at = datetime.now()
    time_stamp = start_at.strftime('%Y-%m-%d_%H-%M-%S')
    output_name = f"output-{time_stamp}.xml"
    report_name = f"report-{time_stamp}.html"
    log_name = f"log-{time_stamp}.html"
    command = [
        'robot',
        '-d', LOG_DIR,
        "-o", output_name,
        "-r", report_name,
        "-l", log_name,
        "-v", f"HOST_STAGE:{stage_url}",
        f"{TEST_DIR}{scope['root']}"
    ]
    process = subprocess.run(command, stdout=subprocess.PIPE)

    test = crud.create_test_history(db=db, project=project_name,
                                    scope=scope_name, start_at=start_at,
                                    end_at=datetime.now(), success=True,
                                    command_input=" ".join(command),
                                    command_output=str(
                                        process.stdout, encoding='utf-8').strip(),
                                    log_file=log_name,
                                    output_file=output_name,
                                    report_file=report_name,
                                    )
    print(test)
    return RedirectResponse("/", status_code=302)


@router.get("/{log_name}")
async def get_log(log_name: str):
    if (path.isfile(f'logs/{log_name}')):
        with open(f'logs/{log_name}') as f:
            report = f.read()
            f.close()
        return HTMLResponse(content=report)
    else:
        return HTTPException(status_code=404)
