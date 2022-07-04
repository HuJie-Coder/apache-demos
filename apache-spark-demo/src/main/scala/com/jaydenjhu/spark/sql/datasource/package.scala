package com.jaydenjhu.spark.sql

import com.jaydenjhu.spark.PATH_DELIMITER
import org.apache.spark.sql.SparkSession

import java.io.File

package object datasource {

  val dataFile = new File("data")
  val session = SparkSession.builder()
    .master("local")
    .appName("spark-sql-demo")
    .config("spark.sql.warehouse.dir", String.join(PATH_DELIMITER, dataFile.getAbsolutePath, "warehouse"))
    .enableHiveSupport()
    .getOrCreate()

}
