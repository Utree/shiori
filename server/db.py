# for ModuleNotFoundError: No module named 'MySQLdb'
from sqlalchemy import Column, Integer, String, Float, TIMESTAMP, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql.functions import current_timestamp
from sqlalchemy.orm import *
from sqlalchemy import *
import pymysql
pymysql.install_as_MySQLdb()
# ORM

DATABASE = 'mysql://%s:%s@%s/%s?charset=utf8mb4' % (
    "dbuser",  # username
    "password",  # password
    "127.0.0.1:3306",  # ip:port
    "shiori",  # db name
    )

# DB接続用のインスタンスを作成
ENGINE = create_engine(
    DATABASE,
    convert_unicode=True,
    echo=True  # SQLをログに吐き出すフラグ
    )
# 上記のインスタンスを使って、MySQLとのセッションを張ります
session = scoped_session(
    sessionmaker(
        autoflush=False,
        autocommit=False,
        bind=ENGINE,
        )
    )
# 以下に書いていくDBモデルのベース部分を作ります
Base = declarative_base()
Base.query = session.query_property()


# DBとデータをやり取りするためのモデルを定義
class User(Base):
    __tablename__ = 'user'
    id = Column('id', Integer, primary_key=True)
    name = Column('name', String(200))
    mail = Column('mail', String(200))
    password = Column('password', String(200))
    created_at = Column('created_at', TIMESTAMP,
                        server_default=current_timestamp())
    travel_user = relationship('TravelUser')


class Travel(Base):
    __tablename__ = 'travel'
    id = Column('id', Integer, primary_key=True)
    title = Column('title', String(200))
    creation_status = Column('creation_status', String(200))
    sharing_status = Column('sharing_status', String(200))
    travel_url = Column('travel_url', String(200))
    memory_url = Column('memory_url', String(200))
    remind_at = Column('remind_at', TIMESTAMP)
    created_at = Column('created_at', TIMESTAMP,
                        server_default=current_timestamp())
    travel_user = relationship('TravelUser')
    travel_spot = relationship('TravelSpot')


class Spot(Base):
    __tablename__ = 'spot'
    id = Column('id', Integer, primary_key=True)
    arrived_at = Column('arraived_at', TIMESTAMP)
    latitude = Column('latitude', Float)
    longitude = Column('longitude', Float)
    created_at = Column('created_at', TIMESTAMP,
                        server_default=current_timestamp())
    travel_id = Column('travel_id', Integer,
                       ForeignKey('travel.id', onupdate='CASCADE',
                       ondelete='CASCADE'))
    memory_content = relationship('MemoryContent')


class Recomend(Base):
    __tablename__ = 'recomend'
    id = Column('id', Integer, primary_key=True)
    latitude = Column('latitude', Float)
    longitude = Column('longitude', Float)
    content_url = Column('content_url', String(200))
    created_at = Column('created_at', TIMESTAMP,
                        server_default=current_timestamp())


class TravelUser(Base):
    __tablename__ = 'traveluser'
    id = Column('id', Integer, primary_key=True)
    user_id = Column('user_id', Integer,
                     ForeignKey('user.id', onupdate='CASCADE',
                     ondelete='CASCADE'))
    travel_id = Column('travel_id', Integer,
                       ForeignKey('travel.id', onupdate='CASCADE',
                       ondelete='CASCADE'))
    checkin_status = Column('checkin_status', String(200))


class MemoryContent(Base):
    __tablename__ = 'memorycontent'
    id = Column('id', Integer, primary_key=True)
    spot_id = Column('spot_id', Integer,
                     ForeignKey('spot.id', onupdate='CASCADE',
                     ondelete='CASCADE'))
    content_url = Column('content_url', String(200))


if __name__ == "__main__":
    # テーブルを削除
    Base.metadata.drop_all(bind=ENGINE)
    # テーブルを新規作成
    Base.metadata.create_all(bind=ENGINE)
