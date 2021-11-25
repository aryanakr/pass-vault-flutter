import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:string_encryption/string_encryption.dart';

class PasswordEntry {
  final String id;
  final String title;
  final String? website;
  final String? username;
  final String? email;
  final String? description;
  final String password;

  PasswordEntry({
    required this.id,
    required this.title,
    this.website,
    this.username,
    this.email,
    this.description,
    required this.password,
  });


  Future<String> retrieveActualPassword(String authKey) async {
    final cryptor = StringEncryption();

    final fakePassword = await cryptor.decrypt(password, authKey);

    final storage = FlutterSecureStorage();
    String? actualPasswordEnc = await storage.read(key: fakePassword!);

    if (actualPasswordEnc == null) {
      return '';
    }

    final actualPassword = await cryptor.decrypt(actualPasswordEnc, authKey);
    return actualPassword!;
  }
}
