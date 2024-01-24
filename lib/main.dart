import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

// Define a variable indicating whether the app is in drive mode
// ignore: non_constant_identifier_names, prefer_const_constructors
final bool DRIVE_MODE = bool.fromEnvironment('DRIVE_MODE');

// Main function for the Flutter application
void main() async {
  // Read the value from disk
  bool useFlutterDriver = await _readFromFile();

  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Enable Flutter Driver extension only when in drive mode and useFlutterDriver is true
  if (DRIVE_MODE && useFlutterDriver) {
    enableFlutterDriverExtension();
  }

  // Run the Flutter application
  runApp( MyApp(initialUseFlutterDriver: useFlutterDriver));
}

// Definition of the main application widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.initialUseFlutterDriver})
      : super(key: key);

  // Add the named parameter
  final bool initialUseFlutterDriver;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _readFromFile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool useFlutterDriver = snapshot.data ?? true;

          WidgetsFlutterBinding.ensureInitialized();

          // Enable Flutter Driver extension only when in drive mode
          if (DRIVE_MODE && useFlutterDriver) {
            enableFlutterDriverExtension();
          }

          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            // Add the named parameter
            home: MyHomePage(
              title: 'Flutter Demo Home Page',
              initialUseFlutterDriver: initialUseFlutterDriver,
            ),
          );
        } else {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
      },
    );
  }
}

// Definition of the main application stateful widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.initialUseFlutterDriver,
  }) : super(key: key);

  final String title;
  final bool initialUseFlutterDriver;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Definition of the state for the main application widget
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

// Function to read a boolean value from a file
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

// Function to write a value to a file
Future<void> _writeToFile(File file, int value) async {
  await file.writeAsString(value.toString());
}
