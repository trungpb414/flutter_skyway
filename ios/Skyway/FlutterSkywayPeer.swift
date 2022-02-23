//
//  FlutterSkywayPeer.swift
//  Runner
//
//  Created by tienpx on 14/02/2022.
//
import SkyWay
import Then

class FlutterSkywayPeer: NSObject {
    let peerId: String
    let peer: SKWPeer
    let registrar: FlutterPluginRegistrar
    
    private var remotePeers = [String : RemotePeer]()
    
    private var localStream: SKWMediaStream?
    private var localVideoView: NativeStreamView?
    
    private var roomName: String?
    private var roomMode: SKWRoomModeEnum?
    private var room: SKWRoom?
    
    private var mediaConnection: SKWMediaConnection?
    
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    
    init(peerId: String, peer: SKWPeer, registrar: FlutterPluginRegistrar) {
        self.peerId = peerId
        self.peer = peer
        self.registrar = registrar
        super.init()
        createEventChannel()
        setupCallbacks()
    }
    
    deinit {
        print("PEER DEINIT")
    }
    
    func getRemotePeer(id: String) -> RemotePeer? {
        return remotePeers[id]
    }
    
    func createEventChannel() {
        guard let identity = peer.identity else { return }
        eventChannel = FlutterEventChannel(name: Constants.PEER_EVENT_CHANNEL_NAME + "_" + identity, binaryMessenger: registrar.messenger()).then {
            $0.setStreamHandler(self)
        }
    }
    
    func sendEvent(_ event: SkywayEvent, params: Dictionary<String, String> = [:]) {
        guard let eventSink = eventSink else { return }
        var message = [String : String]()
        message["event"] = event.rawValue
        message["peerId"] = peerId
        message.merge(params, uniquingKeysWith: +)
        eventSink(message)
    }
    
    func setupCallbacks() {
        peer.on(.PEER_EVENT_DISCONNECTED, callback:{ [weak self] (obj) -> Void in
            guard let self = self else { return }
            self.sendEvent(.onDisconnect)
        })
        peer.on(.PEER_EVENT_CALL, callback:{ [weak self] (obj) -> Void in
            guard let self = self else { return }
            guard let mediaConnection = obj as? SKWMediaConnection else { return }
            guard let remotePeerId = mediaConnection.peer else { return }
            guard let localStream = self.localStream else { return }
            self.setMediaCallbacks(mediaConnection)
            mediaConnection.answer(localStream)
            self.sendEvent(.onCall, params: ["remotePeerId": remotePeerId])
        })
    }
    
    func setMediaCallbacks(_ mediaConnection: SKWMediaConnection) {
        mediaConnection.on(.MEDIACONNECTION_EVENT_STREAM, callback:{ [weak self] (obj) -> Void in
            guard let self = self else { return }
            guard let mediaStream = obj as? SKWMediaStream else { return }
            self.addRemoteStream(mediaStream)
        })
    }
    
    func addRemoteStream(_ stream: SKWMediaStream) {
        guard let remotePeerId = stream.peerId else { return }
        remotePeers[remotePeerId] = RemotePeer(peerId: remotePeerId, stream: stream)
        sendEvent(.onAddRemoteStream, params: ["remotePeerId": remotePeerId])
    }
    
    func startRemoteStream(remoteVideoId: Int, remotePeerId: String) {
        guard let remotePeer = getRemotePeer(id: remotePeerId) else { return }
        guard let remoteStreamView = FlutterSkyway.getNativeStreamView(id: remoteVideoId) else { return }
        remotePeer.setStreamView(remoteStreamView)
    }
    
    func removeRemoteStream(_ remotePeerId: String) {
        guard let remotePeer = getRemotePeer(id: remotePeerId) else { return }
        remotePeer.close()
        sendEvent(.onRemoveRemoteStream, params: ["remotePeerId": remotePeerId])
    }
    
    func closeAllRemoteStream() {
        remotePeers.values.forEach {
            removeRemoteStream($0.peerId)
        }
        remotePeers = [:]
    }
    
    func join(roomName: String, mode: SKWRoomModeEnum) {
        guard let localStream = localStream else { return }
        let option = SKWRoomOption()
        option.mode = mode
        option.stream = localStream
        let _ = peer.joinRoom(withName: roomName, options: option)?.then {
            self.room = $0
            self.roomName = roomName
            self.roomMode = mode
            setRoomCallback($0)
        }
    }
    
