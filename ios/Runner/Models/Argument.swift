//
//  Argument.swift
//  Runner
//
//  Created by tienpx on 14/02/2022.
//

import ObjectMapper

struct Argument: Mappable {
    var apiKey: String?
    var domain: String?
    var peerId: String?
    var localVideoId: Int?
    var remoteVideoId: Int?
    var remotePeerId: String?
    var room: String?
    var mode: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        apiKey <- map["apiKey"]
        domain <- map["domain"]
        peerId <- map["peerId"]
        localVideoId <- map["localVideoId"]
        remoteVideoId <- map["remoteVideoId"]
        remotePeerId <- map["remotePeerId"]
        room <- map["room"]
        mode <- map["mode"]
    }
}
