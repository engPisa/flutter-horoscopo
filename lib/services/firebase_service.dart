import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  static final _database = FirebaseDatabase.instance.ref(); // <-- ref() correto com novo SDK!

  static Future<void> savePassword(String password) async {
    await _database.child('passwords').push().set({
      'password': password,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static Future<void> saveHoroscope(String sign, String horoscopeText) async {
    await _database.child('horoscopes').push().set({
      'sign': sign,
      'horoscope': horoscopeText,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static DatabaseReference getPasswordHistory() {
    return _database.child('passwords');
  }

  static DatabaseReference getHoroscopeHistory() {
    return _database.child('horoscopes');
  }

  static Future<void> clearPasswordHistory() async {
    await _database.child('passwords').remove();
  }

  static Future<void> clearHoroscopeHistory() async {
    await _database.child('horoscopes').remove();
  }
}
