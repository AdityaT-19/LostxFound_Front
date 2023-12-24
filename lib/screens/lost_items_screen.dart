import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:lostxfound_front/provider/lost_items_provider.dart';
import 'package:lostxfound_front/screens/lost_item_add.dart';
import 'package:lostxfound_front/screens/lost_item_details.dart';
import 'package:lostxfound_front/widgets/expandable_fab.dart';
import 'package:lostxfound_front/widgets/locations_list.dart';

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

    void _onTapAdd() {
      Get.to(() => AddLostItem());
    }

    final lostItems = ref.watch(lostItemsAllProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost Items'),
      ),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: _onPressedFloatButton,
            icon: const Icon(Icons.filter_alt_rounded),
          ),
          ActionButton(icon: Icon(Icons.add), onPressed: _onTapAdd),
        ],
      ),
      body: ListView.builder(
        itemCount: ref.watch(lostItemsAllProvider).length,
        itemBuilder: (context, index) {
          final lostItem = lostItems[index];
          Image image;

          try {
            // Check if the URL starts with http or https
            if (lostItem.liimage.startsWith('http') ||
                lostItem.liimage.startsWith('https')) {
              image = Image.network(lostItem.liimage);
            } else {
              // Treat it as a local asset
              throw ArgumentError('Invalid network URL: ${lostItem.liimage}');
            }
          } catch (e) {
            print('Error loading image: $e');
            image = Image.asset('assets/images/placeholder.png');
          }

          return ListTile(
            leading: CircleAvatar(
              child: image,
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
