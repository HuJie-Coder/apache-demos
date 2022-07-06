package com.jaydenjhu.spark.iceberg

/*
* 测试小文件合并
* */
object IcebergDataMerge {
  def main(args: Array[String]): Unit = {
    val dataMergeTable = "local.ods.data_merge"

    // 元数据文件合并
    session.sql(
      s"""
         |CREATE TABLE IF NOT EXISTS ${dataMergeTable}
         |(
         | id BIGINT,
         | name STRING
         | )
         | TBLPROPERTIES(
         | 'write.metadata.delete-after-commit.enabled' = 'true',
         | 'write.metadata.previous-versions-max' = '5'
         | )
         |""".stripMargin)

    // 版本1
    session.sql(
      s"""
         |INSERT INTO ${dataMergeTable}
         |VALUES (3,"jayden3")
         |""".stripMargin)

    // 版本2
    session.sql(
      s"""
         |INSERT INTO ${dataMergeTable}
         |VALUES (4,"jayden5")
         |""".stripMargin)

    // 版本3
    session.sql(
      s"""
         |INSERT INTO ${dataMergeTable}
         |VALUES (5,"jayden6")
         |""".stripMargin)

    session.sql(
      s"""
         |SELECT * FROM ${dataMergeTable}
         |""".stripMargin).show()
  }
}
