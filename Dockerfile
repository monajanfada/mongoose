FROM python:3.12.6-bookworm
WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["fastapi", "run", "main.py", "--proxy-headers"]
