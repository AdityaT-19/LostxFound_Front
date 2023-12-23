import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:lostxfound_front/provider/lost_items_provider.dart';
import 'package:lostxfound_front/screens/lost_item_details.dart';

class LostItemsScreen extends ConsumerStatefulWidget {
  const LostItemsScreen({super.key});

  @override
  ConsumerState<LostItemsScreen> createState() => _LostItemsScreenState();
}

class _LostItemsScreenState extends ConsumerState<LostItemsScreen> {
  @override
  Widget build(BuildContext context) {
    void _onPressedFloatButton() {
      Get.dialog(
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                child: Text('All'),
                onPressed: () {
                  ref
                      .read(lostItemsAllProvider.notifier)
                      .fetchAndSetLostItems();
                  Get.back();
                },
              ),
              TextButton(
                child: Text('By User'),
                onPressed: () {
                  ref
                      .read(lostItemsAllProvider.notifier)
                      .fetchLostItemsByUser("01JCE21CS001");
                  Get.back();
                },
              ),
            ],
          ),
        ),
      );
    }

    void _onTapLostItem(int index) {
      Get.to(() => LostItemDetails(index: index));
    }

    final lostItems = ref.watch(lostItemsAllProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost Items'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPressedFloatButton,
        child: const Icon(Icons.filter_alt_rounded),
      ),
      body: ListView.builder(
        itemCount: lostItems.length,
        itemBuilder: (context, index) {
          final lostItem = lostItems[index];
          ImageProvider imageProvider =
              const AssetImage('assets/images/placeholder.png');
          try {
            //imageProvider = NetworkImage(lostItem.liimage);
          } catch (e) {
            imageProvider = const AssetImage('assets/images/placeholder.png');
          }
          return ListTile(
            leading: CircleAvatar(
              child: Image(image: imageProvider),
            ),
            title: Text(lostItem.lname),
            trailing: Text(lostItem.uid),
            onTap: () => _onTapLostItem(index),
          );
        },
      ),
    );
  }
}
