package com.jaydenjhu.spark

import org.apache.spark.sql.SparkSession

import java.io.File

package object iceberg {
  val snapshotTableName = "local.ods.person"
  val partitionTableName = "local.ods.person_daily"
  val dataFile = new File("data")
  val session = SparkSession.builder()
    .master("local")
    .appName("spark-iceberg-demo")
    .config("spark.sql.catalog.local", "org.apache.iceberg.spark.SparkCatalog")
    .config("spark.sql.catalog.local.type", "hadoop")
    .config("spark.sql.catalog.local.warehouse", String.join(PATH_DELIMITER, dataFile.getAbsolutePath, "iceberg_warehouse"))
    .getOrCreate()

}
