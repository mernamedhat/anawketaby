import 'package:ntp/ntp.dart';

class RealTime {
  static final instance = RealTime._();

  DateTime? _now;

  DateTime? _lastUpdate;

  RealTime._();

  Future init() async {
    try {
      _now = await NTP.now(timeout: Duration(seconds: 5));
    } catch (_) {
      _now = DateTime.now();
    }
    _incrementSecond();
    _lastUpdate = _now;
  }

  Future _incrementSecond() async {
    _now = _now!.add(Duration(seconds: 1));
    Future.delayed(Duration(seconds: 1), () => _incrementSecond());
    if (_lastUpdate != null && _now!.difference(_lastUpdate!).inMinutes >= 5) {
      try {
        _now = await NTP.now(timeout: Duration(seconds: 5));
      } catch (_) {
        _now = DateTime.now();
      }
      _lastUpdate = _now;
    }
  }

  DateTime? get now => _now;
}
