//
//  IJKPlayerViewController.swift
//  ijkplayer-Swift
//
//  Created by iOS Dev Log on 2017/8/24.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit

class IJKPlayerViewController: UIViewController {
    var url: URL?
    var player: IJKMediaPlayback?
    var mediaControl: IJKMediaControl!
    
    class func present(from viewController: UIViewController, withTitle title: String, url: URL, completion: @escaping () -> Void) {
        let historyItem = IJKDemoHistoryItem()
        historyItem.title = title
        historyItem.url = url
        IJKDemoHistory.instance().add(historyItem)
        let storyBoard = UIStoryboard(name: "ijkplayer", bundle: nil)
        let vc = storyBoard.instantiateInitialViewController() as! IJKPlayerViewController
        vc.url = url
        viewController.present(vc, animated: true, completion: completion)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        UIApplication.shared.isStatusBarHidden = true
        UIApplication.shared.setStatusBarOrientation(.landscapeLeft, animated: false)
        #if DEBUG
            IJKFFMoviePlayerController.setLogReport(true)
            IJKFFMoviePlayerController.setLogLevel(k_IJK_LOG_DEBUG)
        #else
            IJKFFMoviePlayerController.setLogReport(false)
            IJKFFMoviePlayerController.setLogLevel(k_IJK_LOG_INFO)
        #endif
        IJKFFMoviePlayerController.checkIfFFmpegVersionMatch(true)
        //        IJKFFMoviePlayerController.checkIfPlayerVersionMatch(true, version: "1.0.0")
        let options = IJKFFOptions.byDefault()
        player = IJKFFMoviePlayerController(contentURL: url, with: options)
        player?.view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        player?.view?.frame = view.bounds
        player?.scalingMode = .aspectFit
        player?.shouldAutoplay = true
        view.autoresizesSubviews = true
        view.addSubview((player?.view)!)
        
        self.addMediaControl()
        self.addAction()
    }
    
    deinit {
        self.mediaControl = nil
    }
    
    func addMediaControl() {
        let nib = UINib(nibName: "IJKMediaControl", bundle: nil)
        mediaControl = nib.instantiate(withOwner: nil, options: nil).first as! IJKMediaControl
        mediaControl.translatesAutoresizingMaskIntoConstraints = false
        mediaControl.delegatePlayer = player
        self.view.addSubview(mediaControl)
        let constraints = [
            NSLayoutConstraint(item: mediaControl, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: mediaControl, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: mediaControl, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: mediaControl, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1, constant: 0),
            ]
        self.view.addConstraints(constraints)
        view.bringSubview(toFront: mediaControl)
    }
    
