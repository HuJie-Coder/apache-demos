package com.jaydenjhu.spark.iceberg

object IcebergMetadata {

  def main(args: Array[String]): Unit = {
    session.sql(s"CREATE TABLE IF NOT EXISTS ${snapshotTableName}(id bigint,data string) USING iceberg")
    session.sql(s"ALTER TABLE ${snapshotTableName} ADD COLUMN age INT")
    session.sql(
      s"""
         |CREATE TABLE IF NOT EXISTS ${partitionTableName}
         |(
         |  id BIGINT,
         |  name STRING
         |)
         |USING iceberg
         |PARTITIONED BY(
         | etl_date STRING COMMENT "yyyyMMdd"
         | )
         |""".stripMargin)
  }

}
