package com.example.flutter_skyway;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.skyway.Peer.Browser.Canvas;
import io.skyway.Peer.Browser.MediaStream;

class RemotePeer {
    private static final boolean DEBUG = true;
    private static final String TAG = RemotePeer.class.getSimpleName();

    @NonNull
    final String peerId;
    @NonNull
    final MediaStream stream;
    Canvas canvas;

    public RemotePeer(
            @NonNull final String remotePeerId,
            @NonNull final MediaStream remoteStream) {

        peerId = remotePeerId;
        stream = remoteStream;
    }

    public void setCanvas(@Nullable final Canvas canvas) {
        if (DEBUG) Log.v(TAG, "RemotePeer#setCanvas:" + canvas);
        if (this.canvas != canvas) {
            if (this.canvas != null) {
                stream.removeVideoRenderer(canvas, 0);
            }
            this.canvas = canvas;
            if (canvas != null) {
                stream.addVideoRenderer(canvas, 0);
            }
        }
    }

    public void release() {
        if (DEBUG) Log.v(TAG, "RemotePeer#release:");
        if (canvas != null) {
            stream.removeVideoRenderer(canvas, 0);
            stream.close();
            canvas = null;
        }
    }
}