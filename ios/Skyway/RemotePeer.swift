//
//  RemotePeer.swift
//  Runner
//
//  Created by tienpx on 15/02/2022.
//

import SkyWay

class RemotePeer {
    let peerId: String
    let stream: SKWMediaStream
    var streamView: NativeStreamView?
    
    init(peerId: String, stream: SKWMediaStream) {
        self.peerId = peerId
        self.stream = stream
    }
    
    func setStreamView(_ streamView: NativeStreamView) {
        self.streamView = streamView
        stream.addVideoRenderer(streamView.videoView, track: 0)
    }
    
    func close() {
        if let streamView = streamView {
            stream.removeVideoRenderer(streamView.videoView, track: 0)
            self.streamView = nil
        }
        stream.close()
    }
}
