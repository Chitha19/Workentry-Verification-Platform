from fastapi import UploadFile, HTTPException, status
from model import OCRData, Employee
import asyncio
from easyocr import Reader
import string
import random
import numpy as np
from deepface import DeepFace
from PIL import Image
from io import BytesIO
# import cv2

OCR_READER = Reader(lang_list=['en','th'], gpu=True)

async def ocr(card: bytes):
    try:
        img = OCR_READER.readtext(image=card, detail = 0)
        print(img)
        data = OCRData(
            emp_corp_id="",
            fname_th="",
            lname_th="",
            fname_en="",
            lname_en="",
        )
        if len(img) >= 2:
            data.fname_th = img[1].strip()
        if len(img) >= 3:
            data.lname_th = img[2].strip()
        if len(img) >= 4:
            data.fname_en = img[3].strip().split(' ')[0].capitalize()
            data.lname_en = img[3].strip().split(' ')[1].capitalize()
        if len(img) >= 5:
            data.emp_corp_id = img[4].strip()
        return data
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
            detail=f"Extract Data From Card Error: {e}"
        )
    
async def face_verify(face_img: bytes, card_img: str) -> bool:
    tmp = np.array(Image.open(BytesIO(face_img)))
    result = DeepFace.verify(
        img1_path=tmp, 
        img2_path=card_img,
        model_name="Facenet", #facenet 512
        detector_backend='fastmtcnn',
        distance_metric='cosine',
        enforce_detection=False, #true
        align=True,
        normalization='base',
        threshold=0.786
    )
    #! return distance 
    return result['verify'], result['distance']
    
async def get_emp_data_from_ocr(email: str, password: str, site_id: str, img: UploadFile) -> Employee:
    img_bytes = await img.read()
    coros = [store_card_img(img=img_bytes), ocr(card=img_bytes)]
    [img_path, data] = await asyncio.gather(*coros) 
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

async def store_card_img(img: bytes) -> str:
    filename = ''.join(random.choices(string.ascii_letters, k=16)) + '.jpg'
    
    content = Image.open(BytesIO(img))
    buff = np.array(content)
    face = DeepFace.extract_faces(img_path=buff, detector_backend='fastmtcnn', color_face='bgr')

    if len(face) == 0:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, 
            detail="Can't detect face from image"
        )
    
    ndface = np.array(face[0]['face'])
    ndface = (ndface * 255).astype(np.uint8)

    # ndface = cv2.resize(ndface, (416, 416))
    
    face_img = Image.fromarray(ndface)
    face_img = face_img.resize((216, 216), resample=1)
    # print(f"new image from ndarray: {face_img}")
    path = f'/app/images/{filename}'
    # cv2.imwrite(path, ndface)
    face_img.save(path)
    # print(f"image seved")
    return path