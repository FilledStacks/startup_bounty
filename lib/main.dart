import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

const bool DRIVE_MODE = bool.fromEnvironment('DRIVE_MODE');
const useFlutterDriver = true;

Future<void> main() async {
  // TASK: Read this value from a local storage
  if (!useFlutterDriver) {
    WidgetsFlutterBinding.ensureInitialized();
  } else {
    enableFlutterDriverExtension();
  }

  // Read the value from local storage
  final filePath = await getFilePath();
  print('File path: $filePath');

  final savedValue = await readValueFromFile(filePath);
  print('Saved value: $savedValue');
  runApp(MyApp(savedValue));
}

class MyApp extends StatelessWidget {
  final String savedValue;

  const MyApp(this.savedValue, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', savedValue: savedValue),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.savedValue});

  final String title;
  final String savedValue;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the counter with the saved value
    _counter = int.tryParse(widget.savedValue) ?? 0;
  }

  Future<void> _incrementCounter() async {
    // Incrementing the counter and saving the new value
    setState(() {
      _counter++;
    });
    writeValueToFile(await getFilePath(), '$_counter');
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

Future<String> getFilePath() async {
  String documentsDirectory = (await getApplicationDocumentsDirectory()).path;
  return '$documentsDirectory/data.txt';
}

Future<String> readValueFromFile(String filePath) async {
  try {
    File file = File(filePath);
    if (await file.exists()) {
      String contents = await file.readAsString();
      return contents;
    } else {
      print('File does not exist.');
      return '0';
    }
  } catch (e) {
    print('Error reading file: $e');
    return '0';
  }
}

Future<void> writeValueToFile(String filePath, String value) async {
  try {
    File file = File(filePath);
    await file.writeAsString(value);
  } catch (e) {
    print('Error writing to file: $e');
  }
}
