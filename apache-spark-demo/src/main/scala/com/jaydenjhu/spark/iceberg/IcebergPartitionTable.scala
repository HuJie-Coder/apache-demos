package com.jaydenjhu.spark.iceberg

object IcebergPartitionTable {

  def main(args: Array[String]): Unit = {
    session.sql(
      s"""
         |INSERT OVERWRITE ${partitionTableName} PARTITION(etl_date=20220704)
         |VALUES
         |  (1,"jayden1")
         |,(2,"jayden2")
         |""".stripMargin)

  }

}
