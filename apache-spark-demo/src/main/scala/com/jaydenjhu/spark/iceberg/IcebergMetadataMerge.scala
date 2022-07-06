package com.jaydenjhu.spark.iceberg

object IcebergMetadataMerge {

  def main(args: Array[String]): Unit = {
    val metadataMergeTable = "local.ods.metadata_merge"

    // 元数据文件合并
    session.sql(
      s"""
         |CREATE TABLE IF NOT EXISTS ${metadataMergeTable}
         |(
         | id BIGINT,
         | name STRING
         | )
         | TBLPROPERTIES(
         | 'write.metadata.delete-after-commit.enabled' = 'true',
         | 'write.metadata.previous-versions-max' = '2'
         | )
         |""".stripMargin)

    // 版本1
    session.sql(
      s"""
         |INSERT INTO ${metadataMergeTable}
         |VALUES (3,"jayden3")
         |""".stripMargin)

    // 版本2
    session.sql(
      s"""
         |INSERT INTO ${metadataMergeTable}
         |VALUES (4,"jayden5")
         |""".stripMargin)

    // 版本3
    session.sql(
      s"""
         |INSERT INTO ${metadataMergeTable}
         |VALUES (5,"jayden6")
         |""".stripMargin)

    session.sql(
      s"""
         |SELECT * FROM ${metadataMergeTable}
         |""".stripMargin).show()
  }

}
