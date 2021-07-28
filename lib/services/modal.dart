import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

// ignore: import_of_legacy_library_into_null_safe
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

import '../styles/buttons.dart';

var taskId;

void downloadCallback(String id, DownloadTaskStatus status, int progress) {
  final SendPort? send = IsolateNameServer.lookupPortByName('downloaderport');
  send?.send({"id": id, "status": status, "progress": progress});
}

download(BuildContext context, var link, var fileName) async {
  var downloadsDirectory = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);
  if (Directory(downloadsDirectory).existsSync()) {
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      taskId = await FlutterDownloader.enqueue(
        url:
            "https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-602.exe",
        savedDir: downloadsDirectory,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );

      Navigator.of(context).pop();
    } else if (status.isPermanentlyDenied) {
      // TODO: show snackbar
      openAppSettings();
    }
  } else {
    Directory(downloadsDirectory).createSync();
  }
}

showDownloaderModal(BuildContext context) {
  TextEditingController linkController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).accentColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(17.0)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '800mb',
                  style: TextStyle(color: Theme.of(context).disabledColor),
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Link: ",
                      ),
                      TextField(
                        autofocus: true,
                        controller: linkController,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name: ",
                      ),
                      TextField(
                        controller: nameController,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: CustomButtonStyle.textButtonSecondary,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Download',
                style: CustomButtonStyle.textButtonPrimary,
              ),
              onPressed: () {
                download(context, linkController.text, nameController.text);
              },
            ),
          ],
        );
      });
}
// https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-602.exe
