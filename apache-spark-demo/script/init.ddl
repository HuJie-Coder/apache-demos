CREATE DATABASE IF NOT EXISTS ods
    COMMENT "ODS层数据库"
    WITH DBPROPERTIES ("layer" = "ods","creater" = "jayden")
;
CREATE TABLE IF NOT EXISTS ods.babies_daily
(
    user_id    STRING,
    auction_id STRING,
    cat_id     STRING,
    cat1       STRING,
    property   STRING,
    buy_mount  STRING,
    day        STRING
)
    USING PARQUET
    COMMENT "淘宝母婴购物数据集"
    TBLPROPERTIES ("layer" = "ods","creater" = "jayden")
;
