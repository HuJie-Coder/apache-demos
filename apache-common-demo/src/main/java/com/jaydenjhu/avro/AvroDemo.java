package com.jaydenjhu.avro;

import java.io.File;
import java.io.IOException;
import org.apache.avro.Schema;
import org.apache.avro.Schema.Parser;
import org.apache.avro.file.DataFileReader;
import org.apache.avro.file.DataFileWriter;
import org.apache.avro.generic.GenericData.Record;
import org.apache.avro.generic.GenericDatumReader;
import org.apache.avro.generic.GenericDatumWriter;
import org.apache.avro.generic.GenericRecord;
import org.apache.avro.io.DatumReader;

/**
 * avro
 *  1. 定义 schema
 *  2. 写入数据
 *
 * @author jaydenjhu
 * @date 2022-06-23
 **/
public class AvroDemo {

    static File dataFile = new File("user.avro");
    static File schemaFile = new File("user.avsc");
    static Schema schema;

    static {
        try {
            schema = new Parser().parse(schemaFile);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 序列化
     */
    public static void serialize() {
        try {
            Record userOne = new Record(schema);
            userOne.put("name", "Jayden");
            userOne.put("favorite_number", 5);

            Record userTwo = new Record(schema);
            userTwo.put("name", "Jayden");
            userTwo.put("favorite_number", 5);

            GenericDatumWriter<GenericRecord> datumWriter = new GenericDatumWriter<>(schema);
            DataFileWriter<GenericRecord> writer = new DataFileWriter<>(datumWriter);
            writer.create(schema, dataFile);
            writer.append(userOne);
            writer.append(userTwo);
            writer.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 反序列化
     */
    public static void deserialize() {
        try {
            DatumReader<GenericRecord> datumReader = new GenericDatumReader<GenericRecord>(schema);
            DataFileReader<GenericRecord> reader = new DataFileReader<>(dataFile, datumReader);
            while (reader.hasNext()) {
                GenericRecord record = reader.next();
                System.out.println(record);
            }
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        serialize();
        deserialize();
    }

}
