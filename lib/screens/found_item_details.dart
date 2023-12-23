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
    final founditem = ref.watch(foundItemsAllProvider)[widget.index];
    late ImageProvider imageProvider;
    imageProvider = const AssetImage('assets/images/placeholder.png');
    try {
      //imageProvider = NetworkImage(lostitem.liimage);
    } catch (e) {
      imageProvider = const AssetImage('assets/images/placeholder.png');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(founditem.fname),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: CircleAvatar(
                child: Image(
                  image: imageProvider,
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
                  title: Text("name"),
                ),
                Text(
                  founditem.fname,
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
                  founditem.fdescription,
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
                  founditem.uid,
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
                  founditem.sname,
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
                Text(DateFormat.yMMMMEEEEd().format(founditem.fdate)),
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
                    title: Text("Building Name : ${founditem.location.bname}"),
                    subtitle: Text("Floor : ${founditem.location.floor}"),
                  ),
                  subtitle: Text("Description : ${founditem.location.locdesc}"),
                  trailing: Text(founditem.location.aname),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
