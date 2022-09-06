package com.goodali.mn

import io.flutter.embedding.android.FlutterFragmentActivity
import com.ryanheise.audioservice.AudioServiceFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine
import com.ryanheise.audioservice.AudioServicePlugin
import android.content.Context


  class MainActivity: AudioServiceFragmentActivity() {
        override fun provideFlutterEngine(context:Context):FlutterEngine {
            return AudioServicePlugin.getFlutterEngine(context);
    }
  }