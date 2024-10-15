from fastapi import HTTPException, Depends, status, WebSocket, Header, WebSocketException
from fastapi.security import OAuth2PasswordBearer
from typing import Annotated, Union
from passlib.context import CryptContext
import jwt
from jwt.exceptions import InvalidTokenError
from datetime import datetime, timedelta, timezone
from db import get_emp, get_emp_by_email
from model import EmployeeWithLocation

SECRET_KEY = "7a28547b0585580e129d01c1f2b4633b6dc3e248f71530ea35c8765571e4c730"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30
# ACCESS_TOKEN_EXPIRE_MINUTES = 10

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="api/v1/login")

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

def hashed_password(password) -> str:
    return pwd_context.hash(password)

def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

async def validate_token(token: Annotated[str, Depends(oauth2_scheme)]):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username == "":
            raise credentials_exception
    except InvalidTokenError:
        raise credentials_exception
    emp = get_emp(username)
    if emp is not None:
        return emp
    emp_by_email = get_emp_by_email(username)
    if emp_by_email is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="user is not exists.")
    return emp_by_email

async def validate_token_for_ws(
    websocket: WebSocket, 
    authorization: Annotated[Union[str, None], Header()] = None,
    x_current_location: Annotated[Union[str, None], Header()] = None,
):
    #! validate location
    if x_current_location is None or x_current_location == "":
        raise WebSocketException(code=status.WS_1008_POLICY_VIOLATION)
    
    location = x_current_location.split(",", 1)

    #! validate token
    if authorization is None or authorization == "":
        raise WebSocketException(code=status.WS_1008_POLICY_VIOLATION)

    token = authorization.removeprefix("Bearer ")
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username == "":
            raise WebSocketException(code=status.WS_1008_POLICY_VIOLATION)
    except InvalidTokenError:
        raise WebSocketException(code=status.WS_1008_POLICY_VIOLATION)
    
    emp = get_emp(username)
    if emp is not None:
        return EmployeeWithLocation(employee=emp, lat=float(location[0]), long=float(location[1]))
    
    emp_by_email = get_emp_by_email(username)
    if emp_by_email is None:
        raise WebSocketException(code=status.WS_1008_POLICY_VIOLATION)
    return EmployeeWithLocation(employee=emp_by_email, lat=float(location[0]), long=float(location[1]))