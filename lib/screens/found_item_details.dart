import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
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
      backgroundColor: const Color.fromARGB(255, 212, 230, 247),
      appBar: AppBar(
        title: Text(foundItem.fname),
        backgroundColor: const Color.fromARGB(255, 177, 232, 228),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 90,
                backgroundColor: const Color.fromARGB(255, 177, 232, 228),
                child: ClipOval(
                  child: image,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 177, 232, 228),
              ),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.title),
                    title: Text("Name"),
                  ),
                  Text(
                    foundItem.fname,
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
                color: const Color.fromARGB(255, 177, 232, 228),
              ),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.description),
                    title: Text("Description"),
                  ),
                  Text(
                    foundItem.fdescription,
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
                color: const Color.fromARGB(255, 177, 232, 228),
              ),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.perm_identity),
                    title: Text("UID"),
                  ),
                  Text(
                    foundItem.uid,
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
                color: const Color.fromARGB(255, 177, 232, 228),
              ),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.perm_identity),
                    title: Text("Student Name"),
                  ),
                  Text(
                    foundItem.sname,
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 177, 232, 228),
              ),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.date_range),
                    title: Text("Date"),
                  ),
                  Text(DateFormat.yMMMMEEEEd().format(foundItem.fdate)),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 177, 232, 228),
              ),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text("Location"),
                  ),
                  ListTile(
                    title: ListTile(
                      title: Text(
                        "Building Name : ${foundItem.location.bname}",
                        style: Get.textTheme.bodyMedium,
                      ),
                      subtitle: Text(
                        "Floor : ${foundItem.location.floor}",
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                    subtitle:
                        Text("Description : ${foundItem.location.locdesc}"),
                    trailing: Text(foundItem.location.aname),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
