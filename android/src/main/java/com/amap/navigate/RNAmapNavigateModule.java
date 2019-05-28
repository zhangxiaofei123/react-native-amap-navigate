
package com.amap.navigate;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

public class RNAmapNavigateModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNAmapNavigateModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNAmapNavigate";
  }
}