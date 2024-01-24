import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:path_provider/path_provider.dart';

const bool DRIVE_MODE = bool.fromEnvironment('DRIVE_MODE');

Future<void> main() async {
  runApp(const MyApp()); // runApp initializes WidgetsFlutterBinding

  if (!DRIVE_MODE) {
    await initializeValues(); // Initialize values from disk
  } else {
    enableFlutterDriverExtension();
  }
}

Future<void> initializeValues() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/TextFile.txt';

    final file = File(filePath);

    if (await file.exists()) {
      log('File exists at: $filePath');

      final content = await file.readAsString();
      log('File content: $content');

      // Use the content as needed.
    } else {
      log('File does not exist at: $filePath');
    }
  } catch (e, stackTrace) {
    log('Error initializing values: $e');
    log('Stack trace: $stackTrace');
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key});

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

  void _incrementCounter() {
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