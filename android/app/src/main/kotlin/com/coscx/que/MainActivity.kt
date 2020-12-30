package com.coscx.que

import android.os.Handler
import android.os.Looper
import android.content.Intent
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.github.zileyuan.umeng_analytics_push.UmengAnalyticsPushFlutterAndroid
import io.github.zileyuan.umeng_analytics_push.UmengAnalyticsPushPlugin

class MainActivity: FlutterActivity() {
    var handler: Handler = Handler(Looper.myLooper())

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    override fun onNewIntent(intent: Intent) {
        // Actively update and save the intent every time you go back to the front desk, and then you can get the latest intent
        setIntent(intent);
        super.onNewIntent(intent);
    }

    override fun onResume() {
        super.onResume()
        UmengAnalyticsPushFlutterAndroid.androidOnResume(this)
        if (getIntent().getExtras() != null) {
            var message = getIntent().getExtras().getString("message")
            if (message != null && message != "") {
                // To start the interface, wait for the engine to load, and send it to the interface with a delay of 5 seconds
                handler.postDelayed(object : Runnable {
                    override fun run() {
                        if (UmengAnalyticsPushPlugin.eventSink !=null)
                        UmengAnalyticsPushPlugin.eventSink.success(message)
                    }
                }, 5000)
            }
        }
    }

    override fun onPause() {
        super.onPause()
        UmengAnalyticsPushFlutterAndroid.androidOnPause(this)
    }
}