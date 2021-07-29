import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:ext_storage/ext_storage.dart';
import "package:flutter/material.dart";
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';

import "../services/modal.dart" as modal;

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> downloadInfo = {
    "id": null,
    "status": null,
    "progress": 0
  };

  static var filesfromDownloads;

  Future<List> getFilesfromDownloads() async {
    var downloadsDirectory = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);

    var fm = FileManager(root: Directory(downloadsDirectory));
    var files = await fm.filesTree();
    return files;
  }

  ReceivePort receivePort = ReceivePort();

  @override
  void initState() {
    super.initState();

    filesfromDownloads = getFilesfromDownloads();

    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, "downloaderport");

    receivePort.listen((info) {
      setState(() {
        downloadInfo['progress'] = info['progress'];
      });
    });

    FlutterDownloader.registerCallback(modal.downloadCallback);
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
                onPressed: () async {
                  modal.showDownloaderModal(context);
                  // http.Response r = await http.head(Uri.parse(
                  //     "https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-602.exe"));
                  // print(r.headers);
                },
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).accentColor,
                  size: 30,
                ))
          ],
        ),
        backgroundColor: Theme.of(context).accentColor,
        body: FutureBuilder(
            future: filesfromDownloads,
            builder: (context, snapshot) {
              // If we got an error
              if (snapshot.hasData) {
                print(snapshot.data);
                return Center(
                  child: Text(
                    "${snapshot.data}",
                    style: TextStyle(fontSize: 18),
                  ),
                );

                // if we got our data
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occured',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
              return CircularProgressIndicator();
            }));
  }
}

// Container(
//           // color: Colors.blue,
//           width: double.infinity,
//           //TODO: this takes full height of parent
//           // height: 70,
//           padding: EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 4.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Icon(
//                       Icons.download,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     Text("modal.nameController.text"),
//                     Text("800mb",
//                         style:
//                             TextStyle(color: Theme.of(context).disabledColor)),
//                   ],
//                 ),
//               ),
//               LinearProgressIndicator(
//                 backgroundColor: Theme.of(context).disabledColor,
//                 valueColor:
//                     AlwaysStoppedAnimation(Theme.of(context).indicatorColor),
//                 minHeight: 20,
//                 value: 0.5,
//               )
//             ],
//           )),
