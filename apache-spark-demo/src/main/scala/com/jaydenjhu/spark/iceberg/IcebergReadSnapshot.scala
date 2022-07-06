package com.jaydenjhu.spark.iceberg

/**
 * 读取快照文件
 */
object IcebergReadSnapshot {

  def main(args: Array[String]): Unit = {
    session.read.option("snapshot-id", "3817959098285387991").table("local.ods.metadata_merge").show()
    session.sql(
      s"""
         |SELECT * FROM local.ods.metadata_merge.snapshots
         |""".stripMargin)
      .show()
    session.sql(
      s"""
         |SELECT * FROM local.ods.metadata_merge.manifests
         |""".stripMargin)
      .show()
  }

}
