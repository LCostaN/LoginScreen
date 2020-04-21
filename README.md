# LOGIN_SCREEN

This package provides a simple Login Screen Template using parameters
to customize the screen quickly and to authenticate users.

[![Donate with Paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=B8ST4MMXWBQJ8&currency_code=BRL&source=url)

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
This package is in it's initial stages and PR requests are accepted if you like it.
