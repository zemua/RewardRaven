package dev.mrp.reward_raven;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "mrp.dev/appinfo";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("getForegroundAppInfo")) {
                                String foregroundAppInfo = getForegroundAppInfo();
                                result.success(foregroundAppInfo);
                            }
                        }
                );
    }

    private String getForegroundAppInfo() {
        return "Some sample foreground app info";
    }

}
