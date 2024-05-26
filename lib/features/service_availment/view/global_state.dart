class GlobalState {
  static final GlobalState _instance = GlobalState._internal();

  factory GlobalState() {
    return _instance;
  }

  GlobalState._internal();

  final List<Map<String, String>> availedServices = [];
}

final globalState = GlobalState();
