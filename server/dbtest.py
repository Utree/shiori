import sys
# for ModuleNotFoundError: No module named 'MySQLdb'
import pymysql
pymysql.install_as_MySQLdb()
# ORM
from sqlalchemy import *
from sqlalchemy.orm import *
from sqlalchemy.sql.functions import current_timestamp
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, TIMESTAMP

DATABASE = 'mysql://%s:%s@%s/%s?charset=utf8mb4' % (
    "dbuser",  # ユーザー
    "password",  # パスワード
    "127.0.0.1:3306", # ip:port
    "shiori", # db name
)

#DB接続用のインスタンスを作成
ENGINE = create_engine(
    DATABASE,
    convert_unicode=True,
    echo=True  #SQLをログに吐き出すフラグ
)

#上記のインスタンスを使って、MySQLとのセッションを張ります
session = scoped_session(
    sessionmaker(
        autoflush = False,
        autocommit = False,
        bind = ENGINE,
    )
)

#以下に書いていくDBモデルのベース部分を作ります
Base = declarative_base()
Base.query = session.query_property()

#DBとデータをやり取りするためのモデルを定義
class User(Base):
    __tablename__ = 'users'
    id = Column('id', Integer, primary_key = True)
    name = Column('name', String(200))
    age = Column('age', Integer)
    created_at = Column('created_at', TIMESTAMP, server_default=current_timestamp())
    updated_at = Column('updated_at', TIMESTAMP, nullable=False, server_default=text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'))


if __name__  == "__main__":
    # テーブルを削除
    Base.metadata.drop_all(bind=ENGINE)
    # テーブルを新規作成
    Base.metadata.create_all(bind=ENGINE)

