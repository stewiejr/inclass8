import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// MyApp and MainScreen are the same as the previous step.
// Only FirstAnimationPage changes.

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
      debugShowCheckedModeBanner: false,
      home: MainScreen(onThemeModePressed: _toggleTheme),
    );
  }
}

class MainScreen extends StatefulWidget {
  final VoidCallback onThemeModePressed;
  const MainScreen({super.key, required this.onThemeModePressed});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Color _textColor = Colors.black;

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _textColor,
              onColorChanged: (Color color) {
                setState(() => _textColor = color);
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (isDarkMode && _textColor == Colors.black) {
      _textColor = Colors.white;
    } else if (!isDarkMode && _textColor == Colors.white) {
      _textColor = Colors.black;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Animations'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round),
            onPressed: widget.onThemeModePressed,
          ),
          IconButton(
            icon: const Icon(Icons.color_lens_outlined),
            onPressed: _showColorPicker,
          ),
        ],
      ),
      body: PageView(
        children: [
          FirstAnimationPage(textColor: _textColor),
          SecondAnimationPage(textColor: _textColor),
        ],
      ),
    );
  }
}

class FirstAnimationPage extends StatefulWidget {
  final Color textColor;
  const FirstAnimationPage({super.key, required this.textColor});

  @override
  State<FirstAnimationPage> createState() => _FirstAnimationPageState();
}

class _FirstAnimationPageState extends State<FirstAnimationPage>
    with SingleTickerProviderStateMixin { // Add mixin for AnimationController
  bool _isVisible = true;
  bool _showFrame = false;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: _toggleVisibility,
          child: AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            child: Text(
              'Tap Me to Fade!',
              style: TextStyle(fontSize: 28, color: widget.textColor),
            ),
          ),
        ),
        Column(
          children: [
            RotationTransition(
              turns: _controller,
              child: Container(
                decoration: BoxDecoration(
                  border: _showFrame
                      ? Border.all(color: Colors.blueAccent, width: 5)
                      : null,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    'https://picsum.photos/250?image=9',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Show Frame'),
                Switch(
                  value: _showFrame,
                  onChanged: (bool value) {
                    setState(() => _showFrame = value);
                  },
                ),
              ],
            ),
          ],
        ),
        const Text("Swipe for next screen -->", style: TextStyle(fontSize: 16)),
      ],
    );
  }
}

class SecondAnimationPage extends StatefulWidget {
  final Color textColor;
  const SecondAnimationPage({super.key, required this.textColor});
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
              child: Text(
                'Slower Fade!',
                style: TextStyle(fontSize: 28, color: widget.textColor),
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