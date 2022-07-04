package com.jaydenjhu.scala.basic

object Container {

  def main(args: Array[String]): Unit = {
    var map = Map("key1" -> "value1", "key2" -> "value2")
    map += ("key3" -> "value3")
    println(map("key1"))
  }

}
