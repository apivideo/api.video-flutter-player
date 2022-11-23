[![badge](https://img.shields.io/twitter/follow/api_video?style=social)](https://twitter.com/intent/follow?screen_name=api_video)
&nbsp; [![badge](https://img.shields.io/github/stars/apivideo/api.video-android-live-stream?style=social)](https://github.com/apivideo/api.video-android-live-stream)
&nbsp; [![badge](https://img.shields.io/discourse/topics?server=https%3A%2F%2Fcommunity.api.video)](https://community.api.video)
![](https://github.com/apivideo/API_OAS_file/blob/master/apivideo_banner.png)
<h1 align="center">api.video Swift player</h1>

[api.video](https://api.video) is the video infrastructure for product builders. Lightning fast
video APIs for integrating, scaling, and managing on-demand & low latency live streaming features in
your app.

# Table of contents

- [Table of contents](#table-of-contents)
- [Project description](#project-description)
- [Getting started](#getting-started)
  - [Installation](#installation)
    - [Web usage](#web-usage)
- [Documentation](#documentation)
  - [Instanciation](#instanciation)
    - [1. The ApiVideoPlayer](#1-the-apivideoplayer)
    - [2. The ApiVideoPlayerController](#2-the-apivideoplayercontroller)
  - [Methods](#methods)
  - [Properties](#properties)
- [Dependencies](#dependencies)
- [Sample application](#sample-application)
- [FAQ](#faq)

# Project description

Easily integrate a video player for videos from api.video in your Flutter application for iOS,
Android and Web.

# Getting started

## Installation

Run the following command at the root of your project.

```shell
flutter pub add apivideo_player
```

### Web usage

If you want to use your application as a web app, you need to add the [api.video player SDK](https://github.com/apivideo/api.video-player-sdk) script in `web/index.html` from the root of your project.

```html
<!DOCTYPE html>
<html>
  <head>
    ...
    <!-- Add the following line inside of the head tag -->
    <script src="https://unpkg.com/@api.video/player-sdk" defer></script>
  </head>

  <body>
    ...
  </body>
</html>
```

# Documentation

## Instanciation

### 1. The ApiVideoPlayer

The [ApiVideoPlayer](https://github.com/apivideo/api.video-flutter-player/blob/main/lib/src/apivideo_player.dart) constructor takes 3 parameters:

| Parameter    | Mandatory                | Type                                                                                                                                                | Description                                               |
| ------------ | ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------- |
| controller   | Yes                      | [ApiVideoPlayerController](https://github.com/apivideo/api.video-flutter-player/blob/main/lib/src/apivideo_player_controller.dart)                  | The controller that controls a video player               |
| hideControls | No (default false)       | bool                                                                                                                                                | Allows you to hide or show the controls of a video player |
| theme        | No (default PlayerTheme) | [PlayerTheme](https://github.com/apivideo/api.video-flutter-player/blob/4efe23f20ccf1c9459cee7588da1d3fed74e8e36/lib/src/apivideo_player.dart#L102) | Allows you to customize the video player's colors         |

### 2. The ApiVideoPlayerController

To use a video player and display a video in it, you must intanciate a new controller for each new player you need.

The [ApiVideoPlayerController](https://github.com/apivideo/api.video-flutter-player/blob/main/lib/src/apivideo_player_controller.dart) parameters are:

| Parameter    | Mandatory          | Type                                                                                                                                                | Description                                                                   |
| ------------ | ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| videoOptions | Yes                | [VideoOptions](https://github.com/apivideo/api.video-flutter-player/blob/4efe23f20ccf1c9459cee7588da1d3fed74e8e36/lib/src/apivideo_types.dart#L13)  | Options from the video you want to display inside the current video player    |
| autoplay     | No (default false) | bool                                                                                                                                                | Whether you want your video to be automatically played when it's ready or not |
| onReady      | No                 | VoidCallback                                                                                                                                        | A callback called when the video is ready to be played                        |
| onPlay       | No                 | VoidCallback                                                                                                                                        | A callback called when the video is played                                    |
| onPause      | No                 | VoidCallback                                                                                                                                        | A callback called when the video is paused                                    |
| onEnd        | No                 | VoidCallback                                                                                                                                        | A callback called when the video has ended                                    |
| onError      | No                 | Function(Object)                                                                                                                                    | A callback called when an error occured                                       |

Once intanciated, you need to initialize the controller by calling its `initialize()` method.

```dart
final ApiVideoPlayerController controller = ApiVideoPlayerController(videoOptions: VideoOptions(videoId: 'VIDEO_ID'));
controller.initialize();
```

See the sample application below for more details.

## Methods

Once the [ApiVideoPlayerController](https://github.com/apivideo/api.video-flutter-player/blob/main/lib/src/apivideo_player_controller.dart) has been intenciated, you can control the player it has been assigned to with its methods:

| Method                                     | Description                                                                   |
| ------------------------------------------ | ----------------------------------------------------------------------------- |
| play()                                     | Play the video                                                                |
| pause()                                    | Pause the video                                                               |
| seek(Duration offset)                      | Add/substract the given Duration to/from the playback time                    |
| setVolume(double volume)                   | Change the audio volume to the given value. From 0 to 1 (0 = muted, 1 = 100%) |
| setIsMuted(bool isMuted)                   | Mute/unmute the video                                                         |
| setAutoplay(bool autoplay)                 | Define if the video should start playing as soon as it is loaded              |
| setIsLooping(bool isLooping)               | Define if the video should be played in loop                                  |
| setCurrentTime(Duration currentTime)       | Set the current playback time                                                 |
| setVideoOptions(VideoOptions videoOptions) | Set the video options                                                         |

## Properties

Once the [ApiVideoPlayerController](https://github.com/apivideo/api.video-flutter-player/blob/main/lib/src/apivideo_player_controller.dart) has been intenciated, you can access the video player's properties:

# Dependencies

We are using external library

| Plugin | README |
| ------ | ------ |
| **TODO** [Link to project]() | **TODO** [Link to README]() |

# Sample application

**TODO**

# FAQ

If you have any questions, ask us in the [community](https://community.api.video). Or
use [issues](https://github.com/apivideo/api.video-flutter-player/issues).
