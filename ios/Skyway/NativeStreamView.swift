//
//  NativeView.swift
//  Runner
//
//  Created by Macbook on 14/02/2022.
//

import Flutter
import UIKit
import SkyWay

class NativeStreamViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return NativeStreamView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}

class NativeStreamView: NSObject, FlutterPlatformView {
    var videoView: SKWVideo
    private var viewId: Int

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        self.viewId = Int(exactly: viewId) ?? 0
        videoView = SKWVideo()
        super.init()
        FlutterSkyway.streamViews[self.viewId] = self
    }

    func view() -> UIView {
        return videoView
    }
    
    deinit {
        print("DEINIT NATIVE VIEW \(viewId)")
        FlutterSkyway.streamViews.removeValue(forKey: viewId)
    }
}

