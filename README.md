# LOGIN_SCREEN

This package provides a simple Login Screen Template using parameters
to customize the screen quickly and to authenticate users.

## Usage 
To use this package, add login_screen as a dependency in your pubspec.yaml file.

### Example
```dart
import 'package:flutter/material.dart';
import 'package:login_screen/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '\home')
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(child: Text("Home")),
            ),
          );

        return MaterialPageRoute(
          builder: (context) => LoginScreen(
            backgroundColor: Colors.blue.shade600,
            authenticator: (login, pass) => true,
            nextRouteName: '\home',
            rememberOption: false,
            duration: 1250,
          ),
        );
      },
    );
  }
}
```

## Status
This package is still in it's initial stages and help from other devs would be much appreciated.