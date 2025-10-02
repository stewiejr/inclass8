import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fading Animation App',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      home: MainScreen(onThemeModePressed: _toggleTheme),
    );
  }
}

class MainScreen extends StatelessWidget {
  final VoidCallback onThemeModePressed;
  const MainScreen({super.key, required this.onThemeModePressed});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Animations'),
        actions: [
          IconButton(
            icon: Icon(
                isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round),
            onPressed: onThemeModePressed,
          ),
        ],
      ),
      body: PageView(
        children: const [
          FirstAnimationPage(),
          SecondAnimationPage(),
        ],
      ),
    );
  }
}

class FirstAnimationPage extends StatefulWidget {
  const FirstAnimationPage({super.key});

  @override
  State<FirstAnimationPage> createState() => _FirstAnimationPageState();
}

class _FirstAnimationPageState extends State<FirstAnimationPage> {
  bool _isVisible = true;

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _toggleVisibility,
            child: AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: const Text(
                'Tap Me to Fade!',
                style: TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Text("Swipe for next screen -->", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class SecondAnimationPage extends StatefulWidget {
  const SecondAnimationPage({super.key});

  @override
  State<SecondAnimationPage> createState() => _SecondAnimationPageState();
}

class _SecondAnimationPageState extends State<SecondAnimationPage> {
  bool _isVisible = true;

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _toggleVisibility,
            child: AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 3000),
              curve: Curves.fastLinearToSlowEaseIn,
              child: const Text(
                'Slower Fade!',
                style: TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text("<-- Swipe back", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}