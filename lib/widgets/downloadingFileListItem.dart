import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import '../services/modal.dart' as modal;

class DownloadingListItem extends StatefulWidget {
  const DownloadingListItem({Key? key}) : super(key: key);

  @override
  _DownloadingListItemState createState() => _DownloadingListItemState();
}

class _DownloadingListItemState extends State<DownloadingListItem> {
  Map<String, dynamic> downloadInfo = Map<String, dynamic>();

  ReceivePort receivePort = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, "downloaderport");

    receivePort.listen((info) {
      setState(() {
        downloadInfo = info;
      });
      print(downloadInfo);
    });

    FlutterDownloader.registerCallback(modal.downloadCallback);
  }

  @override
  Widget build(BuildContext context) {
    return downloadInfo["status"] == DownloadTaskStatus.running
        ? Container(
            width: double.infinity,
            //TODO: this takes full height of parent
            // height: 70,
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.download,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(modal.nameController.text),
                      Text(modal.fileSize,
                          style: TextStyle(
                              color: Theme.of(context).disabledColor)),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    LinearProgressIndicator(
                      backgroundColor: Theme.of(context).disabledColor,
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).indicatorColor),
                      minHeight: 20,
                      value: downloadInfo['progress'] / 100,
                    ),
                    Align(
                      child: Text('${downloadInfo['progress']}%'.toString()),
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ],
            ))
        : Container(
            child: Text("hi"),
          );
  }
}
