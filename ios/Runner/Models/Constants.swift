//
//  Constants.swift
//  Runner
//
//  Created by tienpx on 14/02/2022.
//

struct Constants {
    static let METHOD_CHANNEL_NAME = "flutter.skyway/method"
    static let EVENT_CHANNEL_NAME = "flutter.skyway/event"
    static let PEER_EVENT_CHANNEL_NAME = "flutter.skyway/event"
    static let SKYWAY_PLATFORM_VIEW = "flutter.skyway/flatform_view"
    static let SKYWAY_PLUGIN = "flutter.skyway/plugin"
    static let SKYWAY_PLATFORM_VIEW_ID = "flutter.skyway/video_view"
}

enum Method: String {
    case connect
    case disconnect
    case startLocalStream
    case listAllPeers
    case call
    case hangUp
    case startRemoteStream
    case join
    case leave
    case switchCamera
}


enum SkywayEvent: String {
    case onConnect
    case onDisconnect
    case onCall
    case onAddRemoteStream
    case onRemoveRemoteStream
    case onOpenRoom
    case onCloseRoom
    case onJoin
    case onLeave
    case onRelease
    case onError
}
