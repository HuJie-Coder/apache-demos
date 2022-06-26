package com.jaydenjhu.spark.sql

import org.apache.spark.sql.SparkSession

import java.io.File

package object datasource {

  val PATH_DELIMITER = "/"
  val dataFile = new File("data")
  val session = SparkSession.builder()
    .master("local")
    .appName("spark-sql-demo")
    .config("spark.sql.warehouse.dir", String.join(PATH_DELIMITER, dataFile.getAbsolutePath, "warehouse"))
    .enableHiveSupport()
    .getOrCreate()
}
