// Import necessary Dart and Flutter packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:path_provider/path_provider.dart';

// Define a constant indicating whether the app is in drive mode
// The value is obtained from the environment variables during compilation
// ignore: constant_identifier_names
const bool DRIVE_MODE = bool.fromEnvironment('DRIVE_MODE');

// Main function for the Flutter application
Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Get the documents directory where the file will be stored (Uncomment it to use)
  // final Directory directory = await getApplicationDocumentsDirectory();
  // final File file = File('${directory.path}/useFlutterDriver.txt');

  //This is the Test Path
  final File file = File(
      '/Users/nerddevs/Projects/practice/startup_bounty/lib/useFlutterDriver.txt');

  // Read the value from the file
  // ignore: unused_local_variable
  bool useFlutterDriver;
  try {
    // Attempt to read the value from the file
    useFlutterDriver = await _readFromFile(file);
  } catch (e) {
    // Handle any errors while reading from the file
    debugPrint('Error reading file: $e');
    // Set a default value if an error occurs
    useFlutterDriver = true;
  }

  // Enable Flutter Driver extension only when in drive mode
  if (DRIVE_MODE) {
    enableFlutterDriverExtension();
  }

  // Run the Flutter application
  runApp(const MyApp());
}

// Definition of the main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Return a MaterialApp widget representing the application
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

// Definition of the main application stateful widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Definition of the state for the main application widget
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // Function to increment the counter when the button is pressed
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Return a Scaffold widget representing the basic material design structure
    return Scaffold(
      // AppBar at the top of the screen
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      // Main content of the screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display a text widget with a static message
            const Text(
              'You have pushed the button this many times:',
            ),
            // Display the current counter value
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
      // Floating action button for incrementing the counter
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Save the value to file when the button is pressed (Uncomment it to use)
          //final Directory directory = await getApplicationDocumentsDirectory();
          //final File file = File('${directory.path}/useFlutterDriver.txt');

          //This is the Test Path
          final File file = File(
              '/Users/nerddevs/Projects/practice/startup_bounty/lib/useFlutterDriver.txt');
          await _writeToFile(file, !DRIVE_MODE);

          // Increment the counter
          _incrementCounter();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Function to read a boolean value from a file
Future<bool> _readFromFile(File file) async {
  // Check if the file exists
  if (await file.exists()) {
    // Read the content of the file as a string
    String content = await file.readAsString();
    // Return true if the content is 'true', otherwise false
    return content == 'true';
  } else {
    // Default value if the file doesn't exist
    return true;
  }
}

// Function to write a boolean value to a file
Future<void> _writeToFile(File file, bool value) async {
  // Write the boolean value as a string to the file
  await file.writeAsString(value.toString());
}
