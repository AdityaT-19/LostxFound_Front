import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lostxfound_front/screens/found_items_screen.dart';
import 'package:lostxfound_front/screens/lost_items_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final List<Widget> _pages = [
    const LostItemsScreen(),
    const FoundItemsScreen(),
  ];
  var _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 236, 198, 4),
          title: const Text('LostXFound'),
          actions: [
            //logout
            IconButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('uid');
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout),
            ),
          ]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 193, 213, 246),
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 236, 198, 4),
            icon: Icon(Icons.location_off_rounded),
            label: 'Lost',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 236, 198, 4),
            icon: Icon(Icons.location_on_rounded),
            label: 'Found',
          ),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
      ),
      body: _pages[_selectedPageIndex],
    );
  }
}
