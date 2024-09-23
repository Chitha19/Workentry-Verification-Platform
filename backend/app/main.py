import asyncio
from fastapi import FastAPI, WebSocket, HTTPException, status, Depends, Form, UploadFile, File
from typing import Annotated
from pydantic import EmailStr
from db import get_corps, is_emp_exist, register, is_site_exist, get_emp, get_emp_by_email, is_emp_exist_by_email
from authen import hashed_password, verify_password, create_access_token, validate_token, validate_token_for_ws
from model import Corp, Employee, Login, LoginResponse, EmployeeResponse, EmployeeWithLocation
from PIL import Image
from io import BytesIO

app = FastAPI()

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
async def register_emp(emp: Employee):
    if not is_site_exist(emp.site_id):
        raise HTTPException(status_code=400, detail="SiteID is not exists")

    if is_emp_exist(emp.username):
        raise HTTPException(status_code=400, detail="Username already exists")
    
    emp.password = hashed_password(emp.password)
    emp = emp.model_dump(by_alias=True, exclude=["id"])

    try:
        register(emp)
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error registering employee: {str(e)}")

    return { "message": "register success." }

@app.post(
    "/api/v2/emp",
    response_description="Register new employee from-data.",
    status_code=status.HTTP_201_CREATED,
    response_model_by_alias=False,
)
async def register_emp_v2(
    emp: Annotated[Employee, Depends(validate_token)],
    email: Annotated[EmailStr, Form()],
    password: Annotated[str, Form()],
    site_id: Annotated[str, Form()],
    img: UploadFile,
):
    if not emp["isAdmin"]:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="invalid permission.")
    
    print(email, password, site_id, img.filename)
    # contents = await img.read()
    tmp = Image.open(img.file)
    tmp.show()

    # if not is_site_exist(form.site_id):
    #     raise HTTPException(status_code=400, detail="SiteID is not exists")

    # if is_emp_exist_by_email(form.email):
    #     raise HTTPException(status_code=400, detail="Email already exists")
    
    
    # emp.password = hashed_password(emp.password)
    # emp = emp.model_dump(by_alias=True, exclude=["id"])

    # try:
    #     register(emp)
    # except Exception as e:
    #     raise HTTPException(status_code=400, detail=f"Error registering employee: {str(e)}")

    return { "message": "register success." }

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
async def face_verification(*, websocket: WebSocket, emp: Annotated[EmployeeWithLocation, Depends(validate_token_for_ws)]):
    await websocket.accept()
    # 2. get id card image
    asyncio.gather(test(websocket))
    async for img_bytes in websocket.iter_bytes():
        print(f"received")
        img = Image.open(BytesIO(img_bytes))
        img.show()
        # 3. verify incomming image with id card image
        # 4. send verify true if it is the same person

async def test(websocket: WebSocket):
    print('waiting')
    await asyncio.sleep(2)
    print('sending')
    asyncio.gather(websocket.send_text('verified'))
    # websocket.send_bytes(bytes(1))

