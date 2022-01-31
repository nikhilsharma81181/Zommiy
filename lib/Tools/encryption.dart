import 'package:encrypt/encrypt.dart' as encrypt;

class AESEncryption {
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  decryptData(encrypt.Encrypted data) => encrypter.decrypt(data, iv: iv);

  getCode(String encoded) => encrypt.Encrypted.fromBase16(encoded);
}
