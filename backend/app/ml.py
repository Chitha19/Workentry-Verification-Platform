from fastapi import UploadFile, HTTPException, WebSocket, status
from model import OCRData, Employee, EmployeeWithLocation
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
    number = randint(1, 100)
    await asyncio.sleep(1)
    if (number > 80):
        return True
    else:
        return False
    
async def verifying(websocket: WebSocket, emp: EmployeeWithLocation, face_img: bytes):
    card_img: bytes = bytes() #! load card image

    try:
        output = await face_verify(face_img=face_img, card_img=card_img)
        print(f'verify {output}')
        if output:
            if websocket.client_state != 2:
                print(f'send verified to client')
                asyncio.gather(websocket.send_text('valid'))
    except asyncio.CancelledError:
        print('task was cancelled')
    
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
    return '/app/images/img.jpg'