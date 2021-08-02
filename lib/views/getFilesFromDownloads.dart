// For unsounding null-safety of dart
// @dart=2.9

import 'dart:core';
import 'dart:io';

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

  getFilesfromDownloads() async* {
    var downloadsDirectory = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);

    var files =
        await FileManager(root: Directory(downloadsDirectory)).walk().toList();

    yield files;
  }

  @override
  void initState() {
    super.initState();

    filesfromDownloads = getFilesfromDownloads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Finished",
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
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
        body: Container(
            child: StreamBuilder(
                stream: getFilesfromDownloads(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          int fileSize =
                              File(snapshot.data[index].path).statSync().size;
                          String fileName =
                              snapshot.data[index].path.split('/').last;

                          return DownloadedFileListItem(
                              file: snapshot.data[index],
                              fileName: fileName,
                              fileSize: fileSize.toString());
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
                })));
  }
}
