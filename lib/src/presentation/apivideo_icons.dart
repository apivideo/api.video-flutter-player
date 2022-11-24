import 'package:flutter/widgets.dart';

class ApiVideoIcons {
  ApiVideoIcons._();

  static const _kFontFam = 'ApiVideoIcons';
  static const String _kFontPkg = 'apivideo_player';

  static const IconData pausePrimary =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData playPrimary =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData replayPrimary =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
