import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:lostxfound_front/provider/found_item_provider.dart';
import 'package:lostxfound_front/provider/user_provider.dart';
import 'package:lostxfound_front/screens/found_item_add.dart';
import 'package:lostxfound_front/screens/found_item_details.dart';
import 'package:lostxfound_front/screens/splash_screen.dart';
import 'package:lostxfound_front/widgets/expandable_fab.dart';

class FoundItemsScreen extends ConsumerStatefulWidget {
  const FoundItemsScreen({super.key});

  @override
  ConsumerState<FoundItemsScreen> createState() => _FoundItemsScreenState();
}

class _FoundItemsScreenState extends ConsumerState<FoundItemsScreen> {
  bool _isByUser = false;
  @override
  void initState() {
    ref
        .read(foundItemsAllProvider.notifier)
        .fetchAndSetFoundItemsByLostItems(ref.read(userProvider)!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    if (user == null) {
      return const SplashScreen();
    }
    void _onPressedFloatButton() {
      Get.dialog(
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                child: Text('By Lost Items'),
                onPressed: () {
                  ref
                      .read(foundItemsAllProvider.notifier)
                      .fetchAndSetFoundItemsByLostItems(user!.uid);
                  _isByUser = false;
                  Get.back();
                },
              ),
              TextButton(
                child: Text('By User'),
                onPressed: () {
                  ref
                      .read(foundItemsAllProvider.notifier)
                      .fetchAndSetFoundItemsByUser(user!.uid);
                  _isByUser = true;
                  Get.back();
                },
              ),
            ],
          ),
        ),
      );
    }

    void _onTapFoundItem(int index) {
      Get.to(() => FoundItemDetails(index: index));
    }

    final foundItems = ref.watch(foundItemsAllProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Found Items'),
      ),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () {
              _onPressedFloatButton();
            },
            icon: const Icon(Icons.filter_alt),
          ),
          if (_isByUser)
            ActionButton(
              onPressed: () {
                Get.to(() => const AddFoundItem());
              },
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: foundItems.length,
        itemBuilder: (context, index) {
          final foundItem = foundItems[index];
          Image image;

          try {
            // Check if the URL starts with http or https
            if (foundItem.fimage.startsWith('http') ||
                foundItem.fimage.startsWith('https')) {
              image = Image.network(foundItem.fimage);
            } else {
              // Treat it as a local asset
              throw ArgumentError('Invalid network URL: ${foundItem.fimage}');
            }
          } catch (e) {
            print('Error loading image: $e');
            image = Image.asset('assets/images/placeholder.png');
          }

          return ListTile(
            leading: CircleAvatar(
              child: image,
            ),
            title: Text(foundItem.fname),
            trailing: Text(foundItem.uid),
            onTap: () => _onTapFoundItem(index),
          );
        },
      ),
    );
  }
}
