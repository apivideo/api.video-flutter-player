<!--<documentation_excluded>-->
[![badge](https://img.shields.io/twitter/follow/api_video?style=social)](https://twitter.com/intent/follow?screen_name=api_video)
&nbsp; [![badge](https://img.shields.io/github/stars/apivideo/api.video-flutter-player?style=social)](https://github.com/apivideo/api.video-flutter-player)
&nbsp; [![badge](https://img.shields.io/discourse/topics?server=https%3A%2F%2Fcommunity.api.video)](https://community.api.video)
![](https://github.com/apivideo/.github/blob/main/assets/apivideo_banner.png)
<h1 align="center">api.video Flutter player</h1>

[api.video](https://api.video) is the video infrastructure for product builders. Lightning fast
video APIs for integrating, scaling, and managing on-demand & low latency live streaming features in
your app.

## Table of contents

- [Table of contents](#table-of-contents)
- [Project description](#project-description)
- [Getting started](#getting-started)
  - [Installation](#installation)
- [Documentation](#documentation)
  - [Instantiation](#instantiation)
    - [1. The ApiVideoPlayerController](#1-the-apivideoplayercontroller)
    - [2. The ApiVideoPlayer](#2-the-apivideoplayer)
  - [Methods](#methods)
  - [Properties](#properties)
  - [Events listener](#events-listener)
    - [Add a new event listener: Method 1](#add-a-new-event-listener-method-1)
    - [Add a new event listener: Method 2](#add-a-new-event-listener-method-2)
    - [Remove an event listener](#remove-an-event-listener)
- [Sample application](#sample-application)
- [Dependencies](#dependencies)
- [FAQ](#faq)

<!--</documentation_excluded>-->
<!--<documentation_only>
---
title: api.video Flutter Player
meta: 
  description: The official api.video Flutter Player component for api.video. [api.video](https://api.video/) is the video infrastructure for product builders. Lightning fast video APIs for integrating, scaling, and managing on-demand & low latency live streaming features in your app.
---

# api.video Flutter Player

[api.video](https://api.video/) is the video infrastructure for product builders. Lightning fast video APIs for integrating, scaling, and managing on-demand & low latency live streaming features in your app.

</documentation_only>-->
## Project description

Easily integrate a video player for videos from api.video in your Flutter application for iOS,
Android and Web.

## Getting started

### Installation

Run the following command at the root of your project.

```shell
flutter pub add apivideo_player
```

## Documentation

### Instantiation

#### 1. The ApiVideoPlayerController

To use a video player, you must instantiate a new controller.

The [ApiVideoPlayerController](https://github.com/apivideo/api.video-flutter-player/blob/main/lib/src/apivideo_player_controller.dart) parameters are:

| Parameter    | Mandatory          | Type                                                                                                                                               | Description                                                                   |
|--------------|--------------------|----------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------|
| videoOptions | Yes                | [VideoOptions](https://github.com/apivideo/api.video-flutter-player/blob/4efe23f20ccf1c9459cee7588da1d3fed74e8e36/lib/src/apivideo_types.dart#L13) | Options from the video you want to display inside the current video player    |
| autoplay     | No (default false) | bool                                                                                                                                               | Whether you want your video to be automatically played when it's ready or not |
| onReady      | No                 | VoidCallback                                                                                                                                       | A callback called when the video is ready to be played                        |
| onPlay       | No                 | VoidCallback                                                                                                                                       | A callback called when the video is played                                    |
| onPause      | No                 | VoidCallback                                                                                                                                       | A callback called when the video is paused                                    |
| onEnd        | No                 | VoidCallback                                                                                                                                       | A callback called when the video has ended                                    |
| onError      | No                 | Function(Object)                                                                                                                                   | A callback called when an error occured                                       |

Once instantiated, you need to initialize the controller by calling its `initialize()` method.

```dart
final ApiVideoPlayerController controller = ApiVideoPlayerController(
  videoOptions: VideoOptions(videoId: 'VIDEO_ID'), // `VIDEO_ID` is the video id or the live stream id
  // For private video: VideoOptions(videoId: "YOUR_VIDEO_ID", token: "YOUR_PRIVATE_TOKEN")
);

await controller.initialize();
```

See the sample application below for more details.

#### 2. The ApiVideoPlayer

A Widget that displays the video and its controls.

The [ApiVideoPlayer](https://github.com/apivideo/api.video-flutter-player/blob/main/lib/src/widgets/apivideo_player.dart) constructor takes 3 parameters:

| Parameter  | Mandatory                      | Type                                                                                                                               | Description                                                   |
|------------|--------------------------------|------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------|
| controller | Yes                            | [ApiVideoPlayerController](https://github.com/apivideo/api.video-flutter-player/blob/main/lib/src/apivideo_player_controller.dart) | The controller that controls a video player                   |                                                                                                                                               | Allows you to hide or show the controls of a video player |
| fit        | No (default BoxFit.contain)    | [BoxFit](https://api.flutter.dev/flutter/painting/BoxFit.html)                                                                     | How the player should be inscribed into its box.              |
| style      | No (default api.video style)   | [PlayerStyle](https://github.com/apivideo/api.video-flutter-player/blob/main/lib/src/style/apivideo_style.dart#L102)               | Allows you to customize the video player's colors, shapes,... |
| child      | No (default api.video overlay) | Widget                                                                                                                             | Replace api.video overlay by your own implementation.         |

```dart

final ApiVideoPlayerController controller = ApiVideoPlayerController(
  videoOptions: VideoOptions(videoId: 'VIDEO_ID'),
  // For private video: VideoOptions(videoId: "YOUR_VIDEO_ID", token: "YOUR_PRIVATE_TOKEN")
);

await controller.initialize();

Widget build(BuildContext context) {
  return ApiVideoPlayer(
    controller: controller,
  );
}
```

### Methods

Once the [ApiVideoPlayerController](https://github.com/apivideo/api.video-flutter-player/blob/main/lib/src/apivideo_player_controller.dart) has been instantiated, you can control the player it has been assigned to with its methods:

| Method                                     | Description                                                                   |
|--------------------------------------------|-------------------------------------------------------------------------------|
| play()                                     | Play the video                                                                |
| pause()                                    | Pause the video                                                               |
| seek(Duration offset)                      | Add/substract the given Duration from the current time                        |
| setVolume(double volume)                   | Change the audio volume to the given value. From 0 to 1 (0 = muted, 1 = 100%) |
| setIsMuted(bool isMuted)                   | Mute/unmute the video                                                         |
| setAutoplay(bool autoplay)                 | Define if the video should start playing as soon as it is loaded              |
| setIsLooping(bool isLooping)               | Define if the video should be played in loop                                  |
| setCurrentTime(Duration currentTime)       | Set the current playback time                                                 |
| setVideoOptions(VideoOptions videoOptions) | Set the video options                                                         |

Example:

```dart

final ApiVideoPlayerController controller = ApiVideoPlayerController(
  videoOptions: VideoOptions(videoId: 'VIDEO_ID'),
  // For private video: VideoOptions(videoId: "YOUR_VIDEO_ID", token: "YOUR_PRIVATE_TOKEN")
);

await controller.initialize();

controller.play(); // Play the video
```

### Properties

Once the [ApiVideoPlayerController](https://github.com/apivideo/api.video-flutter-player/blob/main/lib/src/apivideo_player_controller.dart) has been instantiated, you can access the video player's properties:

| Property     | Type                  | Description                                     |
|--------------|-----------------------|-------------------------------------------------|
| isCreated    | Future\<bool>         | Check if the player has been created            |
| isPlaying    | Future\<bool>         | Check whether the video is playing              |
| videoOptions | Future\<VideoOptions> | Retrieve the current video options              |
| currentTime  | Future\<Duration>     | Retrieve the current playback time of the video |
| duration     | Future\<Duration>     | Retrieve the duration of the video              |
| autoplay     | Future\<bool>         | Check whether the video is autoplayed           |
| isMuted      | Future\<bool>         | Check whether the video is muted                |
| isLooping    | Future\<bool>         | Check whether the video is in loop mode         |
| volume       | Future\<double>       | Retrieve the current volume                     |
| videoSize    | Future\<Size?>        | Retrieve the current video size                 |

Example:

```dart

final ApiVideoPlayerController controller = ApiVideoPlayerController(
  videoOptions: VideoOptions(videoId: 'VIDEO_ID'),
  // For private video: VideoOptions(videoId: "YOUR_VIDEO_ID", token: "YOUR_PRIVATE_TOKEN")
);

await controller.initialize();

final bool isMuted = await controller.isMuted;
```

### Events listener

#### Add a new event listener: Method 1

When you instantiate a new [ApiVideoPlayerController](https://github.com/apivideo/api.video-flutter-player/blob/main/lib/src/apivideo_player_controller.dart), you can bind callbacks to some events:

```dart

final ApiVideoPlayerController controller = ApiVideoPlayerController(
  videoOptions: VideoOptions(videoId: 'VIDEO_ID'),
  // For private video: VideoOptions(videoId: "YOUR_VIDEO_ID", token: "YOUR_PRIVATE_TOKEN")
  onPlay: () => print('PLAY'),
  onPause: () => print('PAUSE'),
);
```

#### Add a new event listener: Method 2

Once the [ApiVideoPlayerController](https://github.com/apivideo/api.video-flutter-player/blob/main/lib/src/apivideo_player_controller.dart) has been instantiated, you can bind callbacks to some events:

```dart

final ApiVideoPlayerController controller = ApiVideoPlayerController(
  videoOptions: VideoOptions(videoId: 'VIDEO_ID'),
  // For private video: VideoOptions(videoId: "YOUR_VIDEO_ID", token: "YOUR_PRIVATE_TOKEN")
);

await controller.initialize();

final ApiVideoPlayerControllerEventsListener eventsListener =
ApiVideoPlayerControllerEventsListener(
  onPlay: () => print('PLAY'),
);

controller.addListener(eventsListener);
```

| Event   | Type             | Description                                            |
|---------|------------------|--------------------------------------------------------|
| onReady | VoidCallback     | A callback called when the video is ready to be played |
| onPlay  | VoidCallback     | A callback called when the video is played             |
| onPause | VoidCallback     | A callback called when the video is paused             |
| onEnd   | VoidCallback     | A callback called when the video has ended             |
| onError | Function(Object) | A callback called when an error occured                |

#### Remove an event listener

To remove an event listener, you need to call the controller's `removeListener` method.

```dart

final ApiVideoPlayerController controller = ApiVideoPlayerController(
  videoOptions: VideoOptions(videoId: 'VIDEO_ID'),
  // For private video: VideoOptions(videoId: "YOUR_VIDEO_ID", token: "YOUR_PRIVATE_TOKEN")
);

await controller.initialize();

final ApiVideoPlayerControllerEventsListener eventsListener =
ApiVideoPlayerControllerEventsListener(
  onPlay: () => print('PLAY'),
);

controller.removeListener(eventsListener);
```

## Sample application

```dart
import 'package:apivideo_player/apivideo_player.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ApiVideoPlayerController _controller = ApiVideoPlayerController(
    videoOptions: VideoOptions(videoId: 'VIDEO_ID'),
    // For private video: VideoOptions(videoId: "YOUR_VIDEO_ID", token: "YOUR_PRIVATE_TOKEN")
    onPlay: () => print('PLAY'),
  );
  String _duration = 'Get duration';

  @override
  void initState() {
    super.initState();
    _controller.initialize();
    _controller.addListener(
      ApiVideoPlayerControllerEventsListener(
        onPause: () => print('PAUSE'),
      ),
    );
  }

  void _getDuration() async {
    final Duration duration = await _controller.duration;
    setState(() {
      _duration = 'Duration: $duration';
    });
  }

  void _muteVideo() {
    _controller.setIsMuted(true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: 400.0,
                  height: 300.0,
                  child: ApiVideoPlayer(
                    controller: _controller,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_off),
                  onPressed: _muteVideo,
                ),
                TextButton(
                  onPressed: _getDuration,
                  child: Text(
                    _duration,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
```

## Dependencies

We are using external library

| Plugin                                           | README                                                  |
|--------------------------------------------------|---------------------------------------------------------|
| [Exoplayer](https://github.com/google/ExoPlayer) | [README.md](https://github.com/google/ExoPlayer#readme) |


## FAQ

If you have any questions, ask us in the [community](https://community.api.video) or
use [issues](https://github.com/apivideo/api.video-flutter-player/issues).
