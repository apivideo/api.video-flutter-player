# Changelog

All changes to this project will be documented in this file.

## [1.4.0] - 2024-07-26

- Use Analytics endpoint v2
- android: gradle: remove imperative apply
- android: fix `setIsMuted` method. See [#56](https://github.com/apivideo/api.video-flutter-player/issues/56)
- android: fix crash due to missing `release` of the `MediaSession`. See [#58](https://github.com/apivideo/api.video-flutter-player/issues/58)
- example: infer video type from mediaId
- upgrade dependencies

## [1.3.0] - 2024-03-01

- iOS: add support for private live stream
- web: format file to fix pub points

## [1.2.2] - 2024-02-15

- Android: upgrade to gradle 8, AGP and Kotlin to 1.9
- Fix few warnings

## [1.2.1] - 2023-12-05

- Add an API to set the duration when the overlay is displayed
- Web: Inject the player sdk bundle to simplify web integration
- Web: Fix a crash when the player is created
- Fix a crash when the player is disposed due to double dispose
- Improve comments
- Privatize some methods

## [1.2.0] - 2023-10-11

- Add support for live stream videos
- Add support for Android >= 21
- Add support for Android 34
- Add a `fit` parameter to `ApiVideoPlayer` to set how the video is displayed in its box
- Improve the customization of `ApiVideoPlayer` with `PlayerStyle`
- Refactor widgets to split into several widgets

## [1.1.0] - 2023-07-26

- Add support for private videos
- Add support for playback speed
- iOS: add support from iOS 11
- Web: close player events when player is disposed
- Web: remove CSS border on player
- Web: fix player sdk event on release and profile mode
- Web: fix `getVideoSize` API that caused a bad aspect ratio with border
- Android: fix the duration of the video when the video is not loaded
- Android: fix crash when the current time < 0
- Android: fix a crash due to obfuscation (
  see [#43](https://github.com/apivideo/api.video-flutter-player/issues/43))

## [1.0.0] - 2022-10-10

- First version
