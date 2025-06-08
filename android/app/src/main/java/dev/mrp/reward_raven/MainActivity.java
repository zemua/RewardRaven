package dev.mrp.reward_raven;

import android.util.Log;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMethodCodec;

public class MainActivity extends FlutterActivity {

    private static final String TAG = "MainActivity";
    private static final String CHANNEL = "mrp.dev/appinfo";
    private static final String FOREGROUND_APP_INFO = "getForegroundAppInfo";
    private static final String SCREEN_ACTIVE = "getScreenActive";
    private static volatile Map<String,Object> foregroundAppDataCache;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        MethodChannel channel = new MethodChannel(
                flutterEngine.getDartExecutor().getBinaryMessenger(),
                CHANNEL,
                StandardMethodCodec.INSTANCE,
                flutterEngine.getDartExecutor().getBinaryMessenger().makeBackgroundTaskQueue()
        );

        channel.setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals(FOREGROUND_APP_INFO)) {
                        ForegroundAppChecker foregroundAppChecker = new ForegroundAppChecker(getApplicationContext());
                        Map<String,Object> data = foregroundAppChecker.getForegroundApp(foregroundAppDataCache);
                        foregroundAppDataCache = data;
                        Log.d(TAG, "foregroundAppDataCache: " + String.valueOf(foregroundAppDataCache));
                        result.success(data);
                    } else if (call.method.equals(SCREEN_ACTIVE)) {
                        ScreenLockChecker screenLockChecker = new ScreenLockChecker(getApplicationContext());
                        result.success(screenLockChecker.getScreenActive());
                    } else {
                        result.notImplemented();
                    }
                }
        );
    }

}
