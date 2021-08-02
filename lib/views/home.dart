// ignore: import_of_legacy_library_into_null_safe
import 'package:downloader/widgets/downloadingFileListItem.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import "../services/modal.dart" as modal;

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  getPermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please grant permission for storage access",
              style: TextStyle(color: Theme.of(context).primaryColor))));
      openAppSettings();
    } else if (status.isDenied) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  @override
  void initState() {
    super.initState();

    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          actions: [
            IconButton(
                disabledColor: Theme.of(context).disabledColor,
                onPressed: () {
                  DownloadingListItem.isDownloading
                      ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "A download is in progress, please wait until it finishes",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor))))
                      : modal.showDownloaderModal(context);
                },
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).accentColor,
                  size: 30,
                ))
          ],
        ),
        drawer: Drawer(
          child: Container(
            margin: EdgeInsets.only(top: 28),
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.all(Radius.elliptical(20, 20)),
                  ),
                  child: ListTile(
                    title: const Text(
                      'Downloading',
                      style: TextStyle(color: Colors.amber),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/');
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.all(Radius.elliptical(20, 20)),
                  ),
                  child: ListTile(
                    title: const Text(
                      'Finished',
                      style: TextStyle(color: Colors.amber),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/finished');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Theme.of(context).accentColor,
        body: Column(
          children: [
            Container(child: DownloadingListItem()),
          ],
        ));
  }
}
