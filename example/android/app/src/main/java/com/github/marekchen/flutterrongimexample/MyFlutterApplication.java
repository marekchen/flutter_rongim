package com.github.marekchen.flutterrongimexample;

import android.os.Handler;
import android.os.Looper;

import com.github.marekchen.flutterrongim.FlutterRongimPlugin;

import io.flutter.app.FlutterApplication;

public class MyFlutterApplication extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                FlutterRongimPlugin.init(MyFlutterApplication.this);
            }
        });
    }
}
