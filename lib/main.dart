import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lashamezvrishvili_artteo/presentation/home/home_screen.dart';
import 'package:lashamezvrishvili_artteo/presentation/scan/scan_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemStatusBarContrastEnforced: false,
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Technical Test Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NavigationHolder(),
    );
  }
}

class NavigationHolder extends StatefulWidget {
  const NavigationHolder({super.key});

  @override
  State<NavigationHolder> createState() => _NavigationHolderState();
}

class _NavigationHolderState extends State<NavigationHolder> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                _selectedIndex == 0 ? 'Random Dog Photos' : 'Scan QR Code')),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search),
              label: 'Scan',
            ),
          ],
        ),
        body: PageTransitionSwitcher(
          transitionBuilder: (child, animation, secondaryAnimation) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: _selectedIndex == 0 ? const HomeScreen() : const ScanScreen(),
        ));
  }
}
