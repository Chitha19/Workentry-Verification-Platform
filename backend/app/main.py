from typing import Union
from fastapi import FastAPI, WebSocket

app = FastAPI()

@app.get("/api/v1")
def read_root():
    return {"Hello": "World"}

@app.get("/api/v1/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}

@app.websocket("/ws/v1/face-verification")
async def face_verification(websocket: WebSocket):
    await websocket.accept()
    # 1. validate user
    # 2. get id card image
    async for img_bytes in websocket.iter_bytes():
        print(f"Received image bytes: {img_bytes}")
        # 3. verify incomming image with id card image
        # 4. send verify true if it is the same person