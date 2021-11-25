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

  Future<void> addPasswordEntry(
    String title,
    String actualPassword,
    String? website,
    String? username,
    String? email,
    String? description,
  ) async {
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
      id: DateTime.now().toString(),
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
}