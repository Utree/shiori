from init_db import (session_scope, User, Travel, Spot, Recomend, TravelUser,
                MemoryContent)
import bcrypt
import datetime
from datetime import timedelta

# パスワードのハッシュ化
salt = bcrypt.gensalt(rounds=10, prefix=b'2a')
password = "password".encode()
hashed_passwd = bcrypt.hashpw(password, salt)
# userを追加
user_samples = [
    User(name='ken', email='ken@example.com', password=hashed_passwd),
    User(name='susan', email='susan@example.org', password=hashed_passwd),
    User(name='leo', email='leo@example.jp', password=hashed_passwd),
    User(name='edd', email='edd@example.co.jp', password=hashed_passwd),
    User(name='queen', email='queen@example.co', password=hashed_passwd)
    ]
with session_scope() as s:
    for us in user_samples:
        s.add(us)
# travelを追加
travel_samples = [
    Travel(title="沖縄旅行"),
    Travel(title="修学旅行"),
    Travel(title="パリ研修"),
    Travel(title="北海道旅行"),
    Travel(title="京都"),
    Travel(title="アメリカ")
    ]
with session_scope() as s:
    for ts in travel_samples:
        s.add(ts)
# traveluser
traveluser_samples = [
    TravelUser(user_id=1, travel_id=2),
    TravelUser(user_id=1, travel_id=3),
    TravelUser(user_id=1, travel_id=4),
    TravelUser(user_id=2, travel_id=1),
    TravelUser(user_id=3, travel_id=3),
    TravelUser(user_id=4, travel_id=4),
    TravelUser(user_id=5, travel_id=5)
    ]
with session_scope() as s:
    for ts in traveluser_samples:
        s.add(ts)

today = datetime.datetime.now()
spot_samples = [
    Spot(name="美ら海水族館", latitude=30.4666087, longitude=122.7861914,
         travel_id=1, arrived_at=today),
    Spot(name="首里城公園", latitude=26.2183181, longitude=127.7131681,
         travel_id=1, arrived_at=today+timedelta(hours=1)),
    Spot(name="竹富島", latitude=24.3261132, longitude=124.0715568,
         travel_id=1, arrived_at=today+timedelta(hours=2)),
    Spot(name="厳島神社", latitude=34.2964981, longitude=132.3167864,
         travel_id=2, arrived_at=today),
    Spot(name="原爆ドーム", latitude=34.395483, longitude=132.4514087,
         travel_id=2, arrived_at=today+timedelta(hours=1)),
    Spot(name="平和記念公園", latitude=34.3915416, longitude=132.4510092,
         travel_id=2, arrived_at=today+timedelta(hours=2)),
    Spot(name="エッフェル塔", latitude=48.8583701, longitude=2.292298,
         travel_id=3, arrived_at=today),
    Spot(name="ルーブル美術館", latitude=48.8606111, longitude=2.3354607,
         travel_id=3, arrived_at=today+timedelta(hours=1)),
    Spot(name="ノートルダム大聖堂", latitude=49.2068423, longitude=2.5837157,
         travel_id=3, arrived_at=today+timedelta(hours=2)),
    Spot(name="阿寒湖", latitude=43.4558613, longitude=144.0288093,
         travel_id=4, arrived_at=today),
    Spot(name="知床国立公園", latitude=44.1203382, longitude=145.1361039,
         travel_id=4, arrived_at=today+timedelta(hours=1)),
    Spot(name="時計台", latitude=43.0631363, longitude=141.3503327,
         travel_id=4, arrived_at=today+timedelta(hours=2)),
    Spot(name="京都タワー", latitude=34.9875283, longitude=135.7571393,
         travel_id=5, arrived_at=today),
    Spot(name="嵐山", latitude=35.0133481, longitude=135.656786,
         travel_id=5, arrived_at=today+timedelta(hours=1)),
    Spot(name="宇治", latitude=34.9076742, longitude=135.6800743,
         travel_id=5, arrived_at=today+timedelta(hours=2)),
    Spot(name="Statue of Liberty", latitude=40.6961397, longitude=-74.5387411,
         travel_id=6, arrived_at=today),
    Spot(name="Empire State Building", latitude=40.6768747,
         longitude=-74.0618659, travel_id=6,
         arrived_at=today+timedelta(hours=1)),
    Spot(name="One World Trade Center", latitude=40.7025003,
         longitude=-74.0832365, travel_id=6,
         arrived_at=today+timedelta(hours=2)),
    ]
with session_scope() as s:
    for ss in spot_samples:
        s.add(ss)

