FROM python:3.12
 
WORKDIR /code

RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y
 
COPY ./requirements.txt /code/requirements.txt
 
RUN pip install --upgrade pip
RUN pip install --no-cache-dir --upgrade --default-timeout=50000 -r /code/requirements.txt
 
COPY ./app /code/app
COPY ./cert /code/cert

# https://github.com/serengil/deepface_models/releases/download/v1.0/facenet_weights.h5

CMD ["python", "app/main.py"]
