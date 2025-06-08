package dev.mrp.reward_raven;

import android.content.Context;
import android.content.Intent;

public class BlockLauncher {

    public void launchBlockerActivity(Context context) {
        Intent intent = new Intent(context, MainActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK|Intent.FLAG_ACTIVITY_SINGLE_TOP);
        context.startActivity(intent);
    }

}
