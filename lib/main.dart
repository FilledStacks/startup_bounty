import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:startup_bounty/settings.dart';

const bool DRIVE_MODE = bool.fromEnvironment('DRIVE_MODE');

final Box<SettingsData> hiveBx = Hive.box<SettingsData>('settings');
Future<void> main() async {
  //register adapter
  await Hive.initFlutter();
  Hive.registerAdapter(SettingsDataAdapter());
  Box<SettingsData?> settingsBox;
  try {
    settingsBox = await Hive.openBox<SettingsData>('settings');
    if (settingsBox.isEmpty) {
      await settingsBox.put(SettingsKeys.driverSettings,
          SettingsData(useFlutterDriver: DRIVE_MODE));
    }
  } finally {
    settingsBox = await Hive.openBox<SettingsData>('settings');
  }
  // TASK: Read this value from a local storage
  SettingsData? settings = settingsBox.get(SettingsKeys.driverSettings);
  if (settings == null) {
    settings = SettingsData(useFlutterDriver: DRIVE_MODE);
    await settingsBox.put(SettingsKeys.driverSettings, settings);
  }
  print('settings: $settings');
  final useFlutterDriver = settings.useFlutterDriver;

  if (!useFlutterDriver) {
    WidgetsFlutterBinding.ensureInitialized();
    settings.isInitialized = true;
    await settingsBox.put(SettingsKeys.driverSettings, settings);
  } else {
    //Note adjust handling of this flag to your needs
    if (settings.isInitialized) {
      enableFlutterDriverExtension();
    }
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
  String useFlutterDriverText =
      hiveBx.get(SettingsKeys.driverSettings)?.useFlutterDriver.toString() ??
          '';

  void _toggleFlag() {
    // TASK: Change the value here and save
    setState(() {
      final useFlutterDriver =
          hiveBx.get(SettingsKeys.driverSettings)?.useFlutterDriver;
      hiveBx.put(SettingsKeys.driverSettings,
          SettingsData(useFlutterDriver: !useFlutterDriver!));
      setFlutterDriverString();
    });
  }

  void setFlutterDriverString() {
    final value =
        hiveBx.get(SettingsKeys.driverSettings)?.useFlutterDriver.toString();
    setState(() {
      useFlutterDriverText = "useFlutterDriver: $value";
    });
  }

  @override
  void initState() {
    setFlutterDriverString();
    super.initState();
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
              useFlutterDriverText,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFlag,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
