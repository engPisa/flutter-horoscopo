import 'dart:math';

class PasswordGenerator {
  static String generate({
    int length = 12,
    bool hasUppercase = true,
    bool hasNumbers = true,
    bool hasSymbols = true,
  }) {
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()-_=+[]{};:,.<>?';

    String chars = lowercase;
    if (hasUppercase) chars += uppercase;
    if (hasNumbers) chars += numbers;
    if (hasSymbols) chars += symbols;

    final rand = Random.secure();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
  }
}
