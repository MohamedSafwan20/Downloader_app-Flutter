// For unsounding null-safety of dart
// @dart=2.9

import 'dart:io';
import 'dart:core';

import 'package:downloader/widgets/DownloadedFileListItem.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';

class GetFilesFromDownloads extends StatefulWidget {
  const GetFilesFromDownloads({Key key}) : super(key: key);

  @override
  _GetFilesFromDownloadsState createState() => _GetFilesFromDownloadsState();
}

class _GetFilesFromDownloadsState extends State<GetFilesFromDownloads> {
  var filesfromDownloads;

  getFilesfromDownloads() async {
    // if (status.isGranted) {
    //   var downloadsDirectory =
    //       await ExtStorage.getExternalStoragePublicDirectory(
    //           ExtStorage.DIRECTORY_DOWNLOADS);

    //   var files = await FileManager(root: Directory(downloadsDirectory))
    //       .walk()
    //       .toList();
    //   return files;
    // } else if (status.isPermanentlyDenied) {
    // } else
    //   return [];
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
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  int fileSize =
                      File(snapshot.data[index].path).statSync().size;
                  String fileName = snapshot.data[index].path.split('/').last;

                  return DownloadedFileListItem(
                      fileName: fileName, fileSize: fileSize.toString());
                });
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occured',
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).errorColor),
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        });
  }
}
