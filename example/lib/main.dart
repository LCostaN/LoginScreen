import 'package:flutter/material.dart';
import 'package:login_screen/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoginScreen Example',
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
            nextRoute: '\home',
            rememberOption: true,
            onRemember: (_) => print('remember'),
            duration: 1250,
            createAccount: false,
          ),
        );
      },
    );
  }
}
