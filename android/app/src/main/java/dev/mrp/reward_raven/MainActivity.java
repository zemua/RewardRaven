package dev.mrp.reward_raven;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMethodCodec;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "mrp.dev/appinfo";

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
                    if (call.method.equals("getForegroundAppInfo")) {
                        Map<String, Object> foregroundAppInfo = getForegroundAppInfo();
                        result.success(foregroundAppInfo);
                    } else {
                        result.notImplemented();
                    }
                }
        );
    }

    private Map<String, Object> getForegroundAppInfo() {
        Map<String, Object> customObject = new HashMap<>();
        customObject.put("name", "John Doe");
        customObject.put("age", 30);
        customObject.put("isActive", true);
        return customObject;
    }

}
