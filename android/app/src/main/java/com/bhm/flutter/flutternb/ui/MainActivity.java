package com.bhm.flutter.flutternb.ui;

import android.os.Bundle;

import com.bhm.flutter.flutternb.plugins.FlutterPlugins;
import com.bhm.flutter.flutternb.util.Utils;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    Utils.setStatus(this);
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    FlutterPlugins.registerWith(this);
    Utils.setFilePath();
  }

  @Override
  protected void onDestroy() {
    Utils.setCallBack(null);
    super.onDestroy();
  }
}
