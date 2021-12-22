import 'package:flutter/foundation.dart';
import 'package:pass_vault/helpers/db_helper.dart';

import 'package:pass_vault/models/password_entry.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:string_encryption/string_encryption.dart';

import 'package:random_password_generator/random_password_generator.dart';

class PasswordEntries with ChangeNotifier {
  List<PasswordEntry> _items = [];

  List<PasswordEntry> get items {
    return [..._items];
  }

  final String authKey;

  PasswordEntries(this.authKey, this._items);

  Future<void> addPasswordEntry({
    String? id,
    required String title,
    required String actualPassword,
    String? website,
    String? username,
    String? email,
    String? description,
  }) async {
    // process and save actual password

    final passwordGen = RandomPasswordGenerator();
    final fakePassword = passwordGen.randomPassword(
        letters: true,
        numbers: true,
        uppercase: false,
        specialChar: false,
        passwordLength: 8);

    final cryptor = StringEncryption();
    final encryptedFake = await cryptor.encrypt(fakePassword, authKey);
    final encryptedPassword = await cryptor.encrypt(actualPassword, authKey);

    final storage = FlutterSecureStorage();
    await storage.write(key: fakePassword, value: encryptedPassword);

    // create entry
    final newEntry = PasswordEntry(
      id: id ?? DateTime.now().toString(),
      title: title,
      website: website,
      username: username,
      email: email,
      description: description,
      password: encryptedFake!.trim(),
    );
    _items.add(newEntry);
    notifyListeners();

    // push to database
    final encTitle = await cryptor.encrypt(newEntry.title, authKey);
    var dataMap = {
      'id': newEntry.id,
      'title': encTitle!,
      'password': newEntry.password,
    };
    if (newEntry.website != null) {
      final encData = await cryptor.encrypt(newEntry.website!, authKey);
      dataMap.addAll({'website': encData!});
    }
    if (newEntry.username != null) {
      final encData = await cryptor.encrypt(newEntry.username!, authKey);
      dataMap.addAll({'username': encData!});
    }
    if (newEntry.email != null) {
      final encData = await cryptor.encrypt(newEntry.email!, authKey);
      dataMap.addAll({'email': encData!});
    }
    if (newEntry.description != null) {
      final encData = await cryptor.encrypt(newEntry.description!, authKey);
      dataMap.addAll({'description': encData!});
    }
    DBHelper.insert('user_password_entries', dataMap);
  }

  Future<void> fetchAndSetEntries() async {
    final dataList = await DBHelper.getData('user_password_entries');
    _items = await Future.wait(dataList
        .map((e) => PasswordEntry(
              id: e['id'],
              title: e['title'],
              website: e['website'],
              username: e['username'],
              email: e['email'],
              description: e['description'],
              password: e['password'],
            ).getDecripted(authKey)
        ).toList());
        

    notifyListeners();
  }

  PasswordEntry findEntryById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> deletePasswordEntry(PasswordEntry entry) async {
    // Delete actual password
    final cryptor = StringEncryption();

    final passwordSorageKey = await cryptor.decrypt(entry.password, authKey);

    final storage = FlutterSecureStorage();
    await storage.delete(key: passwordSorageKey!);

    // remove from list
    _items.remove(entry);
    notifyListeners();

    // remove entry from database
    await DBHelper.delete('user_password_entries', entry.id);
  }

  Future<void> updatePasswordEntry(
    String id,
    String title,
    String actualPassword,
    String? website,
    String? username,
    String? email,
    String? description,
  ) async {
    PasswordEntry oldEntry = findEntryById(id);
    await deletePasswordEntry(oldEntry);
    await addPasswordEntry(
      id: id,
      title: title,
      actualPassword: actualPassword,
      website: website,
      username: username,
      email: email,
      description: description,
    );
  }
}
