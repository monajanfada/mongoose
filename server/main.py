
from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from routers import run_tests
from models.database import engine
from models import test_model

app = FastAPI()

app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")

test_model.Base.metadata.create_all(bind=engine)


app.include_router(run_tests.router)


@app.get("/health")
async def read_root(request: Request):
    return {
        "message": "ok"
    }
