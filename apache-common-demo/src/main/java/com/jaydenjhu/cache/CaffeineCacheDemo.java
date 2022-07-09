package com.jaydenjhu.cache;

import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import java.time.Duration;

/**
 * CaffeineCacheDemo
 *
 * @author jaydenjhu
 * @date 2022-07-09
 **/
public class CaffeineCacheDemo {

    static Cache<String, String> cache = Caffeine.newBuilder()
            .initialCapacity(1)
            .maximumSize(10)
            .expireAfterWrite(Duration.ofSeconds(2))
            .removalListener((key, value, cause) -> {
                System.out.println(String.format("%s was removed caused by %s", key, cause));
            })
            .build();
    public static void main(String[] args) {
        try {
            Thread.sleep(10000L);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

}
