import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

// ignore: import_of_legacy_library_into_null_safe
import 'package:ext_storage/ext_storage.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;

import '../styles/buttons.dart';

String fileSize = '';
var taskId;

TextEditingController linkController = TextEditingController();
TextEditingController nameController = TextEditingController();

void downloadCallback(String id, DownloadTaskStatus status, int progress) {
  final SendPort? send = IsolateNameServer.lookupPortByName('downloaderport');
  send?.send({
    "id": id,
    "status": status,
    "progress": progress,
  });
}

download(BuildContext context, String link, String fileName) async {
  var downloadsDirectory = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);

  http.Response res = await http.head(Uri.parse(link));
  fileSize = filesize(res.headers['content-length']);

  if (Directory(downloadsDirectory).existsSync()) {
    taskId = await FlutterDownloader.enqueue(
      url: link,
      savedDir: downloadsDirectory,
      fileName: fileName,
      showNotification: true,
      openFileFromNotification: true,
    );

    Navigator.of(context).pop();
  } else {
    Directory(downloadsDirectory).createSync();
  }
}

showDownloaderModal(BuildContext context) {
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
                if (linkController.text == '' || nameController.text == '') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please provide link and name of download",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor))));
                } else {
                  download(context, linkController.text, nameController.text);
                  linkController.text = '';
                }
              },
            ),
          ],
        );
      });
}
