import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lostxfound_front/provider/user_provider.dart';
import 'package:lostxfound_front/screens/home_screen.dart';
import 'package:lostxfound_front/screens/login_screen.dart';
import 'package:lostxfound_front/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialStreamBuilder extends ConsumerWidget {
  const InitialStreamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> _setUser() async {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid');
      if (uid != null) {
        ref.watch(userProvider.notifier).fetchAndSetUser(uid);
      }
    }

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        if (snapshot.hasData) {
          return FutureBuilder(
            future: _setUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }
              return const HomeScreen();
            },
          );
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}
