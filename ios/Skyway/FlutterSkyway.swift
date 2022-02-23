//
//  FlutterSkyway.swift
//  Runner
//
//  Created by tienpx on 14/02/2022.
//

import SkyWay

class FlutterSkyway {
    static var streamViews = [Int : NativeStreamView]()
    private var registrar: FlutterPluginRegistrar?
    private var localViewId = 0
    private var remoteViewIds = [Int]()
    private var peers = [String : FlutterSkywayPeer]()
    
    func setRegistrar(_ registrar: FlutterPluginRegistrar?) {
        self.registrar = registrar
    }
    
    static func getNativeStreamView(id: Int) -> NativeStreamView? {
        return FlutterSkyway.streamViews[id]
    }
    
    func handleMethod(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        print("Method: \(methodCall.method)\nArguments: \(methodCall.arguments ?? "Empty")")
        guard let method = Method.init(rawValue: methodCall.method) else {
            result(FlutterMethodNotImplemented)
            return
        }
        guard let json = methodCall.arguments as? Dictionary<String, Any>, let argument = Argument(JSON: json) else {
            return
        }
        switch method {
        case .connect:
            connect(argument, result)
        case .disconnect:
            disconnect(argument, result)
        case .startLocalStream:
            startLocalStream(argument, result)
        case .listAllPeers:
            listAllPeers(argument, result)
        case .call:
            call(argument, result)
        case .hangUp:
            hangUp(argument, result)
        case .startRemoteStream:
            startRemoteStream(argument, result)
        case .join:
            join(argument, result)
        case .leave:
            leave(argument, result)
        case .switchCamera:
            switchCamera(argument, result)
        case .sendText:
            sendText(argument, result)
        }
    }
    
    func getPeer(_ peerId: String) -> FlutterSkywayPeer? {
        return peers[peerId]
    }
    
    func connect(_ arg: Argument, _ result: @escaping FlutterResult) {
        let option = SKWPeerOption()
        option.key = arg.apiKey
        option.domain = arg.domain
        option.debug = .DEBUG_LEVEL_ALL_LOGS
        guard let peer = SKWPeer(options: option) else { return }
        peer.on(.PEER_EVENT_OPEN, callback:{ [weak self] (obj) -> Void in
            guard let self = self else { return }
            guard let peerId = obj as? String, let registrar = self.registrar else { return }
            result(peerId)
            self.peers[peerId] = FlutterSkywayPeer(peerId: peerId, peer: peer, registrar: registrar)
        })
        peer.on(.PEER_EVENT_ERROR, callback:{ (obj) -> Void in
            guard let error = obj as? SKWPeerError else { return }
            print(error)
        })
        peer.on(.PEER_EVENT_CLOSE, callback:{ (obj) -> Void in
            guard let result = obj as? String else { return }
            print(result)
        })
        SKWNavigator.initialize(peer);
    }
    
    func disconnect(_ arg: Argument, _ result: @escaping FlutterResult) {
        guard let peerId = arg.peerId else { return }
        if let peer =  peers[peerId] {
            peer.peer.disconnect()
            peer.peer.destroy()
            peer.release()
            peers.removeValue(forKey: peerId)
            result("success")
        }
    }
    
    func startLocalStream(_ arg: Argument, _ result: @escaping FlutterResult) {
        guard let localVideoId = arg.localVideoId, let peerId = arg.peerId else { return }
        guard let peer = getPeer(peerId) else { return }
        peer.startLocalStream(localVideoId)
        result("success")
    }
    
    func listAllPeers(_ arg: Argument, _ result: @escaping FlutterResult) {
        guard let peerId = arg.peerId else { return }
        guard let peer = getPeer(peerId) else { return }
        peer.listAllPeers { peerIds in
            result(peerIds)
        }
    }
    
    func call(_ arg: Argument, _ result: @escaping FlutterResult) {
        guard let peerId = arg.peerId, let remotePeerId = arg.remotePeerId else { return }
        guard let peer = getPeer(peerId) else { return }
        peer.startCall(remotePeerId)
        result("success")
    }
    
    func hangUp(_ arg: Argument, _ result: @escaping FlutterResult) {
        guard let peerId = arg.peerId, let peer = getPeer(peerId) else { return }
        peer.hangUp()
        result("success")
    }
    
    func startRemoteStream(_ arg: Argument, _ result: @escaping FlutterResult) {
        guard let peerId = arg.peerId, let remoteVideoId = arg.remoteVideoId, let remotePeerId = arg.remotePeerId else { return }
        guard let peer = getPeer(peerId) else { return }
        peer.startRemoteStream(remoteVideoId: remoteVideoId, remotePeerId: remotePeerId)
        result("success")
    }
    
    func join(_ arg: Argument, _ result: @escaping FlutterResult) {
        guard let peerId = arg.peerId, let roomName = arg.room, let mode = arg.mode else { return }
        guard let peer = getPeer(peerId) else { return }
        guard let mode = SKWRoomModeEnum.init(rawValue: UInt(mode)) else { return }
        peer.join(roomName: roomName, mode: mode)
        result("success")
    }
    
    func leave(_ arg: Argument, _ result: @escaping FlutterResult) {
        guard let peerId = arg.peerId, let roomName = arg.room else { return }
        guard let peer = getPeer(peerId) else { return }
        peer.leave(roomName: roomName)
        result("success")
    }
    
    func sendText(_ arg: Argument, _ result: @escaping FlutterResult) {
        guard let peerId = arg.peerId, let roomName = arg.room else { return }
        guard let message = arg.message else { return }
        guard let peer = getPeer(peerId) else { return }
        peer.send(roomName: roomName, data: message as NSString)
        result("success")
    }
    
    func switchCamera(_ arg: Argument, _ result: @escaping FlutterResult) {
        guard let peerId = arg.peerId else { return }
        guard let peer = getPeer(peerId) else { return }
        peer.switchCamera()
        result("success")
    }
}
