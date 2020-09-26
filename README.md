# shiori

## server usage
```
$ cd server
$ python -m venv venv
$ source venv/bin/activate
$ pip install -r requirements.txt
$ uvicorn app:app --reload
```

## database setup
```
# dockerをインストール
# https://docs.docker.com/get-docker/

$ cd server
$ docker-compose build
$ docker-compose up -d

# mysqlのクライアントアプリを使えばデータベースにアクセス可
# https://dev.mysql.com/downloads/workbench/
```