    func addAction() {
        mediaControl.playButton.addTarget(self, action: #selector(onClickPlay(_:)), for: .touchUpInside)
        mediaControl.pauseButton.addTarget(self, action: #selector(onClickPause(_:)), for: .touchUpInside)
        mediaControl.doneButton.addTarget(self, action: #selector(onClickDone(_:)), for: .touchUpInside)
        mediaControl.hudButton.addTarget(self, action: #selector(onClickHUD(_:)), for: .touchUpInside)
        
        mediaControl.mediaProgressSlider.addTarget(self, action: #selector(didSliderValueChanged), for: .valueChanged)
        mediaControl.mediaProgressSlider.addTarget(self, action: #selector(didSliderTouchDown), for: .touchDown)
        mediaControl.mediaProgressSlider.addTarget(self, action: #selector(didSliderTouchCancel), for: .touchCancel)
        mediaControl.mediaProgressSlider.addTarget(self, action: #selector(didSliderTouchUpInside), for: .touchUpInside)
        mediaControl.mediaProgressSlider.addTarget(self, action: #selector(didSliderTouchUpOutside), for: .touchUpOutside)
        
        mediaControl.overlayPanel.addTarget(self, action: #selector(onClickOverlay(_:)), for: .touchUpInside)
        mediaControl.addTarget(self, action: #selector(onClickMediaControl(_:)), for: .touchDown)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        installMovieNotificationObservers()
        player?.prepareToPlay()
        mediaControl.refreshMediaControl()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.shutdown()
        removeMovieNotificationObservers()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    
    // MARK: IBAction
    
    @IBAction func onClickHUD(_ sender: UIButton) {
        if (self.player is IJKFFMoviePlayerController) {
            let player: IJKFFMoviePlayerController? = self.player as? IJKFFMoviePlayerController
            player?.shouldShowHudView = !(player?.shouldShowHudView)!
            let hudTitle = (player?.shouldShowHudView)! ? "HUD On" : "HUD Off"
            sender.setTitle(hudTitle, for: .normal)
        }
    }
    
    @IBAction func onClickMediaControl(_ sender: Any) {
        mediaControl.showAndFade()
    }
    
    @IBAction func onClickOverlay(_ sender: Any) {
        mediaControl.hide()
    }
    
    @IBAction func onClickDone(_ sender: Any) {
        presentingViewController?.dismiss(animated: true) { _ in }
    }
    
    @IBAction func onClickPlay(_ sender: Any) {
        player?.play()
        mediaControl.refreshMediaControl()
    }
    
    @IBAction func onClickPause(_ sender: Any) {
        player?.pause()
        mediaControl.refreshMediaControl()
    }
    
    @IBAction func didSliderTouchDown() {
        mediaControl.beginDragMediaSlider()
    }
    
    @IBAction func didSliderTouchCancel() {
        mediaControl.endDragMediaSlider()
    }
    
    @IBAction func didSliderTouchUpOutside() {
        mediaControl.endDragMediaSlider()
    }
    
    @IBAction func didSliderTouchUpInside() {
        player?.currentPlaybackTime = TimeInterval(mediaControl.mediaProgressSlider.value)
        mediaControl.endDragMediaSlider()
    }
    
    @IBAction func didSliderValueChanged() {
        mediaControl.continueDragMediaSlider()
    }
    
    func loadStateDidChange(_ notification: Notification) {
        //    MPMovieLoadStateUnknown        = 0,
        //    MPMovieLoadStatePlayable       = 1 << 0,
        //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
        //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
        if let loadState = player?.loadState {
            if loadState.contains(.playthroughOK) {
                print("loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: \(loadState)\n")
            }
            else if loadState.contains(.stalled) {
                print("loadStateDidChange: IJKMPMovieLoadStateStalled: \(loadState)\n")
            }
            else {
                print("loadStateDidChange: ???: \(loadState)\n")
            }
        }
        
    }
    func moviePlayBackDidFinish(_ notification: Notification) {
        //    MPMovieFinishReasonPlaybackEnded,
        //    MPMovieFinishReasonPlaybackError,
        //    MPMovieFinishReasonUserExited
        let reason = notification.userInfo?[IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] as! Int
        switch reason {
        case IJKMPMovieFinishReason.playbackEnded.rawValue:
            print("playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: \(reason)\n")
        case IJKMPMovieFinishReason.userExited.rawValue:
            print("playbackStateDidChange: IJKMPMovieFinishReasonUserExited: \(reason)\n")
        case IJKMPMovieFinishReason.playbackError.rawValue:
            print("playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: \(reason)\n")
        default:
            print("playbackPlayBackDidFinish: ???: \(reason)\n")
        }
        
    }
    
    func mediaIsPreparedToPlayDidChange(notification: Notification) {
        print("mediaIsPreparedToPlayDidChange\n")
    }
    
    func moviePlayBackStateDidChange(_ notification: Notification) {
        //    MPMoviePlaybackStateStopped,
        //    MPMoviePlaybackStatePlaying,
        //    MPMoviePlaybackStatePaused,
        //    MPMoviePlaybackStateInterrupted,
        //    MPMoviePlaybackStateSeekingForward,
        //    MPMoviePlaybackStateSeekingBackward
        guard player != nil else {
            return
        }
        switch player!.playbackState {
        case .stopped:
            print("IJKMPMoviePlayBackStateDidChange \(String(describing: player?.playbackState)): stoped")
            break
        case .playing:
            print("IJKMPMoviePlayBackStateDidChange \(String(describing: player?.playbackState)): playing")
            break
        case .paused:
            print("IJKMPMoviePlayBackStateDidChange \(String(describing: player?.playbackState)): paused")
            break
        case .interrupted:
            print("IJKMPMoviePlayBackStateDidChange \(String(describing: player?.playbackState)): interrupted")
            break
        case .seekingForward, .seekingBackward:
            print("IJKMPMoviePlayBackStateDidChange \(String(describing: player?.playbackState)): seeking")
            break
        }
    }
    
    func installMovieNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadStateDidChange), name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: player)
        NotificationCenter.default.addObserver(self, selector: #selector(self.moviePlayBackDidFinish), name: NSNotification.Name.IJKMPMoviePlayerPlaybackDidFinish, object: player)
        NotificationCenter.default.addObserver(self, selector: #selector(self.mediaIsPreparedToPlayDidChange), name: NSNotification.Name.IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: player)
        NotificationCenter.default.addObserver(self, selector: #selector(self.moviePlayBackStateDidChange), name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange, object: player)
    }
    
    // MARK: Remove Movie Notification Handlers
    /* Remove the movie notification observers from the movie object. */
    func removeMovieNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: player)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.IJKMPMoviePlayerPlaybackDidFinish, object: player)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: player)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange, object: player)
    }
}
