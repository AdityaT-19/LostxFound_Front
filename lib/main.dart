import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lostxfound_front/firebase_options.dart';
import 'package:lostxfound_front/screens/found_item_add.dart';
import 'package:lostxfound_front/screens/found_items_screen.dart';
import 'package:lostxfound_front/screens/home_screen.dart';
import 'package:lostxfound_front/screens/login_screen.dart';
import 'package:lostxfound_front/screens/lost_item_add.dart';
import 'package:lostxfound_front/screens/lost_items_screen.dart';
import 'package:lostxfound_front/widgets/stream_builder_for_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LostXFound',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const InitialStreamBuilder(),
    );
  }
}
