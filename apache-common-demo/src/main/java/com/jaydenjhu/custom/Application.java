package com.jaydenjhu.custom;

import com.google.common.base.Objects;
import com.google.common.base.Optional;
import com.google.common.base.Preconditions;
import java.util.ArrayList;
import java.util.List;

/**
 * Application
 *
 * @author jaydenjhu
 * @date 2022-07-06
 **/
public class Application {

    public static void makeOom() {
        /*
         * OnOutOfMemoryError 验证测试
         * */
        List<Object> list = new ArrayList<>(10000);
        while (true) {
            list.add(new Object());
        }
    }

    public static void guavaDemo(){
        Optional<Integer> interger = Optional.of(Integer.valueOf(1));
        Preconditions.checkArgument(true);
        int i = 10 ;
        Preconditions.checkArgument( i < 2,"Arguments %s was more then 0",i);

    }


    public static void main(String[] args) {
        makeOom();
//        guavaDemo();
    }

}
