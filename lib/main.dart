import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

import 'utils.dart';

const bool DRIVE_MODE = bool.fromEnvironment('DRIVE_MODE');

Future<void> main() async {
  return await readValue().then((useFlutterDriver) {
    if (!useFlutterDriver) {
      WidgetsFlutterBinding.ensureInitialized();
    } else {
      enableFlutterDriverExtension();
    }
    runApp(const MyApp());
  });
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
  bool useFlutterDriver = false;

  @override
  void initState() {
    super.initState();
    // Reading value from file and initializing varialble `useFlutterDriver`
    readValue().then((value) => useFlutterDriver = value);
  }

  void _incrementCounter() {
    // Toggling value between true and false
    useFlutterDriver = !useFlutterDriver;
    saveValue(useFlutterDriver).whenComplete(() {
      debugPrint(
        "Toggled `useFlutterDriver` value to: $useFlutterDriver",
      );
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Flutter Driver Challange"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$useFlutterDriver',
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
