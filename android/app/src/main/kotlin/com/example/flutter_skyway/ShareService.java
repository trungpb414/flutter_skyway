package com.example.flutter_skyway;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ServiceInfo;
import android.hardware.display.VirtualDisplay;
import android.media.MediaRecorder;
import android.media.projection.MediaProjection;
import android.media.projection.MediaProjectionManager;
import android.os.*;
import android.os.Process;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Surface;
import android.view.WindowManager;
import android.widget.Toast;

import java.io.IOException;

import static android.app.Activity.RESULT_OK;
import static android.hardware.display.DisplayManager.VIRTUAL_DISPLAY_FLAG_PRESENTATION;
import static android.os.Environment.DIRECTORY_MOVIES;

import androidx.annotation.RequiresApi;

public final class ShareService extends Service {

    private int resultCode;
    private Intent data;
    private BroadcastReceiver mScreenStateReceiver;
    static OnShareServiceListener mListener;

    private static final String TAG = ShareService.class.getSimpleName();

    static Intent newIntent(Context context, int resultCode, Intent data) {
        Intent intent = new Intent(context, ShareService.class);
        return intent;
    }

    @Override
    public void onCreate() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification notification =
                    new Notification.Builder(this)
                            .setContentTitle("Screen Recorder")
                            .setChannelId("SkywayShare")
                            .setContentText("Your screen is being shared")
                            .setSmallIcon(R.mipmap.ic_launcher)
                            .build();

            NotificationManager notificationManager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
            NotificationChannel channel = new NotificationChannel("SkywayShare", "ShareChannel", NotificationManager.IMPORTANCE_LOW);
            channel.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
            notificationManager.createNotificationChannel(channel);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                startForeground(1, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION);
            }
        } else {
            mListener.onStartSharing();
        }
        Toast.makeText(this, "Start Foreground", Toast.LENGTH_SHORT).show();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Toast.makeText(this, "Starting recording service", Toast.LENGTH_SHORT).show();
        mListener.onStartSharing();
        return START_REDELIVER_INTENT;
    }

    private void stopRecording() {
        stopSelf();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy() {
        stopRecording();
        unregisterReceiver(mScreenStateReceiver);
        stopSelf();
        Toast.makeText(this, "Recorder service stopped", Toast.LENGTH_SHORT).show();
    }
}
