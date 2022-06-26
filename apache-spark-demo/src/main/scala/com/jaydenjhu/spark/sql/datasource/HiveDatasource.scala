package com.jaydenjhu.spark.sql.datasource

import org.apache.spark.sql.SparkSession

import java.io.File

object HiveDatasource {

  def main(args: Array[String]): Unit = {
    import session.implicits._
    session.sql("CREATE DATABASE IF NOT EXISTS ods")
    session.sql(
      """
        |CREATE TABLE IF NOT EXISTS ods.babies_daily
        |(
        |    user_id    STRING,
        |    auction_id STRING,
        |    cat_id     STRING,
        |    cat1       STRING,
        |    property   STRING,
        |    buy_mount  STRING,
        |    day        STRING
        |)
        |    USING PARQUET
        |""".stripMargin)
  }

}
