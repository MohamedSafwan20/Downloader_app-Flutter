import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:downloader/views/home.dart';
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

  http.Response res = await http.head(Uri.parse(
      "https://download.apkpure.com/b/APK/d2VicGFnZS5yZWZyZXNoZXIud2VicGFnZXJlbG9hZGVyXzJfOTRlNzUyMWE?_fn=QXV0byBCcm93c2VyIFJlZnJlc2hlcl92Mi4wX2Fwa3B1cmUuY29tLmFwaw&as=27daa7b2dc3ecddacf92f9e64b32cfdc6103f4a6&ai=813882815&at=1627649070&_sa=ai%2Cat&k=51c1710d0435d34e74adb406c41ee2f36106972e&_p=d2VicGFnZS5yZWZyZXNoZXIud2VicGFnZXJlbG9hZGVy&c=1%7CTOOLS%7CZGV2PWRldmVsb3BlckFuaXMmdD1hcGsmcz01Njg1MzEyJnZuPTIuMCZ2Yz0y"));
  fileSize = filesize(res.headers['content-length']);

  if (Directory(downloadsDirectory).existsSync()) {
    taskId = await FlutterDownloader.enqueue(
      url:
          "https://download.apkpure.com/b/APK/d2VicGFnZS5yZWZyZXNoZXIud2VicGFnZXJlbG9hZGVyXzJfOTRlNzUyMWE?_fn=QXV0byBCcm93c2VyIFJlZnJlc2hlcl92Mi4wX2Fwa3B1cmUuY29tLmFwaw&as=27daa7b2dc3ecddacf92f9e64b32cfdc6103f4a6&ai=813882815&at=1627649070&_sa=ai%2Cat&k=51c1710d0435d34e74adb406c41ee2f36106972e&_p=d2VicGFnZS5yZWZyZXNoZXIud2VicGFnZXJlbG9hZGVy&c=1%7CTOOLS%7CZGV2PWRldmVsb3BlckFuaXMmdD1hcGsmcz01Njg1MzEyJnZuPTIuMCZ2Yz0y",
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
                // if (linkController.text == '' || nameController.text == '') {
                //   // TODO: show snackbar for empty inputs
                // } else {
                download(context, linkController.text, nameController.text);
                linkController.text = '';
                // }
              },
            ),
          ],
        );
      });
}
