// Unsounding dart null-safety
// @dart=2.9

import 'dart:isolate';
import 'dart:ui';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import '../services/modal.dart' as modal;
import 'package:http/http.dart' as http;

class DownloadingListItem extends StatefulWidget {
  static bool isDownloading = false;
  const DownloadingListItem({Key key}) : super(key: key);

  @override
  _DownloadingListItemState createState() => _DownloadingListItemState();
}

class _DownloadingListItemState extends State<DownloadingListItem> {
  Map<String, dynamic> downloadInfo = Map<String, dynamic>();

  ReceivePort receivePort = ReceivePort();

  bool isPaused = false;
  bool isPendingDownloadPaused = true;

  var pendingDownload;
  var pendingDownloadFileSize = "0";

  loadPausedTasks() async {
    final tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task WHERE status=6");
    return tasks;
  }

  getFileSize(String url) async {
    http.Response res = await http.head(Uri.parse(url));
    setState(() {
      pendingDownloadFileSize = filesize(res.headers['content-length']);
    });
  }

  @override
  void initState() {
    super.initState();

    pendingDownload = loadPausedTasks();

    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, "downloaderport");

    receivePort.listen((info) {
      setState(() {
        downloadInfo = info;
      });
      print("Main: $downloadInfo");
    });

    FlutterDownloader.registerCallback(modal.downloadCallback);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: pendingDownload,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              getFileSize(snapshot.data[0].url);

              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (isPendingDownloadPaused) {
                    FlutterDownloader.resume(
                        taskId: downloadInfo['id'] ?? snapshot.data[0].taskId);
                    setState(() {
                      isPendingDownloadPaused = false;
                    });
                  } else {
                    FlutterDownloader.pause(taskId: downloadInfo['id']);
                    setState(() {
                      isPendingDownloadPaused = true;
                    });
                  }
                },
                child: Container(
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
                              Text(snapshot.data[0].filename),
                              Text(pendingDownloadFileSize,
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
                              value: (downloadInfo['progress'] ??
                                      snapshot.data[0].progress) /
                                  100,
                            ),
                            Align(
                              child: Text(downloadInfo['progress'] != null
                                  ? '${downloadInfo['progress']}%'.toString()
                                  : "${snapshot.data[0].progress}%".toString()),
                              alignment: Alignment.center,
                            ),
                          ],
                        ),
                      ],
                    )),
              );
            }
            if (downloadInfo["status"] == DownloadTaskStatus.running ||
                downloadInfo['status'] == DownloadTaskStatus.paused) {
              String fileName = modal.nameController.text;
              String fileSize = modal.fileSize;

              DownloadingListItem.isDownloading = true;

              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (isPaused) {
                    FlutterDownloader.resume(taskId: downloadInfo['id']);
                    setState(() {
                      isPaused = false;
                    });
                  } else {
                    FlutterDownloader.pause(taskId: downloadInfo['id']);
                    setState(() {
                      isPaused = true;
                    });
                  }
                },
                child: Container(
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
                              Text(fileName),
                              Text(fileSize,
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
                              child: Text(
                                  '${downloadInfo['progress']}%'.toString()),
                              alignment: Alignment.center,
                            ),
                          ],
                        ),
                      ],
                    )),
              );
            } else {
              DownloadingListItem.isDownloading = false;
              return Container();
            }
          } else {
            // TODO: add snackbar
            return Text("Restart app");
          }
        });
  }
}
