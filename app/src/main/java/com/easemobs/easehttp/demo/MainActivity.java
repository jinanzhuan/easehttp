package com.easemobs.easehttp.demo;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;
import android.view.View;


import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;


public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initData();
    }

    private void initData() {
        test1();
        test2();
    }

    private void test1() {
        new Thread(){
            public void run(){
                Set<Integer> names = new HashSet<>();
                List<Integer> nameList = new ArrayList<>();
                long start = System.currentTimeMillis();
                for(int i = 0; i < 100000; i++) {
                    int result = i % 10000;
                    int preSize = names.size();
                    names.add(result);
                    if(names.size() > preSize) {
                        nameList.add(result);
                    }
                }
                long end = System.currentTimeMillis();
                Log.e("TAG", "set time= "+(end - start) + " list's size() = "+nameList.size());
            }
        }.start();

    }

    private void test2() {
        new Thread(){
            public void run(){
                List<Integer> nameList = new ArrayList<>();
                long start = System.currentTimeMillis();
                for(int i = 0; i < 100000; i++) {
                    int result = i % 10000;
                    if(!nameList.contains(result)) {
                        nameList.add(result);
                    }
                }
                long end = System.currentTimeMillis();
                Log.e("TAG", "list time= "+(end - start) + " list's size() = "+nameList.size());
            }
        }.start();

    }

    public void testData(View view) {
        test1();
        test2();
    }
}