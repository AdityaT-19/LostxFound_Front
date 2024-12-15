import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:lostxfound_front/provider/lost_items_provider.dart';
import 'package:lostxfound_front/provider/user_provider.dart';
import 'package:lostxfound_front/screens/lost_item_add.dart';
import 'package:lostxfound_front/screens/lost_item_details.dart';
import 'package:lostxfound_front/screens/splash_screen.dart';
import 'package:lostxfound_front/widgets/expandable_fab.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class LostItemsScreen extends ConsumerStatefulWidget {
  const LostItemsScreen({super.key});

  @override
  ConsumerState<LostItemsScreen> createState() => _LostItemsScreenState();
}

class _LostItemsScreenState extends ConsumerState<LostItemsScreen> {
  bool _isByUser = false;

  @override
  Widget build(BuildContext context) {
    if (ref.watch(userProvider) == null) {
      return const SplashScreen();
    }
    final uid = ref.watch(userProvider)!.uid;
    void _onPressedFloatButton() {
      Get.dialog(
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                child: Text('All'),
                onPressed: () {
                  _isByUser = false;
                  ref
                      .read(lostItemsAllProvider.notifier)
                      .fetchAndSetLostItems();
                  Get.back();
                },
              ),
              TextButton(
                child: Text('By User'),
                onPressed: () {
                  _isByUser = true;
                  ref
                      .read(lostItemsAllProvider.notifier)
                      .fetchLostItemsByUser(uid);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Lost Items',
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
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
      body: LiquidPullToRefresh(
        onRefresh: () async {
          if (_isByUser) {
            ref.read(lostItemsAllProvider.notifier).fetchLostItemsByUser(uid);
          } else {
            ref.read(lostItemsAllProvider.notifier).fetchAndSetLostItems();
          }
        },
        child: ListView.builder(
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

            return InkWell(
              onTap: () {
                _onTapLostItem(index);
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.all(10),
                color: Colors.white,
                elevation: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: lostItem.lid,
                      child: Image(
                        image: image.image,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                    ListTile(
                      title: Text(lostItem.lname,
                          style:
                              Get.textTheme.bodyLarge!.copyWith(fontSize: 20)),
                      tileColor: Colors.transparent,
                      subtitle: Text(lostItem.uid),
                      style: ListTileStyle.drawer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
