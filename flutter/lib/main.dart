import 'package:flutter/material.dart';
import 'package:surevote/language.dart';
import 'package:get/get.dart';
import 'package:surevote/reset_password.dart';
import 'package:surevote/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SureVote App',
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  SplashScreen(),
      // Optional: Route for reset screen (you can also handle this with GetX directly)
      getPages: [
        GetPage(
          name: '/reset_password',
          page: () => const DummyResetRouteHandler(),
        ),
      ],
    );
  }
}

/// Dummy widget to simulate opening from browser with token in query param
class DummyResetRouteHandler extends StatelessWidget {
  const DummyResetRouteHandler({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulated token (in real case, you'd extract from the actual deep link or route)
    final String token = '0ab92116d9ec83f565785a6e2f3043e8';

    return ResetPasswordScreen(token: token);
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
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulating navigation with a fixed token
                Get.to(() => ResetPasswordScreen(
                    token: '0ab92116d9ec83f565785a6e2f3043e8'));
              },
              child: const Text("Go to Reset Password"),
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
