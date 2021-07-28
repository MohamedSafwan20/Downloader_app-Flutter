import 'dart:isolate';
import 'dart:ui';

import "package:flutter/material.dart";
import 'package:flutter_downloader/flutter_downloader.dart';
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

  ReceivePort receivePort = ReceivePort();

  @override
  void initState() {
    super.initState();

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
              onPressed: () {
                modal.showDownloaderModal(context);
              },
              icon: Icon(
                Icons.add,
                color: Theme.of(context).accentColor,
                size: 30,
              ))
        ],
      ),
      backgroundColor: Theme.of(context).accentColor,
      body: Column(
        children: [
          Text(downloadInfo["progress"].toString()),
          ElevatedButton(
              onPressed: () {
                FlutterDownloader.cancel(taskId: modal.taskId);
              },
              child: Text("cancel"))
        ],
      ),
    );
  }
}
