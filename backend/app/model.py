from pydantic import BaseModel, BeforeValidator, Field, EmailStr
from typing import Annotated, Optional


class Site(BaseModel):
    site_id: Annotated[str, BeforeValidator(str)]
    site_name: str
    lat: float
    long: float

class Corp(BaseModel):
    corp_id: Annotated[str, BeforeValidator(str)]
    corp_name: str
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
    img: Optional[str] = Field(default="/")
    email: EmailStr
    password: str

class Login(BaseModel):
    username: str
    password: str