from fastapi import FastAPI, Depends, HTTPException, status
from pydantic import BaseModel
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from typing import List

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


class TravelItem(BaseModel):
    id: int
    name: str
    created_at: str
    thumbnail_url: str


class TravelInfo(BaseModel):
    """ トラベル情報返却項目"""

    data: List[TravelItem]


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


def get_current_user(
        cred: HTTPAuthorizationCredentials = Depends(HTTPBearer())):
    """ トークン認証しユーザー情報を返す
    """
    try:
        # tokenを取得
        print(cred.credentials)
        # TODO: tokenを使ってdbにuser名を参照し認証
        user = SignupInfo(name="user1", email="a@a.com", password="aaa")
    except:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail='Invalid authentication credentials',
            headers={'WWW-Authenticate': 'Bearer'},
        )
    return user


@app.get("/travels", response_model=TravelInfo)
async def get_travel_list(current_user=Depends(get_current_user)):
    """ ユーザーが持つ旅行の一覧を参照
    """
    # TODO: DBからユーザーが持つtravelの一覧を参照
    sample_data = TravelInfo(
        data=[
            TravelItem(id=0, name="箱根旅行", created_at="2020/1/1", thumbnail_url="https://picsum.photos/250?image=5"),
            TravelItem(id=3, name="沖縄旅行", created_at="2020/1/2", thumbnail_url="https://picsum.photos/250?image=10"),
            TravelItem(id=10, name="北海道旅行", created_at="2020/1/3", thumbnail_url="https://picsum.photos/250?image=11"),
            TravelItem(id=15, name="修学旅行", created_at="2020/1/4", thumbnail_url="https://picsum.photos/250?image=20"),
            TravelItem(id=80, name="パリ", created_at="2020/1/5", thumbnail_url="https://picsum.photos/250?image=50")
            ])

    return sample_data
