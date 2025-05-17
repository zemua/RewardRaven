package dev.mrp.reward_raven;

import androidx.annotation.NonNull;

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
                        ForegroundAppChecker foregroundAppChecker = new ForegroundAppChecker(getApplicationContext());
                        Map<String,Object> data = foregroundAppChecker.getForegroundApp(null);
                        result.success(data);
                    } else {
                        result.notImplemented();
                    }
                }
        );
    }

}
