package com.example.flutter_skyway

import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.skyway.Peer.*
import java.util.*
import kotlin.collections.HashMap

class MainActivity : FlutterActivity() {
    private var _localViewId: Int = 0
    private var _remoteViewIds = IntArray(0)

    private var peers: MutableMap<String, FlutterSkywayPeer> = HashMap()

    companion object {
        private const val DEBUG = true
        private val TAG = MainActivity::class.java.simpleName
    }

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        if (DEBUG) Log.v(TAG, "onCreate:");
    }

    override fun onDestroy() {
        if (DEBUG) Log.v(TAG, "onDestroy:");
        releaseAll()
        super.onDestroy()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        if (DEBUG) Log.v(TAG, "configureFlutterEngine:");
        flutterEngine
                .platformViewsController
                .registry
                .registerViewFactory(Const.SKYWAY_CANVAS_VIEW,
                        CanvasFactory(flutterEngine.dartExecutor.binaryMessenger))
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, Const.METHOD_CHANNEL_NAME)
                .setMethodCallHandler { call, result -> onMethodCall(call, result) }
    }

    private fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "connect" -> {
                connect(call, result)
            }
            "disconnect" -> {
                disconnect(call, result);
            }
            "startLocalStream" -> {
                startLocalStream(call, result)
            }
            "startRemoteStream" -> {
                startRemoteStream(call, result)
            }
            "listAllPeers" -> {
                listAllPeers(call, result)
            }
            "hangUp" -> {
                hangUp(call, result)
            }
            "call" -> {
                call(call, result)
            }
            "join" -> {
                join(call, result)
            }
            "leave" -> {
                leave(call, result)
            }
            "accept" -> {
                accept(call, result)
            }
            "reject" -> {
                reject(call, result)
            }
            else -> {
                Log.w(TAG, "unknown method call${call}")
            }
        }
    }

    private fun releaseAll() {
        if (DEBUG) Log.v(TAG, "releaseAll:")
        val copy: MutableMap<String, FlutterSkywayPeer>
        synchronized(peers) {
            copy = HashMap(peers)
            peers.clear()
        }
        if (copy.isNotEmpty()) {
            for ((_, v) in copy) {
                v.release()
            }
        }
    }

    private fun connect(call: MethodCall, result: MethodChannel.Result) {
        if (DEBUG) Log.v(TAG, "connect:${call}")
        _localViewId = 0
        _remoteViewIds = IntArray(0)
        val local = call.argument<Int>("localViewId")
        if (local != null) {
            _localViewId = local
        }
        val remotes = call.argument<IntArray>("remoteViewIds")
        if (remotes != null) {
            _remoteViewIds = remotes
        }
        val apiKey = call.argument<String>("apiKey")
        var domain = call.argument<String>("domain")
        if (domain == null) {
            domain = "localhost"
        }
        if (DEBUG) Log.v(TAG, "connect:domain=${domain},apiKey=${apiKey}")
        if (apiKey != null) {
            // Initialize Peer
            val option = PeerOption()
            option.key = apiKey
            option.domain = domain
            option.debug = Peer.DebugLevelEnum.ALL_LOGS
            val peer = Peer(this, option)

            // OPEN
            peer.on(Peer.PeerEventEnum.OPEN) { `object` ->
                // Show my ID
                val ownId = `object` as String
                val wrapped = FlutterSkywayPeer(this,
                        ownId, peer,
                        flutterEngine!!.dartExecutor.binaryMessenger)
                synchronized(peers) {
                    peers.put(ownId, wrapped)
                }
                result.success(ownId)
            }

            // ERROR
            peer.on(Peer.PeerEventEnum.ERROR) { `object` ->
                val error = `object` as PeerError
                if (DEBUG) Log.w(TAG, "[On/Error]$error")
                Toast.makeText(applicationContext, "Error on connecting peer(API key would be wrong),$error", Toast.LENGTH_LONG).show()
            }

            // CLOSE
            peer.on(Peer.PeerEventEnum.CLOSE) {
                if (DEBUG) Log.v(TAG, "[On/Close]")
                synchronized(peers) {
                    peers.remove(peer.identity())?.release()
                }
            }
        } else {
            result.error("Invalid apiKey", "Invalid apiKey", "Invalid apiKey")
        }
    }

    private fun disconnect(call: MethodCall, result: MethodChannel.Result) {
        if (DEBUG) Log.v(TAG, "disconnect:${call}")
        val peerId = call.argument<String>("peerId")
        if (peerId != null) {
            synchronized(peers) {
                peers.remove<String?, FlutterSkywayPeer>(peerId)?.release()
            }
        }
        result.success("success")
    }

    private fun startLocalStream(call: MethodCall, result: MethodChannel.Result) {
        if (DEBUG) Log.v(TAG, "startLocalStream:${call}")
        val peerId = call.argument<String>("peerId")
        val localVideoId = call.argument<Int>("localVideoId")
        val peer = getPeer(peerId)
        if (peer != null && (localVideoId != null)) {
            peer.startLocalStream(localVideoId)
            result.success("success")
        } else {
            result.error("Failed to start local stream", "Pls. check permission", "")
        }
    }

    private fun startRemoteStream(call: MethodCall, result: MethodChannel.Result) {
        if (DEBUG) Log.v(TAG, "startRemoteStream:${call}")
        val peerId = call.argument<String>("peerId")
        val remoteVideoId = call.argument<Int>("remoteVideoId")
        val remotePeerId = call.argument<String>("remotePeerId")
        val peer = getPeer(peerId)
        if (peer != null && (remoteVideoId != null) && (remotePeerId != null)) {
            peer.startRemoteStream(remoteVideoId, remotePeerId)
            result.success("success")
        } else {
            result.error("Failed to start local stream", "Pls. check permission", "")
        }
    }

    private fun listAllPeers(call: MethodCall, result: MethodChannel.Result) {
        if (DEBUG) Log.v(TAG, "listAllPeers:${call}")
        val peerId = call.argument<String>("peerId")
        val peer = getPeer(peerId)
        if (peer != null) {
            peer.listAllPeers(object : FlutterSkywayPeer.OnListAllPeersCallback {
                override fun onListAllPeers(list: List<String>) {
                    result.success(list)
                }
            })
        } else {
            result.success(arrayOf<String>())
        }
    }

    private fun hangUp(call: MethodCall, result: MethodChannel.Result) {
        if (DEBUG) Log.v(TAG, "call:${call}")
        val peerId = call.argument<String>("peerId")
        val peer = getPeer(peerId)
        if (peer != null) {
            peer.hangUp()
            result.success("success")
        } else {
            result.error("Failed to hangUp", "Failed to hangUp", "")
        }
    }

    private fun call(call: MethodCall, result: MethodChannel.Result) {
        if (DEBUG) Log.v(TAG, "call:${call}")
        val peerId = call.argument<String>("peerId")
        val remotePeerId = call.argument<String>("remotePeerId")
        val peer = getPeer(peerId)
        if (peer != null && (remotePeerId != null)) {
            peer.startCall(remotePeerId)
            result.success("success")
        } else {
            result.error("Failed to call", "Failed to call", "")
        }
    }

    private fun join(call: MethodCall, result: MethodChannel.Result) {
        if (DEBUG) Log.v(TAG, "join:${call}")
        val peerId = call.argument<String>("peerId")
        val room = call.argument<String>("room")
        val mode = call.argument<Int>("mode")
        val peer = getPeer(peerId)
        if ((peer != null) && (room != null) && (mode != null)) {
            when (mode) {
                RoomOption.RoomModeEnum.MESH.ordinal -> {
                    peer.join(room, RoomOption.RoomModeEnum.MESH)
                    result.success("success")
                }
                RoomOption.RoomModeEnum.SFU.ordinal -> {
                    peer.join(room, RoomOption.RoomModeEnum.SFU)
                    result.success("success")
                }
                else -> {
                    result.error("Invalid mode(${mode})", "Invalid mode(${mode})", "")
                }
            }
        } else {
            result.error("Failed to call", "Failed to call", "")
        }
    }

    private fun leave(call: MethodCall, result: MethodChannel.Result) {
        if (DEBUG) Log.v(TAG, "leave:${call}")
        val peerId = call.argument<String>("peerId")
        val room = call.argument<String>("room")
        val peer = getPeer(peerId)
        if ((peer != null) && (room != null)) {
            peer.leave(room)
            result.success("success")
        } else {
            result.error("Failed to call", "Failed to call", "")
        }
    }

    private fun accept(call: MethodCall, result: MethodChannel.Result) {
        if (DEBUG) Log.v(TAG, "accept:${call}")
        val peerId = call.argument<String>("peerId")
        val remotePeerId = call.argument<String>("remotePeerId")
        result.success("success")
    }

    private fun reject(call: MethodCall, result: MethodChannel.Result) {
        if (DEBUG) Log.v(TAG, "reject:${call}")
        val peerId = call.argument<String>("peerId")
        val remotePeerId = call.argument<String>("remotePeerId")
        result.success("success")
    }

    private fun getPeer(peerId: String?): FlutterSkywayPeer? {
        synchronized(peers) {
            return peers[peerId]
        }
    }
}
