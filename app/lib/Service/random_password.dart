import 'dart:math';

class RandomPassword {
  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  int _len = 10;

  RandomPassword({int? length}) {
    if (length != null) {
      _len = length;
    }
  }

  String get password => _random(_len);

  String _random(int length) {
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
