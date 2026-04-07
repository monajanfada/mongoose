
import json

from sqlalchemy import Column, ForeignKey, Integer, String, DateTime, Boolean
from sqlalchemy.orm import relationship

from models.schemas import ProjectType
from models.database import Base


class TestHistory(Base):
    __tablename__ = "test_history"
    id = Column(Integer, primary_key=True)
    project = Column(String, )
    scope = Column(String, )
    scope = Column(String, )
    stage = Column(String, )
    start_at = Column(DateTime(timezone=True), )
    end_at = Column(DateTime(timezone=True), )
    success = Column(Boolean,)
    command_input = Column(String, )
    command_output = Column(String, )
    log_files = relationship("LogFile", back_populates="test")


class LogFile (Base):
    __tablename__ = "log_file"
    id = Column(Integer, primary_key=True)
    name = Column(String, )
    test_id = Column(Integer, ForeignKey("test_history.id"))
    test = relationship("TestHistory", back_populates="log_files")


def load_project_list():
    with open('models/project-list.json') as f:
        project_list: list[ProjectType] = json.loads(f.read())
        f.close()
        return project_list


def find_scop(project_name: str, scope_name: str):
    for project_item in project_list:
        if project_item['name'] == project_name:
            for scop in project_item['scop_list']:
                if scop['name'] == scope_name:
                    return scop
    return None


project_list = load_project_list()
