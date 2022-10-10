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
