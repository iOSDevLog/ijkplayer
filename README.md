# ijkplayer

[Bilibili/ijkplayer 0.8.8](https://github.com/Bilibili/ijkplayer) cocoapods,iOS video player based on FFmpeg n3.3, with MediaCodec, VideoToolbox support.

# screenshot

![Portrait](screenshot/Portrait.png)

![PortraitNoControl](screenshot/PortraitNoControl.png)

![playUrl](screenshot/playUrl.png)

![playUrlNoControl](screenshot/playUrlNoControl.png)

# usage

```ruby
pod 'ijkplayer', '~> 1.1.3'
``````

or with SSL iOS 8.0 no armv7,armv7s

```
pod 'ijkplayerssl', '~> 1.1.3'
```

OC 参考ijkplayer项目，Swift SSL 参考ijkplayer-Swift项目。

## OC

```ruby
platform :ios, '7.0'
```

## Swift

```ruby
platform :ios, '9.0' # Use Safe Area Layout Guides
use_frameworks!
```

1. 添加 *Project*-Bridge-Header.h -> "#import <IJKMediaFrameworkWithSSL/IJKMediaFrameworkWithSSL.h>"
1. Build Settings -> Ojbective-C Bridging Header -> "*Project*/*Project*-Bridge-Header.h"

# Contributors

[Superbil](https://github.com/Superbil)

[all](https://github.com/iOSDevLog/ijkplayer/graphs/contributors)

# Archive

fat framework

<https://github.com/iOSDevLog/ijkplayer/issues/6>

# LICENSE

ijkplayer is licensed under [LGPLv2.1 or later](LICENSE), so itself is free for commercial use under LGPLv2.1 or later
