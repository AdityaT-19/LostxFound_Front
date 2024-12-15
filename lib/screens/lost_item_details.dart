import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lostxfound_front/provider/lost_items_provider.dart';
import 'package:lostxfound_front/provider/user_provider.dart';

class LostItemDetails extends ConsumerStatefulWidget {
  const LostItemDetails({required this.index, super.key});
  final int index;
  @override
  ConsumerState<LostItemDetails> createState() => _LostItemDetailsState();
}

class _LostItemDetailsState extends ConsumerState<LostItemDetails> {
  @override
  Widget build(BuildContext context) {
    final lostitem = ref.watch(lostItemsAllProvider)[widget.index];
    final uid = ref.watch(userProvider)!.uid;
    Image image;

    try {
      // Check if the URL starts with http or https
      if (lostitem.liimage.startsWith('http') ||
          lostitem.liimage.startsWith('https')) {
        image = Image.network(lostitem.liimage);
      } else {
        // Treat it as a local asset
        throw ArgumentError('Invalid network URL: ${lostitem.liimage}');
      }
    } catch (e) {
      print('Error loading image: $e');
      image = Image.asset('assets/images/placeholder.png');
    }

    void _onTapLostItemUpdate(String property) {
      final key = GlobalKey<FormState>();
      Get.dialog(
        AlertDialog(
          title: Text('Update + $property'),
          content: Form(
            key: key,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: property,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (newValue) {
                ref
                    .read(lostItemsAllProvider.notifier)
                    .updateLostItem(lostitem.lid, property, newValue!);
                Navigator.of(context).pop();
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (key.currentState!.validate()) {
                  key.currentState!.save();
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Get.theme.colorScheme.secondaryContainer,
      appBar: AppBar(
        backgroundColor: Get.theme.colorScheme.primary,
        title: Text(
          lostitem.lname,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        actions: [
          //if (lostitem.uid == ref.read(userProvider)!.uid)
          if (lostitem.uid == uid)
            IconButton(
              onPressed: () {
                ref
                    .read(lostItemsAllProvider.notifier)
                    .removeLostItem(lostitem);
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            InkWell(
              child: Hero(
                tag: lostitem.lid,
                child: Container(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: image,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onLongPress: () {
                if (lostitem.uid == uid) {
                  _onTapLostItemUpdate("lname");
                }
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.theme.colorScheme.primary,
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.title, color: Colors.white),
                      title: Text(
                        "Name",
                        style: Get.theme.textTheme.bodyLarge!.copyWith(
                          color: Get.theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    Text(
                      lostitem.lname,
                      style: Get.theme.textTheme.bodyMedium!.copyWith(
                          color: Get.theme.colorScheme.primaryContainer,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onLongPress: () {
                if (lostitem.uid == uid) {
                  _onTapLostItemUpdate("ldescription");
                }
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.theme.colorScheme.primary),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.description, color: Colors.white),
                      title: Text(
                        "Description",
                        style: Get.theme.textTheme.bodyLarge!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    Text(
                      lostitem.ldescription,
                      style: Get.theme.textTheme.bodyMedium!.copyWith(
                          color: Get.theme.colorScheme.primaryContainer,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.theme.colorScheme.primary,
              ),
              child: Column(
                children: [
                  ListTile(
                      leading: Icon(Icons.perm_identity, color: Colors.white),
                      title: Text(
                        "UID",
                        style: Get.theme.textTheme.bodyLarge!.copyWith(
                          color: Get.theme.colorScheme.onPrimary,
                        ),
                      )),
                  Text(
                    lostitem.uid,
                    style: Get.theme.textTheme.bodyMedium!.copyWith(
                      color: Get.theme.colorScheme.primaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.theme.colorScheme.primary,
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.perm_identity, color: Colors.white),
                    title: Text(
                      "Student Name",
                      style: Get.theme.textTheme.bodyLarge!.copyWith(
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Text(
                    lostitem.sname,
                    style: Get.theme.textTheme.bodyMedium!.copyWith(
                        color: Get.theme.colorScheme.primaryContainer,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.theme.colorScheme.primary,
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.date_range, color: Colors.white),
                    title: Text(
                      "Date",
                      style: Get.theme.textTheme.bodyLarge!.copyWith(
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat.yMMMMEEEEd().format(lostitem.ldate),
                    style: Get.theme.textTheme.bodyMedium!.copyWith(
                        color: Get.theme.colorScheme.primaryContainer,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.theme.colorScheme.primary,
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.white),
                    title: Text(
                      "Probable Locations",
                      style: Get.theme.textTheme.bodyLarge!.copyWith(
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  if (lostitem.probablyLost != null &&
                      lostitem.probablyLost!.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: lostitem.probablyLost!.length,
                      itemBuilder: (context, index) {
                        final probableLocation = lostitem.probablyLost![index];
                        return ListTile(
                          title: ListTile(
                            title: Text(
                              "Building Name : ${probableLocation.bname}",
                              style: Get.theme.textTheme.bodyMedium!.copyWith(
                                  color: Get.theme.colorScheme.primaryContainer,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Floor : ${probableLocation.floor}",
                              style: Get.theme.textTheme.bodyMedium!.copyWith(
                                  color: Get.theme.colorScheme.primaryContainer,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          subtitle: Text(
                            "Description : ${probableLocation.locdesc ?? "--"}",
                            style: Get.theme.textTheme.bodyMedium!.copyWith(
                                color: Get.theme.colorScheme.primaryContainer,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            probableLocation.aname,
                            style: Get.theme.textTheme.bodyMedium!.copyWith(
                                color: Get.theme.colorScheme.primaryContainer,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    )
                  else
                    const ListTile(
                      title: Text("None"),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
