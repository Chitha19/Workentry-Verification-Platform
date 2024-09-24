FROM python:3.12
 
WORKDIR /code
 
COPY ./requirements.txt /code/requirements.txt
 
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
 
COPY ./app /code/app
COPY ./cert /code/cert

CMD ["python", "app/main.py"]
 
# CMD ["fastapi", "run", "app/main.py", "--host", "0.0.0.0", "--ssl-keyfile", "cert/key.pem", "--ssl-certfile", "cert/cert.pem"]
# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
