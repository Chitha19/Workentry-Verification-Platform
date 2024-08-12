from pydantic import BaseModel, BeforeValidator
from typing import Annotated


class Site(BaseModel):
    site_id: Annotated[str, BeforeValidator(str)]
    site_name: str
    lat: float
    long: float

class Corp(BaseModel):
    corp_id: Annotated[str, BeforeValidator(str)]
    corp_name: str
    site: list[Site]