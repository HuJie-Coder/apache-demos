package com.jaydenjhu.spark.sql.datasource

import com.jaydenjhu.spark.PATH_DELIMITER
import org.apache.spark.sql.SaveMode

object CsvDatasource {

  def main(args: Array[String]): Unit = {
    // reference: https://tianchi.aliyun.com/dataset/dataDetail?dataId=45
    val babiesDatasets = session.read
      .options(Map("header" -> "true"))
      .csv(String.join(PATH_DELIMITER, dataFile.getAbsolutePath, "input", "淘宝母婴购物数据集.csv"))
    babiesDatasets
      .write
      .mode(SaveMode.Append)
      .insertInto("ods.babies_daily")
  }

}
