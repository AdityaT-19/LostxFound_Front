import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lostxfound_front/models/lost_item.dart';
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
      appBar: AppBar(
        title: Text(lostitem.lname),
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
            InkWell(
              child: Container(
                alignment: Alignment.center,
                child: CircleAvatar(
                  child: image,
                  radius: 100,
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
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.title),
                    title: Text("name"),
                  ),
                  Text(
                    lostitem.lname,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onLongPress: () {
                if (lostitem.uid == uid) {
                  _onTapLostItemUpdate("ldescription");
                }
              },
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.description),
                    title: Text("description"),
                  ),
                  Text(
                    lostitem.ldescription,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.perm_identity),
                  title: Text("uid"),
                ),
                Text(
                  lostitem.uid,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.perm_identity),
                  title: Text("student name"),
                ),
                Text(
                  lostitem.sname,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.date_range),
                  title: Text("Date"),
                ),
                Text(DateFormat.yMMMMEEEEd().format(lostitem.ldate)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text("Probable Locations"),
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
                          title:
                              Text("Building Name : ${probableLocation.bname}"),
                          subtitle: Text("Floor : ${probableLocation.floor}"),
                        ),
                        subtitle: Text(
                            "Description : ${probableLocation.locdesc ?? "--"}"),
                        trailing: Text(probableLocation.aname),
                      );
                    },
                  )
                else
                  const ListTile(
                    title: Text("None"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
