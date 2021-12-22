import 'package:flutter/material.dart';
import 'package:pass_vault/providers/auth.dart';
import 'package:pass_vault/providers/password_entries.dart';
import 'package:pass_vault/screens/create_entry_screen.dart';
import 'package:pass_vault/screens/edit_entry_screen.dart';
import 'package:pass_vault/screens/entry_detail_screen.dart';
import 'package:pass_vault/screens/passwords_screen.dart';
import 'package:pass_vault/theme/theme.dart';
import 'package:provider/provider.dart';

import 'package:pass_vault/screens/auth_init_screen.dart';
import 'package:pass_vault/screens/login_screen.dart';
import 'package:pass_vault/screens/welcome_screen.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, PasswordEntries>(
          update: (ctx, auth, previousEntries) => PasswordEntries(
              auth.authKey ?? '',
              previousEntries == null ? [] : previousEntries.items),
          create: (ctx) => PasswordEntries('', []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'PassVault',
          theme: AppTheme.bulildLightThme(),
          darkTheme: AppTheme.buildDarkTheme(),
          themeMode: ThemeMode.system, 
          debugShowCheckedModeBanner: false,
          home: auth.isAuth ? PasswordsScreen() : _appEntryScreen(),
          routes: {
            AuthInitScreen.routeName: (ctx) => AuthInitScreen(),
            CreateEntryScreen.routeName: (ctx) => CreateEntryScreen(),
            EntryDetailScreen.routeName: (ctx) => EntryDetailScreen(),
            PasswordsScreen.routeName: (ctx) => PasswordsScreen(),
            EditEntryScreen.routeName: (ctx) => EditEntryScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
          },
        ),
      ),
    );
  }

  Widget _appEntryScreen() {
    const storage = FlutterSecureStorage();
    return FutureBuilder<String?>(
      future: storage.read(key: "passvaultinit"),
      builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : snapshot.data == null || snapshot.data!.isEmpty
                  ? WelcomeScreen()
                  : LoginScreen(),
    );
  }
}
