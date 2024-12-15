import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lostxfound_front/provider/found_item_provider.dart';

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
      backgroundColor: Get.theme.colorScheme.primaryContainer,
      appBar: AppBar(
        title: Text(
          foundItem.fname,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Get.theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Hero(
              tag: foundItem.fid,
              child: Container(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 90,
                  backgroundColor: Get.theme.colorScheme.primary,
                  child: ClipOval(
                    child: image,
                  ),
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
                    leading: Icon(Icons.title, color: Colors.white),
                    title: Text(
                      "Name",
                      style: Get.theme.textTheme.bodyLarge!.copyWith(
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Text(
                    foundItem.fname,
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
                    leading: Icon(Icons.description, color: Colors.white),
                    title: Text(
                      "Description",
                      style: Get.theme.textTheme.bodyLarge!.copyWith(
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Text(
                    foundItem.fdescription,
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
                    leading: Icon(
                      Icons.perm_identity,
                      color: Colors.white,
                    ),
                    title: Text(
                      "UID",
                      style: Get.theme.textTheme.bodyLarge!.copyWith(
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Text(
                    foundItem.uid,
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
                    leading: Icon(
                      Icons.perm_identity,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Student Name",
                      style: Get.theme.textTheme.bodyLarge!.copyWith(
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Text(
                    foundItem.sname,
                    style: Get.theme.textTheme.bodyMedium!.copyWith(
                        color: Get.theme.colorScheme.primaryContainer,
                        fontWeight: FontWeight.bold),
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
                color: Get.theme.colorScheme.primary,
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.date_range,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Date",
                      style: Get.theme.textTheme.bodyLarge!.copyWith(
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat.yMMMMEEEEd().format(foundItem.fdate),
                    style: Get.theme.textTheme.bodyMedium!.copyWith(
                        color: Get.theme.colorScheme.primaryContainer,
                        fontWeight: FontWeight.bold),
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
                color: Get.theme.colorScheme.primary,
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Location",
                      style: Get.theme.textTheme.bodyLarge!.copyWith(
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  ListTile(
                    title: ListTile(
                      title: Text(
                        "Building Name : ${foundItem.location.bname}",
                        style: Get.theme.textTheme.bodyMedium!.copyWith(
                            color: Get.theme.colorScheme.primaryContainer,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Floor : ${foundItem.location.floor}",
                        style: Get.theme.textTheme.bodyMedium!.copyWith(
                            color: Get.theme.colorScheme.primaryContainer,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Text(
                      "Description : ${foundItem.location.locdesc}",
                      style: Get.theme.textTheme.bodyMedium!.copyWith(
                          color: Get.theme.colorScheme.primaryContainer,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      foundItem.location.aname,
                      style: Get.theme.textTheme.bodyMedium!.copyWith(
                          color: Get.theme.colorScheme.primaryContainer,
                          fontWeight: FontWeight.bold),
                    ),
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
