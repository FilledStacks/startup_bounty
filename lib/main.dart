import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:path_provider/path_provider.dart';

const bool DRIVE_MODE = bool.fromEnvironment('DRIVE_MODE');

 Future<String> readDataFromFileBeforeInitialization() async {
    try {
      final file = await getFile();
      String fileContents = await file.readAsString();
      return fileContents;
    } catch (e) {
      print('Error reading from file before initialization: $e');
      return '';
    }
  }

  Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/counter_data.txt');
  }

  Future<void> writeDataToFile(String data) async {
    try {
      final file = await getFile();
      await file.writeAsString(data);
      print('Data written to file successfully.');
    } catch (e) {
      print('Error writing to file: $e');
    }
  }
Future<void> main() async {
  // TASK: Read this value from local storage
  final useFlutterDriver = true;

  // Read data from disk before initializing Flutter
  String storedData = await readDataFromFileBeforeInitialization();

  if (useFlutterDriver == false) {
    WidgetsFlutterBinding.ensureInitialized();
  } else {
    enableFlutterDriverExtension();
  }

  runApp(MyApp(storedData: storedData));
}

class MyApp extends StatelessWidget {
  final String storedData;

  const MyApp({Key? key, required this.storedData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        storedData: storedData,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String storedData;

  const MyHomePage({Key? key, required this.title, required this.storedData}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

 

  @override
  void initState() {
    super.initState();

    // Set the counter value based on the data read from disk
    if (widget.storedData.isNotEmpty) {
      setState(() {
        _counter = int.parse(widget.storedData);
      });
    }
  }

  void _incrementCounter() {
    // Increment the counter and write to file
    setState(() {
      _counter++;
    });

    // Convert the counter value to a string and write to file
    writeDataToFile(_counter.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
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
              style: Theme.of(context).textTheme.headline6,
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
