import 'package:flutter/foundation.dart';
import 'package:pass_vault/helpers/db_helper.dart';

import 'package:pass_vault/models/password_entry.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:string_encryption/string_encryption.dart';


class PasswordEntries with ChangeNotifier {
  List<PasswordEntry> _items = [];

  List<PasswordEntry> get items {
    return [..._items];
  }

  final String authKey;

  PasswordEntries(this.authKey, this._items);

  Future<void> addPasswordEntry(
    String title,
    String actualPassword,
    String? website,
    String? username,
    String? email,
    String? description,
  ) async {
    // process and save actual password
    final cryptor = StringEncryption();

    final fakePassword = await cryptor.generateRandomKey();
    final secureKey = await cryptor.encrypt(fakePassword!, authKey);
    final encryptedPassword = await cryptor.encrypt(actualPassword, authKey);

    final storage = new FlutterSecureStorage();
    await storage.write(key: secureKey!, value: encryptedPassword);
    
    // create entry
    final newEntry = PasswordEntry(
      id: DateTime.now().toString(),
      title: title,
      website: website,
      username: username,
      email: email,
      description: description,
      password: fakePassword,
    );
    _items.add(newEntry);
    notifyListeners();

    // push to database
    var dataMap = {
      'id': newEntry.id,
      'title': newEntry.title,
      'password': newEntry.password,
    };
    if (newEntry.website != null) {
      dataMap.addAll({'website': newEntry.website!});
    }
    if (newEntry.username != null) {
      dataMap.addAll({'username': newEntry.username!});
    }
    if (newEntry.email != null) {
      dataMap.addAll({'email': newEntry.email!});
    }
    if (newEntry.description != null) {
      dataMap.addAll({'description': newEntry.description!});
    }
    DBHelper.insert('user_password_entries', dataMap);
  }

  Future<void> fetchAndSetEntries() async {
    final dataList = await DBHelper.getData('user_password_entries');
    _items = dataList.map((e) => PasswordEntry(
      id: e['id'],
      title: e['title'],
      website: e['website'],
      username: e['username'],
      email: e['email'],
      description: e['description'],
      password: e['password'],
    )).toList();

    notifyListeners();
  }

  PasswordEntry findEntryById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}