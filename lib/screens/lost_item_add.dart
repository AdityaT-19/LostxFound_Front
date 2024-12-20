import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lostxfound_front/models/locations.dart';
import 'package:lostxfound_front/models/lost_item.dart';
import 'package:lostxfound_front/provider/lost_items_provider.dart';
import 'package:lostxfound_front/provider/user_provider.dart';
import 'package:lostxfound_front/widgets/locations_list.dart';
import 'package:uuid/uuid.dart';

class AddLostItem extends ConsumerStatefulWidget {
  const AddLostItem({super.key});

  @override
  ConsumerState<AddLostItem> createState() => _AddLostItemState();
}

class _AddLostItemState extends ConsumerState<AddLostItem> {
  final key = GlobalKey<FormState>();
  late String lname;
  late String ldescription;
  String? liimage;
  DateTime ldate = DateTime.now();
  late String uid;
  List<LostLocationIns>? probabilyLostLocation;

  final imgPicker = ImagePicker();
  final firebaseStorage = FirebaseStorage.instance;

  Future<File?> _getImageFromCamera() async {
    final pickedFile = await imgPicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<File?> _getImageFromGallery() async {
    final pickedFile = await imgPicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<String?> _uploadImage(File? image) async {
    if (image != null) {
      const Uuid uuid = Uuid();
      final imageName = uuid.v4();
      final storageRef = firebaseStorage
          .ref()
          .child('lost_items')
          .child(uid)
          .child('$imageName.jpg');
      await storageRef.putFile(image);
      final imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    }
    return null;
  }

  Future<void> _getImage() async {
    await Get.bottomSheet<File>(
      Container(
        height: 100,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    final image = await _getImageFromCamera();
                    if (image != null) {
                      final imageUrl = await _uploadImage(image);
                      if (imageUrl != null) {
                        setState(() {
                          liimage = imageUrl;
                        });
                      }
                    }
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                  ),
                ),
                const Text('Camera'),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    final image = await _getImageFromGallery();
                    if (image != null) {
                      final imageUrl = await _uploadImage(image);
                      if (imageUrl != null) {
                        setState(() {
                          liimage = imageUrl;
                        });
                      }
                    }
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.photo,
                    color: Colors.black,
                  ),
                ),
                const Text('Gallery'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    uid = user!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Lost Item',
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Get.theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 50,
                  child: liimage != null
                      ? Image.network(
                          liimage!,
                          fit: BoxFit.fill,
                        )
                      : IconButton(
                          onPressed: () async {
                            await _getImage();
                          },
                          icon: const Icon(Icons.add_a_photo),
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.title),
                    title: Text("Name"),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        lname = value!;
                      },
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.description),
                    title: Text("Description"),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        ldescription = value!;
                      },
                    ),
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
                  CalendarDatePicker(
                    currentDate: ldate,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                    onDateChanged: (date) {
                      ldate = date;
                    },
                  ),
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
                  const SizedBox(
                    height: 10,
                  ),
                  if (probabilyLostLocation != null &&
                      probabilyLostLocation!.isNotEmpty)
                    Column(
                      children: [
                        for (final loc in probabilyLostLocation!)
                          ListTile(
                            title: Text(loc.locid.toString()),
                            subtitle: Text(loc.locdesc ?? ''),
                          ),
                      ],
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final selectedLocs = await Get.dialog(
                        const LocationsListMultiSelect(),
                      );
                      if (selectedLocs != null) {
                        setState(() {
                          probabilyLostLocation = selectedLocs;
                        });
                      }
                    },
                    child: const Text('Select Location'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (key.currentState!.validate()) {
                        key.currentState!.save();
                        liimage ??= '';
                        final lostItem = LostItemIns(
                          lname: lname,
                          ldescription: ldescription,
                          liimage: liimage!,
                          ldate: ldate,
                          uid: uid,
                          probabilyLostLocation: probabilyLostLocation,
                        );
                        ref
                            .read(lostItemsAllProvider.notifier)
                            .addLostItem(lostItem);
                        Get.back();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
