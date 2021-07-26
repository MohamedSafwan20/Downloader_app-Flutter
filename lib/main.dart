import 'package:flutter/material.dart';
import './styles/buttons.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber,
        accentColor: Colors.grey[850],
        disabledColor: Colors.grey[600],
        textTheme: Theme.of(context)
            .textTheme
            .apply(bodyColor: Colors.white, displayColor: Colors.white),
        primarySwatch: Colors.amber,
      ),
      home: Home(title: 'Downloader'),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                showDownloaderModal(context);
              },
              icon: Icon(
                Icons.add,
                color: Theme.of(context).accentColor,
                size: 30,
              ))
        ],
      ),
      backgroundColor: Theme.of(context).accentColor,
      body: const Text("hi"),
    );
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
                Text(
                  '800mb',
                  style: TextStyle(color: Theme.of(context).disabledColor),
                ),
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
                      TextField()
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
              onPressed: () {},
            ),
          ],
        );
      });
}
