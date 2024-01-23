import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
// add path provider
import 'package:path_provider/path_provider.dart';

const bool DRIVE_MODE = bool.fromEnvironment('DRIVE_MODE');

Future<void> main() async {
  // TASK: Read this value from a local storage
  final value = readValueSync('${getDocumentsDirPath()}/counter.txt');
  final useFlutterDriver = value == 'true' || DRIVE_MODE;

  print("The value is $value");

  if (!useFlutterDriver) {
    WidgetsFlutterBinding.ensureInitialized();
  } else {
    enableFlutterDriverExtension();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    checkDocumentsForFileIfItExistsSaveToTemp('counter.txt');
  }

  void _incrementCounter() {
    // TASK: Change the value here and save
    setState(() {
      _counter++;
    });
    bool state = _counter % 2 == 0;
    writeToTile('counter.txt', state.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

String getDocumentsDirPath() {
  return Directory.systemTemp.path;
}

String readValueSync(String filePath) {
  final file = File(filePath);
  return file.existsSync() ? file.readAsStringSync() : 'false';
}

void writeToTile(String fileName, String fileData) async {
  final file = File('${getDocumentsDirPath()}/$fileName');
  file.writeAsStringSync(fileData);

  // // Write to actual documents
  final appDocuments = await getApplicationDocumentsDirectory();
  final appDocumentsDir = appDocuments.path;
  final appFile = File('$appDocumentsDir/$fileName');
  appFile.writeAsStringSync(fileData);
}

void checkDocumentsForFileIfItExistsSaveToTemp(String fileString) async {
  final appDocuments = await getApplicationDocumentsDirectory();
  final appDocumentsDir = appDocuments.path;
  final appFile = File('$appDocumentsDir/$fileString');
  final tempFile = File('${getDocumentsDirPath()}/$fileString');
  if (appFile.existsSync() && !tempFile.existsSync()) {
    final file = File('${getDocumentsDirPath()}/$fileString');
    file.writeAsStringSync(appFile.readAsStringSync());
  }
}
