package com.jaydenjhu.spark.iceberg

object IcebergDelete {

  def main(args: Array[String]): Unit = {

//    session.sql(
//      s"""
//         | DELETE FROM local.ods.person_daily WHERE etl_date='20220704'
//         |""".stripMargin)

    session.sql(
      s"""
         |SELECT * FROM local.ods.person_daily
         |""".stripMargin)
  }

}
