import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lostxfound_front/models/found_items.dart';
import 'package:lostxfound_front/provider/found_item_provider.dart';
import 'package:lostxfound_front/provider/user_provider.dart';
import 'package:lostxfound_front/widgets/locations_list.dart';
import 'package:uuid/uuid.dart';

class AddFoundItem extends ConsumerStatefulWidget {
  const AddFoundItem({super.key});

  @override
  ConsumerState<AddFoundItem> createState() => _AddFoundItemState();
}

class _AddFoundItemState extends ConsumerState<AddFoundItem> {
  final key = GlobalKey<FormState>();
  late String fname;
  late String fdescription;
  String? fimage;
  DateTime? fdate;
  late int locid;
  late String locdesc;
  late String uid;

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
          .child('found_items')
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
                          fimage = imageUrl;
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
                          fimage = imageUrl;
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
          'Add Found Item',
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
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 50,
                  child: ClipOval(
                    child: fimage != null
                        ? Image.network(
                            fimage!,
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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
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
                        fname = value!;
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
                    leading: Icon(Icons.description),
                    title: Text("Description"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
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
                        fdescription = value!;
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
                    currentDate: fdate,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                    onDateChanged: (date) {
                      fdate = date;
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
                  LocationsSingleSelect(
                    onTap: (locid) {
                      this.locid = locid;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Location Description',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a location description';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        locdesc = value!;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (key.currentState!.validate()) {
                        key.currentState!.save();
                        fdate ??= DateTime.now();
                        if (fimage == null) {
                          Get.snackbar(
                            'Error',
                            'Please upload an image',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        final foundItem = FoundItemIns(
                          fname: fname,
                          fdescription: fdescription,
                          fimage: fimage!,
                          fdate: fdate!,
                          locid: locid,
                          locdesc: locdesc,
                          uid: uid,
                        );
                        ref
                            .read(foundItemsAllProvider.notifier)
                            .addFoundItem(foundItem);
                        Get.back();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
