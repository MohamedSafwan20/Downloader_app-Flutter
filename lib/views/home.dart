import 'dart:io';

import 'package:downloader/widgets/downloadingFileListItem.dart';
import 'package:downloader/widgets/getFilesFromDownloads.dart';
import 'package:ext_storage/ext_storage.dart';
import "package:flutter/material.dart";
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:permission_handler/permission_handler.dart';

import "../services/modal.dart" as modal;

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
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
            DownloadingListItem(),
            GetFilesFromDownloads(),
            ElevatedButton(
                onPressed: () {
                  FlutterDownloader.cancel(taskId: modal.taskId);
                },
                child: Text("click"))
          ],
        ));
  }
}
