import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class GetFilesFromDownloads extends StatefulWidget {
  const GetFilesFromDownloads({Key? key}) : super(key: key);

  @override
  _GetFilesFromDownloadsState createState() => _GetFilesFromDownloadsState();
}

class _GetFilesFromDownloadsState extends State<GetFilesFromDownloads> {
  var filesfromDownloads;

  getFilesfromDownloads() async {
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      var downloadsDirectory =
          await ExtStorage.getExternalStoragePublicDirectory(
              ExtStorage.DIRECTORY_DOWNLOADS);

      var fm = FileManager(root: Directory(downloadsDirectory));
      var files = await fm.filesTree();
      return files;
    } else if (status.isPermanentlyDenied) {
      // TODO: show snackbar
      openAppSettings();
    } else
      return [];
  }

  @override
  void initState() {
    super.initState();

    filesfromDownloads = getFilesfromDownloads();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: filesfromDownloads,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: filesfromDownloads.length,
                itemBuilder: (context, index) {
                  return Container();
                });
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occured',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return CircularProgressIndicator();
        });
  }
}
