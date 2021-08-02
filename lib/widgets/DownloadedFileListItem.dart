import 'dart:io';

import 'package:downloader/styles/buttons.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class DownloadedFileListItem extends StatefulWidget {
  const DownloadedFileListItem(
      {Key? key,
      required this.fileName,
      required this.fileSize,
      required this.file})
      : super(key: key);

  final File file;
  final String fileName;
  final String fileSize;

  @override
  _DownloadedFileListItemState createState() => _DownloadedFileListItemState();
}

class _DownloadedFileListItemState extends State<DownloadedFileListItem> {
  showDeleteModal(BuildContext context, File file) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17.0)),
            content: SingleChildScrollView(
              child: ListBody(children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Text(
                    "Downloader",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  child: Text(
                    "Permanently delete this download?",
                  ),
                ),
              ]),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Yes',
                  style: CustomButtonStyle.textButtonSecondary,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  file.deleteSync();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "File successfully deleted. please refresh the page",
                          style: TextStyle(
                              color: Theme.of(context).indicatorColor))));
                },
              ),
              TextButton(
                child: Text(
                  'No',
                  style: CustomButtonStyle.textButtonPrimary,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () {
        showDeleteModal(context, widget.file);
      },
      onTap: () {
        OpenFile.open(widget.file.path);
      },
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.download_done,
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(
                      widget.fileName.length >= 35
                          ? "${widget.fileName.substring(0, 32)}..."
                          : widget.fileName,
                    ),
                    Text(filesize(widget.fileSize),
                        style:
                            TextStyle(color: Theme.of(context).disabledColor)),
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
                    value: 1,
                  ),
                  Align(
                    child: Text('100%'.toString()),
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
