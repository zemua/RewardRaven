package dev.mrp.reward_raven;

import android.app.KeyguardManager;
import android.content.Context;
import android.os.Build;
import android.os.PowerManager;

public class ScreenLockChecker {

    private static final String TAG = "ScreenLockChecker";

    private final Context mContext;

    ScreenLockChecker(Context context) {
        mContext = context;
    }

    public boolean getScreenActive() {
        return ifPhoneIsUnlocked() & ifPhoneIsOn();
    }

    private boolean ifPhoneIsUnlocked() {
        boolean isPhoneLock = false;
        if (mContext != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
            KeyguardManager myKM = (KeyguardManager) mContext.getSystemService(Context.KEYGUARD_SERVICE);
            if (myKM != null && myKM.isKeyguardLocked()) {
                isPhoneLock = true;
            }
        }
        return !isPhoneLock;
    }

    private boolean ifPhoneIsOn() {
        PowerManager pm = (PowerManager) mContext.getSystemService(Context.POWER_SERVICE);
        boolean isScreenOn = false;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT_WATCH) {
            isScreenOn = pm.isInteractive();
        }
        return isScreenOn;
    }

}
