package com.example.flutter_skyway

internal object Const {
    const val METHOD_CHANNEL_NAME = "flutter.skyway/method"
    const val EVENT_CHANNEL_NAME = "flutter.skyway/event"
    const val PEER_EVENT_CHANNEL_NAME = "flutter.skyway/event"
    const val SKYWAY_CANVAS_VIEW = "flutter.skyway/canvas"

    enum class SkywayEvent {
        onConnect,
        onDisconnect,
        onCall,
        onAddRemoteStream,
        onRemoveRemoteStream,
        onOpenRoom,
        onCloseRoom,
        onJoin,
        onLeave,
        onRelease,
        onError,
    }
}