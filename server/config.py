from pathlib import Path
import os


BASE_DIR = Path(__file__).resolve().parent.parent
SERVER_DIR = Path(__file__).resolve().parent
TEST_DIR = os.path.join(BASE_DIR, 'tests')
LOG_DIR = os.path.join(SERVER_DIR, 'logs')
