from fastapi import FastAPI, WebSocket, HTTPException
from db import get_corps, get_corp
from model import Corp

app = FastAPI()

@app.get(
    "/api/v1/corp/",
    response_description="List all corporates.",
    response_model=list[Corp],
    response_model_by_alias=False,
)
async def read_corps():
    return get_corps()

@app.get(
    "/api/v1/corp/{id}",
    response_description="List all corporates.",
    response_model=Corp,
    response_model_by_alias=False,
)
async def read_corp(id: str):
    corp = get_corp(id)
    if corp is not None:
        return corp
    raise HTTPException(status_code=404, detail=f"Corporate {id} not found.")

@app.websocket("/ws/v1/face-verification")
async def face_verification(websocket: WebSocket):
    await websocket.accept()
    # 1. validate user
    # 2. get id card image
    async for img_bytes in websocket.iter_bytes():
        print(f"Received image bytes: {img_bytes}")
        # 3. verify incomming image with id card image
        # 4. send verify true if it is the same person