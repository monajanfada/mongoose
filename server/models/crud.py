from sqlalchemy.orm import Session
from sqlalchemy import desc
from . import test_model
from datetime import datetime
import math


def get_test(db: Session, test_id: int):
    return db.query(
        test_model.TestHistory).filter(
        test_model.TestHistory.id == test_id).first()


def get_test_list(db: Session, page: int = 1, page_size: int = 10):
    result = db.query(
        test_model.TestHistory).order_by(desc(test_model.TestHistory.id)).offset((page-1)*page_size).limit(page_size).all()
    count = db.query(test_model.TestHistory).count()
    return {
        "result": result,
        "pagination": {"total_pages": math.ceil(count/page_size), "page": page, "page_size": page_size}
    }


def create_test_history(db: Session, project: str, scope: str,
                        start_at: datetime, end_at: datetime, success: bool,
                        command_input: str, command_output: str,
                        output_file: str, log_file: str, report_file: str
                        ):
    db_test = test_model.TestHistory(
        project=project,
        scope=scope,
        start_at=start_at,
        end_at=end_at,
        success=success,
        command_input=command_input,
        command_output=command_output
    )

    db.add(db_test)
    db.commit()
    db.refresh(db_test)
    create_log(db, output_file, db_test.id)  # type: ignore
    create_log(db, log_file, db_test.id)  # type: ignore
    create_log(db, report_file, db_test.id)  # type: ignore
    return db_test


def create_log(db: Session, name: str, test_id: int):
    db_log = test_model.LogFile(
        name=name,
        test_id=test_id,
    )
    db.add(db_log)
    db.commit()
    db.refresh(db_log)
    return db_log
