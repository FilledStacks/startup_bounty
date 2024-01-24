import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

// ignore: constant_identifier_names
const bool DRIVE_MODE = bool.fromEnvironment('DRIVE_MODE');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _readFromFile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool useFlutterDriver = snapshot.data ?? true;

          // Ensure Flutter binding is initialized
          WidgetsFlutterBinding.ensureInitialized();

          // Enable Flutter Driver extension only when in drive mode
          if (DRIVE_MODE) {
            enableFlutterDriverExtension();
          }

          // Run the Flutter application
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: MyHomePage(
              title: 'Flutter Demo Home Page',
              initialUseFlutterDriver: useFlutterDriver,
            ),
          );
        } else {
          // Return a loading indicator while reading from disk
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key? key, required this.title, required this.initialUseFlutterDriver})
      : super(key: key);

  final String title;
  final bool initialUseFlutterDriver;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

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
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Save the value to file when the button is pressed
          final File file = File(
              '/Users/nerddevs/Projects/practice/startup_bounty/lib/useFlutterDriver.txt');
          await _writeToFile(file, _counter);

          // Increment the counter
          setState(() {
            _counter++;
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<bool> _readFromFile() async {
  final File file = File(
      '/Users/nerddevs/Projects/practice/startup_bounty/lib/useFlutterDriver.txt');

  if (await file.exists()) {
    String content = await file.readAsString();
    return content == 'true';
  } else {
    return true;
  }
}

Future<void> _writeToFile(File file, int value) async {
  await file.writeAsString(value.toString());
}
