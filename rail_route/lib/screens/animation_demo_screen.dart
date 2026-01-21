import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class AnimationDemoScreen extends StatefulWidget {
  @override
  State<AnimationDemoScreen> createState() => _AnimationDemoScreenState();
}

class _AnimationDemoScreenState extends State<AnimationDemoScreen> {
  bool toggled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animations Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              width: toggled ? 200 : 120,
              height: toggled ? 120 : 200,
              color: toggled ? Colors.teal : Colors.orange,
              alignment: Alignment.center,
              child: Text(
                'Tap Button',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(height: 30),
            AnimatedOpacity(
              opacity: toggled ? 1.0 : 0.3,
              duration: Duration(milliseconds: 600),
              child: Icon(Icons.favorite, color: Colors.red, size: 48),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  toggled = !toggled;
                });
              },
              child: Text('Animate'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  _buildPageRoute(),
                );
              },
              child: Text('Go to Rotate Animation'),
            ),
          ],
        ),
      ),
    );
  }

  PageRouteBuilder _buildPageRoute() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (context, animation, secondaryAnimation) =>
          RotateAnimationScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
    );
  }
}

class RotateAnimationScreen extends StatefulWidget {
  @override
  State<RotateAnimationScreen> createState() => _RotateAnimationScreenState();
}

class _RotateAnimationScreenState extends State<RotateAnimationScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explicit Animation'),
      ),
      body: Center(
        child: RotationTransition(
          turns: controller,
          child: Icon(
            Icons.flutter_dash,
            size: 120,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}