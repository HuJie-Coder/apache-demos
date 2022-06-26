CREATE TABLE IF NOT EXISTS src.babies_daily
(
    user_id    STRING,
    auction_id STRING,
    cat_id     STRING,
    cat1       STRING,
    property   STRING,
    buy_mount  STRING,
    day        STRING
)
    USING PARQUET;
