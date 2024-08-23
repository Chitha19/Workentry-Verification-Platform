from fastapi import FastAPI, WebSocket, HTTPException, status
from db import get_corps, is_emp_exist, register, is_site_exist, get_emp
from authen import hashed_password, verify_password, ACCESS_TOKEN_EXPIRE_MINUTES, create_access_token
from model import Corp, Employee, Login

app = FastAPI()

@app.get(
    "/api/v1/corp/",
    response_description="List all corporates.",
    response_model=list[Corp],
    response_model_by_alias=False,
)
async def read_corps():
    return get_corps()

@app.post(
    "/api/v1/emp/",
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

# @app.post(
#     "/api/v1/emp/{id}",
#     response_description="Get employee by ID.",
#     response_model=Employee,
#     response_model_by_alias=False,
# )
# async def read_emp(id: str, current_user: dict = Depends(get_current_user)):
#     # Convert id to ObjectId
#     user = users_collection.find_one({"_id": ObjectId(id)})
#     if not user:
#         raise HTTPException(status_code=404, detail="User not found")
    
#     # Prepare user data for response
#     user_data = User(
#         id=str(user["_id"]),
#         username=user["username"],
#         email=user["email"]
#     )
    
#     return user_data

@app.post(
    "/api/v1/login/",
    response_model_by_alias=False,
)
async def register_emp(login: Login):
    emp = get_emp(username=login.username)
    if emp is None:
        raise HTTPException(status_code=400, detail="Username is not exists")

    if not verify_password(login.password, emp["password"]):
        raise HTTPException(status_code=400, detail="Invalid password")

    access_token = create_access_token(data={"sub": emp["username"]})
    return {"access_token": access_token, "token_type": "bearer"}

# @app.websocket("/ws/v1/face-verification")
# async def face_verification(websocket: WebSocket):
#     await websocket.accept()
#     # 1. validate user
#     # 2. get id card image
#     async for img_bytes in websocket.iter_bytes():
#         print(f"Received image bytes: {img_bytes}")
#         # 3. verify incomming image with id card image
#         # 4. send verify true if it is the same person