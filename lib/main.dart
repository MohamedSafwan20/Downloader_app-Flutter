// ignore: import_of_legacy_library_into_null_safe
import 'package:downloader/widgets/getFilesFromDownloads.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import './views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      // TODO: set debug to false
      debug: true);

  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(title: 'Downloader'),
        '/finished': (context) => const GetFilesFromDownloads()
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber,
        accentColor: Colors.grey[850],
        disabledColor: Colors.grey[700],
        indicatorColor: Colors.green[700],
        errorColor: Colors.red[600],
        canvasColor: Colors.grey[850],
        textTheme: Theme.of(context)
            .textTheme
            .apply(bodyColor: Colors.white, displayColor: Colors.white),
        primarySwatch: Colors.amber,
      ),
    );
  }
}
