enum VideoType { vod, live }

extension VideoTypeExtension on VideoType {
  String get name {
    switch (this) {
      case VideoType.vod:
        return 'vod';
      case VideoType.live:
        return 'live';
    }
  }
}

class VideoOptions {
  String videoId;
  VideoType videoType;

  VideoOptions({required this.videoId, this.videoType = VideoType.vod});
}
