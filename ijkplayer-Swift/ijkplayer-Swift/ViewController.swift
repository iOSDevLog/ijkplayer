//
//  ViewController.swift
//  ijkplayer-Swift
//
//  Created by iOS Dev Log on 2017/8/24.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var player:IJKFFMoviePlayerController!
    
    let urls = ["https://transpox.ai/vod/VIdDITnI80yakUBjzgr6LOu5Y3fWcBnHssA3bkcf_P0/27-8-2018_7h38m11s.mp4/index.m3u8",
                "rtmp://v1.one-tv.com:1935/live/mpegts.stream"]
    
    @IBOutlet weak var videoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let options = IJKFFOptions.byDefault()
        
        //视频源地址
        let url = URL(string: urls[1])
        
        //初始化播放器，播放在线视频或直播（RTMP）
        let player = IJKFFMoviePlayerController(contentURL: url!, with: options)
        //播放页面视图宽高自适应
        player?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        player?.view.frame = self.videoView.bounds
        player?.scalingMode = .aspectFit //缩放模式
        player?.shouldAutoplay = true //开启自动播放
        
        self.videoView.autoresizesSubviews = true
        self.videoView.addSubview((player?.view)!)
        self.player = player
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //开始播放
        self.player.prepareToPlay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //关闭播放器
        self.player.shutdown()
    }
    
    @IBAction func playRTMP(_ sender: UIButton) {
        self.player.shutdown()
        
        let url = URL(string: urls[0])
        
        let options = IJKFFOptions.byDefault()
        //初始化播放器，播放在线视频或直播（RTMP）
        let player = IJKFFMoviePlayerController(contentURL: url!, with: options)
        //播放页面视图宽高自适应
        player?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        player?.view.frame = self.videoView.bounds
        player?.scalingMode = .aspectFit //缩放模式
        player?.shouldAutoplay = true //开启自动播放
        
        self.videoView.autoresizesSubviews = true
        self.videoView.addSubview((player?.view)!)
        self.player = player
        self.player.prepareToPlay()
    }
    
    @IBAction func playM3u8(_ sender: UIButton) {
        self.player.shutdown()
        
        let url = URL(string: urls[1])
        
        let options = IJKFFOptions.byDefault()
        //初始化播放器，播放在线视频或直播（RTMP）
        let player = IJKFFMoviePlayerController(contentURL: url!, with: options)
        //播放页面视图宽高自适应
        player?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        player?.view.frame = self.videoView.bounds
        player?.scalingMode = .aspectFit //缩放模式
        player?.shouldAutoplay = true //开启自动播放
        
        self.videoView.autoresizesSubviews = true
        self.videoView.addSubview((player?.view)!)
        self.player = player
        self.player.prepareToPlay()
    }
}