    func leave(roomName: String) {
        guard let room = room else { return }
        if let sfuRoom = room as? SKWSFURoom {
            sfuRoom.close()
        }
        if let meshRoom = room as? SKWMeshRoom {
            meshRoom.close()
        }
        room.offAll()
    }
    
    func send(roomName: String, data: NSObject) {
        guard let room = room else { return }
        room.send(data)
    }
    
    func setRoomCallback(_ room: SKWRoom) {
        room.on(.ROOM_EVENT_OPEN, callback:{ [weak self] (obj) -> Void in
            guard let self = self else { return }
            guard let room = obj as? String else { return }
            self.sendEvent(.onOpenRoom, params: ["room": room])
        })
        room.on(.ROOM_EVENT_STREAM, callback:{ [weak self] (obj) -> Void in
            guard let self = self else { return }
            guard let mediaStream = obj as? SKWMediaStream else { return }
            self.addRemoteStream(mediaStream)
        })
        room.on(.ROOM_EVENT_DATA, callback:{ [weak self] (obj) -> Void in
            guard let self = self else { return }
            guard let roomDataMessage = obj as? SKWRoomDataMessage else { return }
            guard let message = roomDataMessage.data as? String else { return }
            self.sendEvent(.onMessageData, params: ["senderPeerId": roomDataMessage.src, "message": message])
        })
        room.on(.ROOM_EVENT_PEER_JOIN, callback:{ [weak self] (obj) -> Void in
            guard let self = self else { return }
            guard let remotePeerId = obj as? String else { return }
            self.sendEvent(.onJoin, params: ["remotePeerId": remotePeerId])
        })
        room.on(.ROOM_EVENT_PEER_LEAVE, callback:{ [weak self] (obj) -> Void in
            guard let self = self else { return }
            guard let remotePeerId = obj as? String else { return }
            self.sendEvent(.onLeave, params: ["remotePeerId": remotePeerId])
            self.removeRemoteStream(remotePeerId)
        })
    }
    
    func listAllPeers(callback: @escaping ((_ peerIds: [String]) -> Void)) {
        self.peer.listAllPeers({ (peers) -> Void in
            if let connectedPeerIds = peers as? [String]{
                let res = connectedPeerIds.filter({ (connectedPeerId) -> Bool in
                    return connectedPeerId != self.peerId
                })
                callback(res)
            }else{
                callback([])
            }
        })
    }
    
    func startLocalStream(_ id: Int) {
        if let localStream = localStream, let localVideoView = localVideoView {
            self.localVideoView = nil
            localStream.removeVideoRenderer(localVideoView.videoView, track: 0)
        }
        
        let constraints = SKWMediaConstraints()
        constraints.maxWidth = 200
        constraints.maxHeight = 200
        constraints.cameraPosition = .CAMERA_POSITION_FRONT
        
        self.localVideoView = FlutterSkyway.getNativeStreamView(id: id)
        guard let videoView = localVideoView?.videoView else { return }
        if let localStream = localStream {
            localStream.addVideoRenderer(videoView, track: 0)
            localStream.setEnableAudioTrack(0, enable: true)
            self.localStream = localStream
        } else {
            let localStream = SKWNavigator.getUserMedia(constraints)
            localStream?.addVideoRenderer(videoView, track: 0)
            localStream?.setEnableAudioTrack(0, enable: true)
            self.localStream = localStream
        }
        
    }
    
    func startCall(_ id: String) {
        if let mediaConnection = mediaConnection {
            mediaConnection.close()
            self.mediaConnection = nil
        }
        let option = SKWCallOption()
        guard let localStream = localStream else { return }
        let _ = peer.call(withId: id, stream: localStream, options: option)?.then {
            self.mediaConnection = $0
            setMediaCallbacks($0)
        }
    }
    
    func hangUp() {
        closeAllRemoteStream()
        if let mediaConnection = mediaConnection {
            mediaConnection.close()
            self.mediaConnection = nil
        }
    }
    
    func release() {
        FlutterSkyway.streamViews = [:]
        if let localStream = localStream, let localVideoView = localVideoView {
            localStream.removeVideoRenderer(localVideoView.videoView, track: 0)
            localStream.close()
            self.localStream = nil
            self.localVideoView = nil
        }
        if let mediaConnection = mediaConnection {
            mediaConnection.close()
            self.mediaConnection = nil
        }
    }
}

extension FlutterSkywayPeer {
    func switchCamera() {
        guard let localStream = localStream else { return }
        localStream.switchCamera()
    }
}

extension FlutterSkywayPeer: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        sendEvent(.onConnect)
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
