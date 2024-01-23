import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:file_picker/file_picker.dart';

// const bool DRIVE_MODE = bool.fromEnvironment('DRIVE_MODE');

bool? useFlutterDriver;
String filePath =
    '/Users/MYSoft/Library/Developer/CoreSimulator/Devices/B8815C0E-FA0A-479D-9C69-5F501C3FBDA8/data/Containers/Data/Application/D071A42D-E86F-49FE-B4AA-BCD65D99BFD3/tmp/DWSample1-TXT.txt'; // Provide the actual file path

Future<String?> pickFilePath() async {
  final result = await FilePicker.platform.pickFiles();
  if (result != null) {
    return result.files.single.path;
  } else {
    return null;
  }
}

Future<bool?> initializeValueFromDisk() async {
  File file = File(filePath);
  debugPrint("object");

  try {
    if (await file.exists()) {
      String content = await file.readAsString();
      debugPrint('Read value from disk: $content');
      return true; // Or process the content as needed
    } else {
      debugPrint('File does not exist');
      return null;
    }
  } catch (error) {
    debugPrint('Error reading file: $error');
    return null;
  }
}

Future<void> main() async {
  ReceivePort receivePort = ReceivePort();
  await Isolate.spawn(_readValueFromDisk, receivePort.sendPort);
  useFlutterDriver = await receivePort.first;

  if ((useFlutterDriver ?? false)) {
    debugPrint("object-ensure");
    WidgetsFlutterBinding.ensureInitialized();
  } else {
    enableFlutterDriverExtension();
  }

  runApp(const MyApp());
}

void _readValueFromDisk(SendPort sendPort) async {
  useFlutterDriver = await initializeValueFromDisk();
  sendPort.send(useFlutterDriver);
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

  void _incrementCounter() async {
    final pak = await pickFilePath();
    debugPrint(pak);
    // TASK: Change the value here and save
    setState(() {
      _counter++;
    });
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