memorycontents_sample = [
        MemoryContent(spot_id=1, content_url="https://www.dropbox.com/s/qujuzaxnwfcwks0/churaumi.jpg?raw=1"),  # 美ら海水族館
        MemoryContent(spot_id=2, content_url="https://www.dropbox.com/s/o2rgf23yjhmb7dh/shuri.jpg?raw=1"),  # 首里城公園
        MemoryContent(spot_id=3, content_url="https://www.dropbox.com/s/gmramrt83e90dev/taketomi.jpg?raw=1"),  # 竹富島
        MemoryContent(spot_id=4, content_url="https://www.dropbox.com/s/mjz5xda7dmfvpl8/itsukushima.jpg?raw=1"),  # 厳島神社
        MemoryContent(spot_id=5, content_url="https://www.dropbox.com/s/1hi7wgbwcp7e153/genbaku.jpg?raw=1"),  # 原爆ドーム
        MemoryContent(spot_id=6, content_url="https://www.dropbox.com/s/pcp9rem1ylr3sv5/heiwa.jpg?raw=1"),  # 平和記念公園
        MemoryContent(spot_id=7, content_url="https://www.dropbox.com/s/i0q76txkyh1vr8q/effel.jpg?raw=1"),  # エッフェル塔
        MemoryContent(spot_id=8, content_url="https://www.dropbox.com/s/ycru6g96i5qtymw/rubul.jpg?raw=1"),  # ルーブル美術館
        MemoryContent(spot_id=9, content_url="https://www.dropbox.com/s/1fstbq6ysyvt2au/notoldum.jpg?raw=1"),  # ノートルダム大聖堂
        MemoryContent(spot_id=10, content_url="https://www.dropbox.com/s/p7ycp2jx3vh0ya4/akan.jpg?raw=1"),  # 阿寒湖
        MemoryContent(spot_id=11, content_url="https://www.dropbox.com/s/1hdzcpdfzzy9sc3/shiretoko.jpg?raw=1"),  # 知床国立公園
        MemoryContent(spot_id=12, content_url="https://www.dropbox.com/s/nlcbmf9iciqzcm0/tokei.jpg?raw=1"),  # 時計台
        MemoryContent(spot_id=13, content_url="https://www.dropbox.com/s/rxr61x9to8ha5c5/kyototower.jpg?raw=1"),  # 京都タワー
        MemoryContent(spot_id=14, content_url="https://www.dropbox.com/s/22d7i6a5wzedrkz/arashiyama.jpg?raw=1"),  # 嵐山
        MemoryContent(spot_id=15, content_url="https://www.dropbox.com/s/m5eonmfxqqzsjrk/uji.jpg?raw=1"),  # 宇治
        MemoryContent(spot_id=16, content_url="https://www.dropbox.com/s/tm67pk7nysvl09p/statuofliberty.jpg?raw=1"),  # Statue of Liverty
        MemoryContent(spot_id=17, content_url="https://www.dropbox.com/s/6anbdqf3q18guxo/empirestatebuilding.jpg?raw=1"),  # Empire　state Building
        MemoryContent(spot_id=18, content_url="https://www.dropbox.com/s/mwdzj8g922jz8d3/oneworldtrade.jpg?raw=1"),  # One World Trade Center
        MemoryContent(spot_id=3, content_url="https://www.dropbox.com/s/nb3e9fdxv80dx19/hakone.jpg?raw=1"),
        MemoryContent(spot_id=1, content_url="https://www.dropbox.com/s/r7qrgi3z4qqm973/okinawa.jpg?raw=1"),
        MemoryContent(spot_id=10, content_url="https://www.dropbox.com/s/9ebliz8jakptqqi/hokkaido.jpg?raw=1"),
        MemoryContent(spot_id=2, content_url="https://www.dropbox.com/s/y0kyy2tp0wlqnem/school.jpg?raw=1"),
        ]
with session_scope() as s:
    for ms in memorycontents_sample:
        s.add(ms)


