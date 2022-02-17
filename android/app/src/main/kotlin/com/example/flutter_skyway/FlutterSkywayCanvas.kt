package com.example.flutter_skyway

import android.content.Context
import android.util.Log
import android.util.SparseArray
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.skyway.Peer.Browser.Canvas
import java.lang.IndexOutOfBoundsException

class FlutterSkywayCanvas(
        context: Context,
        messenger: BinaryMessenger,
        id: Int, args: Any?) : PlatformView, MethodChannel.MethodCallHandler {

    private val mId = id
    private val canvas: Canvas = Canvas(context)

    companion object {
        private const val DEBUG = true // set false on production
        private val TAG = FlutterSkywayCanvas::class.java.simpleName
        private val sViews = SparseArray<FlutterSkywayCanvas>()

        fun findViewById(id: Int?): FlutterSkywayCanvas? {
            if (id != null) {
                return sViews[id]
            } else {
                return null
            }

        }
    }

    init {
        if (DEBUG) Log.v(TAG, "ctor:id=$id")
        sViews.append(id, this)
        canvas.mirror = false
        canvas.setBackgroundColor(0x3fff0000.toInt())
        MethodChannel(messenger, Const.SKYWAY_CANVAS_VIEW + "_$id").also {
            it.setMethodCallHandler(this)
        }
    }

    override fun getView(): View {
        if (DEBUG) Log.v(TAG, "getView:")
        return canvas;
    }

    override fun dispose() {
        if (DEBUG) Log.v(TAG, "dispose:")
        sViews.remove(mId)

    }

    fun getCanvas(): Canvas {
        return canvas
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (DEBUG) Log.v(TAG, "onMethodCall:${call}");
    }
}

class CanvasFactory(private val messenger: BinaryMessenger)
    : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView = FlutterSkywayCanvas(context!!, messenger, viewId, args)
}
