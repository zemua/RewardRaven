package dev.mrp.reward_raven;

import android.app.usage.UsageEvents;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class ForegroundAppChecker {

    private static final String TAG = "ForegroundAppChecker";

    private static final String TIMESTAMP = "timestamp";
    private static final String PACKAGE_NAME = "packageName";
    private static final String ACTIVITY_NAME = "activityName";
    private static final String APP_NAME = "appName";

    private UsageStatsManager mUsageStatsManager;
    private PackageManager packageManager;

    ForegroundAppChecker(Context context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            mUsageStatsManager = (UsageStatsManager) context.getSystemService(Context.USAGE_STATS_SERVICE);
            packageManager = context.getPackageManager();
        }
    }

    public Map<String,Object> getForegroundApp(Map<String,Object> previous) throws SecurityException{
        if (!(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP)) {
            throw new SecurityException("ForegroundAppChecker only works on Android 5 and above");
        }

        Map<String,Object> lastResult = Objects.isNull(previous) ? new HashMap<>() : previous;

        Long lastQuery = (Long)lastResult.get(TIMESTAMP);
        Long now = System.currentTimeMillis();
        Long queryStartTime;
        if(Objects.isNull(lastQuery) || lastQuery == 0L){
            queryStartTime = now - 1000*60*60*24*7;
            Log.d(TAG, "queryStartTime set to the last 7 days: " + new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date(queryStartTime)));
        } else {
            // datos del query desde el último query
            // nota: cuando la duración es muy pequeña, Android no devuelve datos
            //       se consulta 1 segundo más de lo que necesitamos
            //       el cual parece devolver todos los datos
            // actualización: con 1 segundo algunos eventos se pierden
            //         parece que siempre funciona con 1.5 segundos
            queryStartTime = lastQuery - 5000L;
            Log.d(TAG, "queryStartTime set before the last query: " + new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date(queryStartTime)));
        }

        UsageEvents levents = mUsageStatsManager.queryEvents(queryStartTime, now);
        UsageEvents.Event event = new UsageEvents.Event();
        Map<String,Object> result = new HashMap<>();
        while (levents.hasNextEvent()) {
            levents.getNextEvent(event);
            Log.d(TAG, "Retrieved event info -- type: " + event.getEventType() + " / package name: " + event.getPackageName() + " / activity name: " + event.getClassName() + " / timestamp: " + event.getTimeStamp());

            if (event.getEventType() == UsageEvents.Event.ACTIVITY_RESUMED) {
                result.put(TIMESTAMP, event.getTimeStamp());
                result.put(PACKAGE_NAME, event.getPackageName());
                result.put(ACTIVITY_NAME, event.getClassName());
                try {
                    PackageInfo pi = packageManager.getPackageInfo((String)result.get(PACKAGE_NAME), 0);
                    result.put(APP_NAME, pi.applicationInfo.loadLabel(packageManager));
                } catch (PackageManager.NameNotFoundException e) {
                    Log.e(TAG, "Could not find package name", e);
                }
                // we do not break the loop, if there is another ACTIVITY_RESUMED more recent than this one, we will overwrite it
            }
        }

        Log.d(TAG, "Retrieved event info -- app name: " + result.get(APP_NAME) + " / package name: " + result.get(PACKAGE_NAME) + " / activity name: " + result.get(ACTIVITY_NAME) + " / timestamp: " + result.get(TIMESTAMP));

        return result;
    }
}
