// Import Dart standard libraries and Flutter packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

// Define a constant indicating whether the app is in drive mode
// The value is obtained from the environment variables during compilation
// ignore: constant_identifier_names
const bool DRIVE_MODE = bool.fromEnvironment('DRIVE_MODE');

// Main function for the Flutter application
void main() {
  // Run the Flutter application
  runApp(const MyApp());
}

// Definition of the main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use FutureBuilder to asynchronously read a boolean value from disk
    return FutureBuilder<bool>(
      future: _readFromFile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Extract the boolean value from the snapshot or default to true
          bool useFlutterDriver = snapshot.data ?? true;

          // Ensure Flutter binding is initialized
          WidgetsFlutterBinding.ensureInitialized();

          // Enable Flutter Driver extension only when in drive mode
          if (DRIVE_MODE) {
            enableFlutterDriverExtension();
          }

          // Return MaterialApp widget representing the application
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
  // Create a File object with the specified path
  final File file = File(
      '/Users/nerddevs/Projects/practice/startup_bounty/lib/useFlutterDriver.txt');

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

// Function to write a value to a file
Future<void> _writeToFile(File file, int value) async {
  // Write the value as a string to the file
  await file.writeAsString(value.toString());
}
