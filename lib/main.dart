import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

import 'config/config.dart';

const bool DRIVE_MODE = bool.fromEnvironment('DRIVE_MODE');

const applicationPackageName = 'com.example.startup_bounty';

late final AppConfig configFile;

const useFlutterDriverKey = 'use_flutter_driver';

Future<void> main() async {
  configFile = await AppConfig.getAppConfig(applicationPackageName);

  // TASK: Read this value from a local storage
  final useFlutterDriver =
      configFile.getValue<bool>(useFlutterDriverKey) == true;

  if (!useFlutterDriver) {
    WidgetsFlutterBinding.ensureInitialized();
  } else {
    enableFlutterDriverExtension();
  }

  // press the + increment button in UI to update this value to true.
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

  void _incrementCounter() async {
    // TASK: Change the value here and save
    // update value in the same config file
    await configFile.setValue('use_flutter_driver', true);
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
            ListTile(
              title: Text(
                (configFile.getValue<bool>(useFlutterDriverKey) == true)
                    .toString(),
              ),
              subtitle: const Text('use_flutter_driver'),
            ),
            ListTile(
              title: Text(
                configFile.toString(),
              ),
              subtitle: const Text('config_file_location'),
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
