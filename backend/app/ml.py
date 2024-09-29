from fastapi import UploadFile, HTTPException, WebSocket, WebSocketException, status
from model import OCRData, Employee, EmployeeWithLocation, CheckInLog
from db import write_check_in_log
from datetime import datetime
import asyncio
import time
from random import randint
from deepface import DeepFace
from PIL import Image
import easyocr

async def ocr(card: UploadFile):
    try:
        reader = easyocr.Reader(['en','th'],gpu=True)
        img = reader.readtext(await card.read(), detail = 0)
        return OCRData(
            emp_corp_id=img[4], 
            fname_th=img[1], 
            lname_th=img[2],
            fname_en=img[3].split(' ')[0],
            lname_en=img[3].split(' ')[1]
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
            detail="Extract Data From Card Error."
        )
    
async def face_verify(face_img: bytes, card_img: bytes) -> bool:
    try:
        number = randint(1, 100)
        time.sleep(3)
        if (number > 80):
            return True
        else:
            return False
    except Exception as e:
        print(f"Face Verifying Error, ${e}")
        raise WebSocketException(code=status.WS_1011_INTERNAL_ERROR)
    
async def verifying(websocket: WebSocket, emp: EmployeeWithLocation, face_img: bytes):
    card_img: bytes = bytes() #! load card image
    if await face_verify(face_img=face_img, card_img=card_img):
        asyncio.gather(websocket.send_bytes(1))
        log = CheckInLog(
            timestamp=datetime.now(),
            emp_id=emp.employee.id,
            current_lat=emp.lat,
            current_long=emp.long
        )
        write_check_in_log(log)
    
async def get_emp_data_from_ocr(email: str, password: str, site_id: str, img: UploadFile) -> Employee:
    img_path = await store_card_img(img=img) #! store card image
    data = await ocr(img)
    new_emp = Employee(
        site_id=site_id,
        username=email.split('@')[0],
        email=email,
        password=password,
        isAdmin=False,
        emp_corp_id=data.emp_corp_id,
        fname_th=data.fname_th,
        lname_th=data.lname_th,
        fname_en=data.fname_en,
        lname_en=data.lname_en,
        img=img_path
    )
    return new_emp

async def store_card_img(img: UploadFile) -> str:
    return '/path/to/card_img/img.jpg'