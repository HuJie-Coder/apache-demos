package com.jaydenjhu.spark.iceberg

object IcebergMerge {


  def main(args: Array[String]): Unit = {

    session.sql(
      s"""
        | MERGE INTO local.ods.person_daily target
        | USING (SELECT * FROM ${partitionTableName}) source
        | ON target.id = source.id
        | WHEN MATCHED AND target.id = 1 THEN UPDATE SET target.data = 'jayden1_update'
        | WHEN MATCHED AND target.id = 2 THEN DELETE
        |""".stripMargin)

    session.sql(
      s"""
         | SELECT * FROM ${partitionTableName}
         |""".stripMargin)

  }


}
