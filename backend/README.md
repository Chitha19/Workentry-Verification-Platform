# RUN app
*run docker desktop first before running app*
```bash
cd backend
docker build -t backend-img:0.0.1 .
docker run -it --rm -p 8080:8080 --name backend backend-img:0.0.1
```

# Set venv
```bash
python -m venv <path to create venv folder>
source <path of venv folder>/bin/activate
```