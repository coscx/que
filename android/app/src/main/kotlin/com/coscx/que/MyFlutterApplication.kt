package com.coscx.que

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.app.FlutterApplication
import io.github.zileyuan.umeng_analytics_push.UmengAnalyticsPushFlutterAndroid


class MyFlutterApplication: FlutterApplication() {
    override fun onCreate() {
        super.onCreate();
        UmengAnalyticsPushFlutterAndroid.androidPreInit(this, "5fec7e1cadb42d58269648d8", "default", "9aa304c3f2ff5e98734edb2784b43700",)
        // Register Xiaomi Push (optional)
        UmengAnalyticsPushFlutterAndroid.registerXiaomi(this, "2882303761518946758", "5911894688758")
        // Register Huawei Push (optional, need add other infomation in AndroidManifest.xml)
        UmengAnalyticsPushFlutterAndroid.registerHuawei(this)
        // Register Oppo Push (optional)
        UmengAnalyticsPushFlutterAndroid.registerOppo(this, "oppo_app_key", "oppo_app_secret")
        // Register Vivo Push (optional, need add other infomation in AndroidManifest.xml)
        UmengAnalyticsPushFlutterAndroid.registerVivo(this)
        // Register Meizu Push (optional)
        UmengAnalyticsPushFlutterAndroid.registerMeizu(this, "meizu_app_id", "meizu_app_key")
    }
}