#
#  Be sure to run `pod spec lint ijkplayer.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "ijkplayer"
  s.version      = "0.8.2"
  s.summary      = "ijkplayer framework."

  s.description  = <<-DESC
bilibili/ijkplayer  IJKMediaFramework 上传到 cococapods
                   DESC

  s.homepage     = "https://github.com/iOSDevLog/ijkplayer"

  s.license      = "GNU Lesser General Public License v2.1"

  s.author             = { "iosdevlog" => "iosdevlog@iosdevlog.com" }
  s.social_media_url   = "https://twitter.com/iosdevlog"

  s.platform     = :ios, "7.0"

  s.source       = { "https://github.com/iOSDevLog/ijkplayer/blob/master/IJKMediaFramework.zip" }

  s.ios.vendored_frameworks = 'IJKMediaFramework.framework'
  s.frameworks  = "AudioToolbox", "AVFoundation", "CoreGraphics", "CoreMedia", "CoreVideo", "MobileCoreServices", "OpenGLES", "QuartzCore", "VideoToolbox", "Foundation", "UIKit", "MediaPlayer"
  s.libraries   = "bz2", "z", "stdc++"

  s.requires_arc = true

end
