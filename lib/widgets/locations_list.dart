import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:lostxfound_front/models/locations.dart';
import 'package:lostxfound_front/provider/locations_provider.dart';

class LocationsListMultiSelect extends ConsumerStatefulWidget {
  const LocationsListMultiSelect({super.key});

  @override
  ConsumerState<LocationsListMultiSelect> createState() =>
      _LocationsListMultiSelectState();
}

class _LocationsListMultiSelectState
    extends ConsumerState<LocationsListMultiSelect> {
  late List<Location> locations;
  late List<bool> selectedindices;
  late List<TextEditingController> selectedLocDecController;
  @override
  void initState() {
    // TODO: implement initState
    locations = ref.read(locationsProvider);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    final locations = ref.watch(locationsProvider);
    selectedindices = List<bool>.generate(locations.length, (index) => false);
    selectedLocDecController = List<TextEditingController>.generate(
        locations.length, (index) => TextEditingController());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    void _showDescriptionDialog(Location location) async {
      Get.dialog(
        AlertDialog(
          title: const Text("Enter Description"),
          actions: [
            TextButton(
              onPressed: () {
                selectedLocDecController[locations.indexOf(location)].clear();
                Get.back();
              },
              child: const Text('Continue Without Description'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Continue With Description'),
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller:
                    selectedLocDecController[locations.indexOf(location)],
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (locations.isEmpty) {
      Get.back();
    }
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            List<LostLocationIns> selectedLocs = [];
            for (int i = 0; i < selectedindices.length; i++) {
              if (selectedindices[i]) {
                print(i);
                selectedLocs.add(LostLocationIns(
                  locid: locations[i].locid,
                  locdesc: selectedLocDecController[i].text == ""
                      ? null
                      : selectedLocDecController[i].text,
                ));
              }
            }
            Get.back<List<LostLocationIns>>(result: selectedLocs);
          },
          child: const Text('Submit'),
        ),
      ],
      content: SingleChildScrollView(
        child: DataTable(
          onSelectAll: (value) => Get.snackbar(
            'Error',
            'Selecting all is not supported yet!',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
            colorText: Colors.white,
          ),
          columns: const [
            DataColumn(
                label: Text(
              'Building Name',
              style: TextStyle(fontSize: 12),
            )),
            DataColumn(
                label: Text(
              'Floor',
              style: TextStyle(fontSize: 12),
            )),
          ],
          rows: locations
              .map(
                (location) => DataRow(
                  cells: [
                    DataCell(Text(
                      location.bname,
                      style: const TextStyle(fontSize: 10),
                    )),
                    DataCell(Text(
                      location.floor.toString(),
                      style: const TextStyle(fontSize: 10),
                    )),
                  ],
                  selected: selectedindices[locations.indexOf(location)],
                  onSelectChanged: (bool? value) {
                    setState(() {
                      selectedindices[locations.indexOf(location)] = value!;
                      if (selectedindices[locations.indexOf(location)]) {
                        _showDescriptionDialog(location);
                      }
                    });
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class LocationsSingleSelect extends ConsumerStatefulWidget {
  const LocationsSingleSelect({required this.onTap, super.key});
  final void Function(int) onTap;

  @override
  ConsumerState<LocationsSingleSelect> createState() =>
      _LocationsSingleSelectState();
}

class _LocationsSingleSelectState extends ConsumerState<LocationsSingleSelect> {
  @override
  int selectedindex = 0;
  Widget build(BuildContext context) {
    final locations = ref.watch(locationsProvider);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: locations.length,
      itemBuilder: (context, index) {
        return RadioListTile<int>(
          value: index,
          groupValue: selectedindex,
          onChanged: (int? value) {
            setState(() {
              selectedindex = value!;
            });
            widget.onTap(value!);
          },
          title: Text(locations[index].bname),
          secondary: Text(locations[index].floor.toString()),
        );
      },
    );
  }
}
