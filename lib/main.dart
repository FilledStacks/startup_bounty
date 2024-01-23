import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:path_provider/path_provider.dart';

const bool DRIVE_MODE = bool.fromEnvironment('DRIVE_MODE');

Future<void> main() async {
  // TASK: Read this value from a local storage
  final useFlutterDriver = true;

  if (!useFlutterDriver) {
    // WidgetsFlutterBinding.ensureInitialized();
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

  void _incrementCounter() {
    // TASK: Change the value here and save
    setState(() {
      _counter++;
    });
  }

  Future<String> readValueAsync() async {
    final file = await _getFile();
    return file.readAsString();
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/demo_file.txt';
    final file = File(filePath);

    // Check if the file exists, create and write content if not
    if (!(await file.exists())) {
      await file.create();
      await file.writeAsString('Thank you Mom and Papa!!');
    }

    return file;
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
            Expanded(
              child: FutureBuilder<String>(
                future: readValueAsync(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    WidgetsFlutterBinding.ensureInitialized();

                    String value = snapshot.data!;
                    print('Read value before initialization: $value');

                    // Return your main widget here
                    return Text(value);
                  } else {
                    // Return a loading indicator or any placeholder while reading
                    return const CircularProgressIndicator();
                  }
                },
              ),
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
