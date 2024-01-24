import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

const bool DRIVE_MODE = bool.fromEnvironment('DRIVE_MODE');

Future<void> main() async {
  // runApp(Container()) runs an empty Flutter app, which initializes the bindings
  // please note that this is a workaround and not a recommended practice. The recommended way to initialize the bindings is by calling WidgetsFlutterBinding.ensureInitialized()
  runApp(const SizedBox());

  final prefs = await SharedPreferences.getInstance();
  final getUsername = prefs.getString('username') ?? '';
  if(getUsername.isEmpty) {
    prefs.setString('username', 'sarfaraj');
  }
  print("Username = $getUsername");
  final useFlutterDriver = true;
  if (!useFlutterDriver) {
    WidgetsFlutterBinding.ensureInitialized();
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
