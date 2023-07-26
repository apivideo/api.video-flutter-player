class FakePlatformViewRegistry {
  void registerViewFactory(
    String viewTypeId,
    dynamic Function(int) viewFactory,
  ) {
    throw UnsupportedError("platform view registry in non-web context");
  }
}

final platformViewRegistry = FakePlatformViewRegistry();
