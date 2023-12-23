import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:lostxfound_front/provider/found_item_provider.dart';

class FoundItemsScreen extends ConsumerStatefulWidget {
  const FoundItemsScreen({super.key});

  @override
  ConsumerState<FoundItemsScreen> createState() => _FoundItemsScreenState();
}

class _FoundItemsScreenState extends ConsumerState<FoundItemsScreen> {
  @override
  Widget build(BuildContext context) {
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
                      .fetchAndSetFoundItemsByLostItems();
                  Get.back();
                },
              ),
              TextButton(
                child: Text('By User'),
                onPressed: () {
                  ref
                      .read(foundItemsAllProvider.notifier)
                      .fetchAndSetFoundItemsByUser();
                  Get.back();
                },
              ),
            ],
          ),
        ),
      );
    }

    final foundItems = ref.watch(foundItemsAllProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Found Items'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressedFloatButton,
        child: const Icon(Icons.filter_alt_rounded),
      ),
      body: ListView.builder(
        itemCount: foundItems.length,
        itemBuilder: (context, index) {
          final foundItem = foundItems[index];
          ImageProvider imageProvider =
              const AssetImage('assets/images/placeholder.png');
          try {
            //imageProvider = NetworkImage(foundItem.liimage);
          } catch (e) {
            imageProvider = const AssetImage('assets/images/placeholder.png');
          }
          return ListTile(
            leading: CircleAvatar(
              child: Image(image: imageProvider),
            ),
            title: Text(foundItem.fname),
            trailing: Text(foundItem.uid),
          );
        },
      ),
    );
  }
}
