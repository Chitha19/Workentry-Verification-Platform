from pymongo import MongoClient
from bson.objectid import ObjectId

client = MongoClient("mongodb://faceverify:faceverify1234@localhost:27017/")
db = client["face_verification"]

def get_corps():
    return db.corp_view.find({})

def get_corp(id: str):
    return db.corp_view.find_one({"corp_id": ObjectId(id)})
