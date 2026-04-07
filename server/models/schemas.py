from typing import TypedDict
from pydantic import BaseModel
from datetime import datetime


class TestType(TypedDict):
    name: str
    root: str


class ScopeType(TestType):
    test_list: list[TestType]


class ProjectType(TestType):
    scop_list: list[ScopeType]


class LogFileBase(BaseModel):
    id: int
    name: str
    test_id: int

    class Config:
        orm_mode = True


class TestHistoryBase(BaseModel):
    id: int
    name: str
    start_at: datetime
    end_at: datetime
    success: bool
    command_input: str
    command_output: str
    log_files: list[LogFileBase]

    class Config:
        orm_mode = True
