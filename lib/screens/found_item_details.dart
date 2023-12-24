import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lostxfound_front/provider/found_item_provider.dart';
import 'package:lostxfound_front/provider/lost_items_provider.dart';

class FoundItemDetails extends ConsumerStatefulWidget {
  const FoundItemDetails({required this.index, super.key});
  final int index;
  @override
  ConsumerState<FoundItemDetails> createState() => _FoundItemDetailsState();
}

class _FoundItemDetailsState extends ConsumerState<FoundItemDetails> {
  @override
  Widget build(BuildContext context) {
    final foundItem = ref.watch(foundItemsAllProvider)[widget.index];
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
    return Scaffold(
      appBar: AppBar(
        title: Text(foundItem.fname),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: CircleAvatar(
                child: image,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.title),
                  title: Text("name"),
                ),
                Text(
                  foundItem.fname,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.description),
                  title: Text("description"),
                ),
                Text(
                  foundItem.fdescription,
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
                  title: Text("uid"),
                ),
                Text(
                  foundItem.uid,
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
                  foundItem.sname,
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
                Text(DateFormat.yMMMMEEEEd().format(foundItem.fdate)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text("Location"),
                ),
                ListTile(
                  title: ListTile(
                    title: Text("Building Name : ${foundItem.location.bname}"),
                    subtitle: Text("Floor : ${foundItem.location.floor}"),
                  ),
                  subtitle: Text("Description : ${foundItem.location.locdesc}"),
                  trailing: Text(foundItem.location.aname),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
