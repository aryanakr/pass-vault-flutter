import 'package:flutter/foundation.dart';
import 'package:flutter_locker/flutter_locker.dart';
import 'package:string_encryption/string_encryption.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth with ChangeNotifier {
  String? _authKey;

  String? get authKey {
    return _authKey;
  }

  bool get isAuth {
    return _authKey != null;
  }

  Future<bool> fetchAndSetTokensByPassword(String password) async {
    
    final storage = FlutterSecureStorage();
    final entrySalt = await storage.read(key: "passvaultinit");

    final cryptor = StringEncryption();

    final entryTokenKey = (await cryptor.generateKeyFromPassword(password, entrySalt!))!;
    
    
    final passTokenRet = await storage.read(key: entryTokenKey);

    if(passTokenRet == null || passTokenRet.isEmpty){
      return false;
    }

    _authKey = (await cryptor.generateKeyFromPassword(passTokenRet, entrySalt))!;
    notifyListeners();

    return true;
  }

  Future<bool> fetchAndSetTokensByBio() async {
    bool authAvailable = false;
    // Check can authenticate using biometric
    await FlutterLocker.canAuthenticate().then((value) {   
      if (value!) {
        authAvailable = true;
      }
    }).catchError((err) {
      print('Error with biometric authentication: ' + err.toString());
    });

    if (!authAvailable){
      print('can not login with biometric authentication');
      return false;
    }

    final storage = FlutterSecureStorage();
    final entrySalt = await storage.read(key: "passvaultinit");

    String authValue = '';

    await FlutterLocker.retrieve(RetrieveSecretRequest('bioauth',
            AndroidPrompt('Authenticate', 'Cancel'), IOsPrompt('Authenticate')))
        .then((value) {
      if (value.isEmpty){
        return false;
      }
      authValue = value;
    }).catchError((err) {
      return false;
    });

    final cryptor = StringEncryption();
    _authKey = (await cryptor.generateKeyFromPassword(authValue, entrySalt!))!;
    notifyListeners();

    return true;
  }
  
}