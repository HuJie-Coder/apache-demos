package com.jaydenjhu.spark.iceberg

object IcebergSnapshot {
  def main(args: Array[String]): Unit = {

    session.sql(
      s"""
         |SELECT * FROM ${snapshotTableName}
         |""".stripMargin).show()

    // 版本1
    session.sql(
      s"""
         |INSERT INTO ${snapshotTableName}
         |VALUES (3,"jayden3",24)
         |""".stripMargin)

    // 版本2
    session.sql(
      s"""
         |INSERT INTO ${snapshotTableName}
         |VALUES (4,"jayden5",24)
         |""".stripMargin)
  }
}
