import 'package:flutter/material.dart';

class DownloadedFileListItem extends StatefulWidget {
  const DownloadedFileListItem(
      {Key? key, required this.fileName, required this.fileSize})
      : super(key: key);

  final String fileName;
  final String fileSize;

  @override
  _DownloadedFileListItemState createState() => _DownloadedFileListItemState();
}

class _DownloadedFileListItemState extends State<DownloadedFileListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Text(widget.fileName),
                  Text(widget.fileSize,
                      style: TextStyle(color: Theme.of(context).disabledColor)),
                ],
              ),
            ),
            Stack(
              children: [
                LinearProgressIndicator(
                  backgroundColor: Theme.of(context).disabledColor,
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).indicatorColor),
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
        ));
  }
}
