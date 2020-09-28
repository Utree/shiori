from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class LoginInfo(BaseModel):
    """ ログイン時要求項目"""
    email: str
    password: str


class SignupInfo(BaseModel):
    """ サインアップ時要求項目"""
    name: str
    email: str
    password: str


@app.get('/')
async def hello():
    return {"text": "hello world!"}


@app.post("/login")
async def login(user: LoginInfo):
    """ ログイン
    """
    # TODO: ログイン処理を実装
    email = user.email
    password = user.password
    print(f"DEBUG[login]\temail: {email}, passwd: {password}")

    return {'access_token': "#####"}


@app.post("/signup")
async def signup(user: SignupInfo):
    """ サインアップ
    """
    # TODO: サインアップ処理を実装
    name = user.name
    email = user.email
    password = user.password
    print(f"DEBUG[login]\tname: {name}, email: {email}, passwd: {password}")

    return {'access_token': "#####"}
