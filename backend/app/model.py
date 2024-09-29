from pydantic import BaseModel, BeforeValidator, Field, EmailStr, SecretStr
from typing import Annotated, Optional
from datetime import datetime


class Site(BaseModel):
    site_id: Annotated[str, BeforeValidator(str)]
    site_name: str
    lat: float
    long: float

class Corp(BaseModel):
    corp_id: Annotated[str, BeforeValidator(str)]
    corp_name: str
    corp_short_name: str
    site: list[Site]

class Employee(BaseModel):
    id: Optional[Annotated[str, BeforeValidator(str)]] = Field(alias="_id", default=None)
    site_id: Annotated[str, BeforeValidator(str)]
    emp_corp_id: str
    username: str
    fname_th: str
    lname_th: str
    fname_en: str
    lname_en: str
    img: str = Field(default="/")
    email: EmailStr
    password: str
    # password: SecretStr
    isAdmin: bool

class Login(BaseModel):
    username: str
    password: str
class LoginResponse(BaseModel):
    access_token: str
    token_type: str

class EmployeeResponse(BaseModel):
    id: Optional[Annotated[str, BeforeValidator(str)]] = Field(alias="_id", default=None)
    fname_en: str
    username: str
    isAdmin: bool

class EmployeeWithLocation(BaseModel):
    employee: Employee
    lat: float
    long: float

class OCRData(BaseModel):
    emp_corp_id: str
    fname_th: str
    lname_th: str
    fname_en: str
    lname_en: str

# check_in
class CheckInLog(BaseModel):
    id: Optional[Annotated[str, BeforeValidator(str)]] = Field(alias="_id", default=None)
    timestamp: Optional[datetime] = Field(default=datetime.now())
    emp_id: str
    current_lat: float
    current_long: float