import asyncio
import uvicorn
from fastapi import FastAPI, WebSocket, HTTPException, status, Depends, Form, UploadFile, WebSocketDisconnect
from typing import Annotated
from pydantic import EmailStr
from db import get_corps, register, is_site_exist, get_emp, get_emp_by_email, is_emp_exist_by_email, write_check_in_log
from authen import hashed_password, verify_password, create_access_token, validate_token, validate_token_for_ws
from model import Corp, Employee, Login, LoginResponse, EmployeeResponse, EmployeeWithLocation
from ml import get_emp_data_from_ocr, face_verify
# from PIL import Image
# from io import BytesIO

SSL_KEY_FILE = "cert/key.pem"
SSL_CERT_FILE = "cert/cert.pem"

app = FastAPI(ssl_keyfile=SSL_KEY_FILE, ssl_certfile=SSL_CERT_FILE)

@app.get(
    "/api/v1/corp",
    response_description="List all corporates.",
    response_model=list[Corp],
    response_model_by_alias=False,
)
async def read_corps(emp: Annotated[Employee, Depends(validate_token)]):
    return get_corps()

@app.get(
    "/api/v1/emp",
    response_description="Get user profile from token.",
    response_model=EmployeeResponse,
    response_model_by_alias=False,
)
async def read_corps(emp: Annotated[Employee, Depends(validate_token)]):
    return emp

@app.post(
    "/api/v1/emp",
    response_description="Register new employee.",
    status_code=status.HTTP_201_CREATED,
    response_model_by_alias=False,
)
async def register_emp(admin_data: Annotated[Employee, Depends(validate_token)], emp: Employee):
    if not admin_data["isAdmin"]:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="invalid permission.")
    
    if not is_site_exist(emp.site_id):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="SiteID is not exists")

    if is_emp_exist_by_email(emp.email):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Username already exists")
    
    emp.password = hashed_password(emp.password)
    emp = emp.model_dump(by_alias=True, exclude=["id"])

    try:
        register(emp)
        return { "message": "register success." }
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error registering employee: {str(e)}")

@app.post(
    "/api/v2/emp",
    response_description="Extract employee data from id card image from-data.",
    response_model=Employee,
    status_code=status.HTTP_200_OK,
    response_model_by_alias=False,
)
async def register_emp_v2(
    admin_data: Annotated[Employee, Depends(validate_token)],
    email: Annotated[EmailStr, Form()],
    password: Annotated[str, Form()],
    site_id: Annotated[str, Form()],
    img: UploadFile,
):
    if not admin_data["isAdmin"]:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="invalid permission.")
    
    if not is_site_exist(site_id):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="SiteID is not exists")

    if is_emp_exist_by_email(email):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Email already exists")

    try:
        emp_data = await get_emp_data_from_ocr(
            email=email, 
            password=password,
            site_id=site_id,
            img=img
        )
        return emp_data
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"Get OCR Data Error: {str(e)}")

@app.post(
    "/api/v1/login",
    response_description="Login.",
    response_model_by_alias=False,
    response_model=LoginResponse,
)
async def gentoken(login: Login):
    emp = get_emp(username=login.username)
    if emp is None:
        emp = get_emp_by_email(email=login.username)
        if emp is None:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="user is not exists.")

    if not verify_password(login.password, emp["password"]):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="invalid password.")

    access_token = create_access_token(data={"sub": emp["username"]})
    response = LoginResponse(access_token=access_token, token_type="Bearer")
    return response

@app.websocket("/ws/v1/face-verification")
async def face_verification(websocket: WebSocket, emp: Annotated[EmployeeWithLocation, Depends(validate_token_for_ws)]):
    await websocket.accept()
    print(f"{emp.employee.username} connected")
    active_tasks = set()
    try:
        while True:
            img_bytes = await websocket.receive_bytes()
            task = asyncio.create_task(process_incoming_data(websocket=websocket, emp=emp, face_img=img_bytes))
            active_tasks.add(task)
            task.add_done_callback(lambda t: active_tasks.discard(t))
    except WebSocketDisconnect:
        print(f"{emp.employee.username} disconnected")
    finally:
        for task in active_tasks:
            task.cancel()
        await asyncio.gather(*active_tasks, return_exceptions=True)
        print(f"{emp.employee.username} all tasks cancelled")

async def process_incoming_data(websocket: WebSocket, emp: EmployeeWithLocation, face_img: bytes):
    try:
        output = await face_verify(face_img=face_img, card_img=bytes())
        print(f"{emp.employee.username} verified {output}")
        if output:
            inserted = write_check_in_log(emp)
            print(f"{emp.employee.username} send signal to client and inserted {inserted.acknowledged}")
            asyncio.gather(websocket.send_text('valid'))
    except asyncio.CancelledError:
        print(f"{emp.employee.username} task was cancelled")

if __name__ == "__main__":
    uvicorn.run(
        "main:app", 
        host="0.0.0.0",
        port=8080, 
        ssl_keyfile=SSL_KEY_FILE, 
        ssl_certfile=SSL_CERT_FILE
    )