recomends_sample = [
    Recomend(name="oknawa1", latitude=26.3229427, longitude=128.0562889, content_url="https://www.dropbox.com/s/pa80zc8cz8g1f8g/rec0.jpg?raw=1"),
    Recomend(name="oknawa2", latitude=26.4189616, longitude=127.7019182, content_url="https://www.dropbox.com/s/zmwb6gx7b56vr8k/rec1.jpg?raw=1"),
    Recomend(name="oknawa3", latitude=26.7654126, longitude=128.1047837, content_url="https://www.dropbox.com/s/9if32q81q7gblgt/rec2.jpg?raw=1"),
    Recomend(name="oknawa4", latitude=26.8117052, longitude=128.2055001, content_url="https://www.dropbox.com/s/bgq3hom20jyabls/rec5.jpg?raw=1"),
    Recomend(name="oknawa5", latitude=26.2697277, longitude=127.7810646, content_url="https://www.dropbox.com/s/z80ar18b8gv05k1/rec4.jpg?raw=1"),
    Recomend(name="oknawa6", latitude=26.4296851, longitude=127.8584233, content_url="https://www.dropbox.com/s/qpvzwjmhwa5tkpy/rec6.jpg?raw=1"),
    Recomend(name="oknawa7", latitude=26.5363281, longitude=127.9985691, content_url="https://www.dropbox.com/s/sxzi3j3506rc6on/rec3.jpg?raw=1"),
    Recomend(name="oknawa8", latitude=26.1803231, longitude=127.3056579, content_url="https://www.dropbox.com/s/cmxqmn01q2ei2cw/rec7.jpg?raw=1"),
    Recomend(name="syugaku1", latitude=34.317363, longitude=132.5950822, content_url="https://www.dropbox.com/s/pa80zc8cz8g1f8g/rec0.jpg?raw=1"),
    Recomend(name="syugaku2", latitude=34.720179, longitude=133.5124406, content_url="https://www.dropbox.com/s/zmwb6gx7b56vr8k/rec1.jpg?raw=1"),
    Recomend(name="syugaku3", latitude=35.4371869, longitude=133.2679948, content_url="https://www.dropbox.com/s/9if32q81q7gblgt/rec2.jpg?raw=1"),
    Recomend(name="syugaku4", latitude=34.8352768, longitude=133.4504764, content_url="https://www.dropbox.com/s/bgq3hom20jyabls/rec5.jpg?raw=1"),
    Recomend(name="syugaku5", latitude=34.3973327, longitude=132.1053379, content_url="https://www.dropbox.com/s/z80ar18b8gv05k1/rec4.jpg?raw=1"),
    Recomend(name="syugaku6", latitude=34.2320122, longitude=131.7163532, content_url="https://www.dropbox.com/s/qpvzwjmhwa5tkpy/rec6.jpg?raw=1"),
    Recomend(name="syugaku7", latitude=34.3156965, longitude=132.1287558, content_url="https://www.dropbox.com/s/sxzi3j3506rc6on/rec3.jpg?raw=1"),
    Recomend(name="syugaku8", latitude=34.4460351, longitude=132.3869345, content_url="https://www.dropbox.com/s/cmxqmn01q2ei2cw/rec7.jpg?raw=1"),
    Recomend(name="pari1", latitude=47.2814699, longitude=-3.9178638, content_url="https://www.dropbox.com/s/pa80zc8cz8g1f8g/rec0.jpg?raw=1"),
    Recomend(name="pari2", latitude=47.8559335, longitude=0.6359692, content_url="https://www.dropbox.com/s/zmwb6gx7b56vr8k/rec1.jpg?raw=1"),
    Recomend(name="pari3", latitude=49.8153078, longitude=1.9213696, content_url="https://www.dropbox.com/s/9if32q81q7gblgt/rec2.jpg?raw=1"),
    Recomend(name="pari4", latitude=47.0179577, longitude=5.9027273, content_url="https://www.dropbox.com/s/bgq3hom20jyabls/rec5.jpg?raw=1"),
    Recomend(name="pari5", latitude=44.926169, longitude=5.8038503, content_url="https://www.dropbox.com/s/z80ar18b8gv05k1/rec4.jpg?raw=1"),
    Recomend(name="pari6", latitude=43.8823125, longitude=1.6839773, content_url="https://www.dropbox.com/s/qpvzwjmhwa5tkpy/rec6.jpg?raw=1"),
    Recomend(name="pari7", latitude=43.7812653, longitude=-0.752241, content_url="https://www.dropbox.com/s/sxzi3j3506rc6on/rec3.jpg?raw=1"),
    Recomend(name="pari8", latitude=44.3810558, longitude=0.5496389, content_url="https://www.dropbox.com/s/cmxqmn01q2ei2cw/rec7.jpg?raw=1"),
    Recomend(name="hokkaido1", latitude=44.0635687, longitude=142.2895531, content_url="https://www.dropbox.com/s/pa80zc8cz8g1f8g/rec0.jpg?raw=1"),
    Recomend(name="hokkaido2", latitude=43.7890301, longitude=143.1105591, content_url="https://www.dropbox.com/s/zmwb6gx7b56vr8k/rec1.jpg?raw=1"),
    Recomend(name="hokkaido3", latitude=43.2703225, longitude=143.0929661, content_url="https://www.dropbox.com/s/9if32q81q7gblgt/rec2.jpg?raw=1"),
    Recomend(name="hokkaido4", latitude=43.1164091, longitude=143.8787862, content_url="https://www.dropbox.com/s/bgq3hom20jyabls/rec5.jpg?raw=1"),
    Recomend(name="hokkaido5", latitude=42.9234715, longitude=144.3655256, content_url="https://www.dropbox.com/s/z80ar18b8gv05k1/rec4.jpg?raw=1"),
    Recomend(name="hokkaido6", latitude=41.9802216, longitude=141.2339738, content_url="https://www.dropbox.com/s/qpvzwjmhwa5tkpy/rec6.jpg?raw=1"),
    Recomend(name="hokkaido7", latitude=41.5208404, longitude=140.2839525, content_url="https://www.dropbox.com/s/sxzi3j3506rc6on/rec3.jpg?raw=1"),
    Recomend(name="hokkaido8", latitude=42.4103389, longitude=141.7441705, content_url="https://www.dropbox.com/s/cmxqmn01q2ei2cw/rec7.jpg?raw=1"),
    Recomend(name="kyoto1", latitude=34.7475399, longitude=135.8412658, content_url="https://www.dropbox.com/s/pa80zc8cz8g1f8g/rec0.jpg?raw=1"),
    Recomend(name="kyoto2", latitude=34.8990409, longitude=135.7368886, content_url="https://www.dropbox.com/s/zmwb6gx7b56vr8k/rec1.jpg?raw=1"),
    Recomend(name="kyoto3", latitude=35.037259, longitude=135.6514203, content_url="https://www.dropbox.com/s/9if32q81q7gblgt/rec2.jpg?raw=1"),
    Recomend(name="kyoto4", latitude=35.2234521, longitude=135.5031743, content_url="https://www.dropbox.com/s/bgq3hom20jyabls/rec5.jpg?raw=1"),
    Recomend(name="kyoto5", latitude=35.3592706, longitude=135.4199751, content_url="https://www.dropbox.com/s/z80ar18b8gv05k1/rec4.jpg?raw=1"),
    Recomend(name="kyoto6", latitude=35.2666918, longitude=135.6113333, content_url="https://www.dropbox.com/s/qpvzwjmhwa5tkpy/rec6.jpg?raw=1"),
    Recomend(name="kyoto7", latitude=35.0880249, longitude=135.6234351, content_url="https://www.dropbox.com/s/sxzi3j3506rc6on/rec3.jpg?raw=1"),
    Recomend(name="kyoto8", latitude=35.0323045, longitude=135.6219223, content_url="https://www.dropbox.com/s/cmxqmn01q2ei2cw/rec7.jpg?raw=1"),
    Recomend(name="us1", latitude=40.5205851, longitude=-74.2012956, content_url="https://www.dropbox.com/s/pa80zc8cz8g1f8g/rec0.jpg?raw=1"),
    Recomend(name="us2", latitude=40.5717186, longitude=-73.9321306, content_url="https://www.dropbox.com/s/zmwb6gx7b56vr8k/rec1.jpg?raw=1"),
    Recomend(name="us3", latitude=40.6738683, longitude=-74.0529802, content_url="https://www.dropbox.com/s/9if32q81q7gblgt/rec2.jpg?raw=1"),
    Recomend(name="us4", latitude=40.7727419, longitude=-74.0571, content_url="https://www.dropbox.com/s/bgq3hom20jyabls/rec5.jpg?raw=1"),
    Recomend(name="us5", latitude=40.8434243, longitude=-74.2246416, content_url="https://www.dropbox.com/s/z80ar18b8gv05k1/rec4.jpg?raw=1"),
    Recomend(name="us6", latitude=40.864199, longitude=-74.155977, content_url="https://www.dropbox.com/s/qpvzwjmhwa5tkpy/rec6.jpg?raw=1"),
    Recomend(name="us7", latitude=40.7415345, longitude=-74.155977, content_url="https://www.dropbox.com/s/sxzi3j3506rc6on/rec3.jpg?raw=1"),
    Recomend(name="us8", latitude=40.6103037, longitude=-74.1285112, content_url="https://www.dropbox.com/s/cmxqmn01q2ei2cw/rec7.jpg?raw=1"),
    ]
with session_scope() as s:
    for rs in recomends_sample:
        s.add(rs)

"""
# 参照
with session_scope() as s:
    users = s.query(User).all()
    print(users[0].name)  # sessionのスコープ内でしか参照できない
"""
"""
# 参照
with session_scope() as s:
    # 内部結合
    d = s.query(TravelUser, User).filter(TravelUser.user_id == User.id).all()
    # table[2]を指定してcolumn[1]を参照
    print(d[2][1].name)
"""


# 参照
from sqlalchemy.sql import text

t = text("""
SELECT id, content_url, latitude, longitude,
  (
    6371 * acos( -- kmの場合は6371、mileの場合は3959
      cos(radians(35.6804067))
      * cos(radians(latitude))
      * cos(radians(longitude) - radians(139.7550152))
      + sin(radians(35.6804067))
      * sin(radians(latitude))
    )
  ) AS distance
FROM recomend ORDER BY distance;
""")
with session_scope() as s:
    # 内部結合
    for d in s.execute(t):
        print(f"{d.content_url} {d.latitude} {d.longitude} {d.distance}")
