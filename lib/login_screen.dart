// Copyright (c) 2020.  Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library login_screen;

import 'dart:async';

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({
    Key key,
    this.backgroundColor,
    this.cardColor,
    this.background,
    @required this.authenticator,
    this.loginValidator,
    this.passwordValidator,
    this.duration,
    this.buttonContent,
    this.buttonColor,
    this.buttonTextColor,
    @required this.nextRouteName,
    this.loginLabelText,
    this.loginHintText,
    this.passwordLabelText,
    this.passwordHintText,
    this.authenticationErrorMessage = "authentication failed.",
    this.passwordErrorMessage = "password failed.",
    this.loginErrorMessage = "login failed.",
    this.asset,
    this.rememberOption = false,
    this.rememberCallback,
    this.createAccount = false,
    this.accountRouteName,
    this.passwordVisibilityToggable = true,
    this.loginKeyboard = TextInputType.emailAddress,
    this.passwordKeyboard = TextInputType.visiblePassword,
  })  : assert(background != null || backgroundColor != null),
        assert(background == null || backgroundColor == null),
        assert(authenticator != null),
        assert(nextRouteName != null && nextRouteName.isNotEmpty),
        assert(!createAccount ||
            (createAccount &&
                accountRouteName != null &&
                accountRouteName.isNotEmpty)),
        assert(!rememberOption || (rememberOption && rememberCallback != null)),
        super(key: key);

// UI Options

  /// Screen's background color. If this parameter is not null, [background] must be null.
  final Color backgroundColor;

  /// Card's color. If null, the theme's default will be used.
  final Color cardColor;

  /// Screen's background Widget. If this parameter is not null, [backgroundColor] must be null.
  final Widget background;

  /// Whether password has a `toggle visibility` button. Defaults to true.
  final bool passwordVisibilityToggable;

  /// Fade animation duration in milliseconds. Defaults to 450.
  final int duration;

  /// If true, creates a link under the login button for account creation. Defaults to false
  final bool createAccount;

  /// Whether to add a `Remember me` checkbox. Defaults to false.
  /// This is only a visual checkbox and the funcion should be provided in
  /// [rememberCallback].
  final bool rememberOption;

  /// An Image to show above the login fields.
  final String asset;

  /// RaisedButton's child. Usually a [Text].
  final Widget buttonContent;

  /// Login Button Color. Defaults to blue.
  final Color buttonColor;

  /// Button's textColor. Defaults to white.
  final Color buttonTextColor;

// Fields' Options

  /// Login's field label text
  final String loginLabelText;

  /// Login's field hint text
  final String loginHintText;

  /// Password's field label text
  final String passwordLabelText;

  /// Password's field hint text
  final String passwordHintText;

  /// Keyboard type for login field.
  final TextInputType loginKeyboard;

  /// Keyboard type for password field.
  final TextInputType passwordKeyboard;

  final String authenticationErrorMessage;
  final String passwordErrorMessage;
  final String loginErrorMessage;

// Callbacks

  /// Function called when login button is pressed.
  final FutureOr<bool> Function(String, String) authenticator;

  /// Validator callback for login. Defaults to:
  ///   -  Must not be null or empty
  ///   -  Must be formatted like an email. (email@example.com)
  final bool Function(String) loginValidator;

  /// Validator callback for password. Defaults to:
  ///   -  Length >= 6 And <= 20
  ///   -  Must contain at least 1 digit and 1 letter
  final bool Function(String) passwordValidator;

  /// Remember me Callback. Must be informed if [rememberOption] is true.
  final void Function(bool) rememberCallback;

// -- Routing Options  ------------------------------------------------------------------

  /// Next Route's name to be inserted in [Navigator.pushNamed(context, routeName)].
  /// Must not be null
  final String nextRouteName;

  /// Route Name to use in [Navigator.pushNamed(context, routeName)].
  /// Must be informed if [createAccount] is true.
  final String accountRouteName;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double _opacity;
  bool visible = false;

  String login;
  String password;

  bool remember;

  bool showAuthenticationErrorMessage = false;
  bool showPasswordErrorMessage = false;
  bool showLoginErrorMessage = false;

  @override
  void initState() {
    super.initState();
    _opacity = 0.0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _opacity = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    showAuthenticationErrorMessage = false;
    showPasswordErrorMessage = false;
    showLoginErrorMessage = false;

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: widget.background ?? Container(),
          ),
          Center(
            child: AnimatedOpacity(
              duration: widget.duration != null
                  ? Duration(milliseconds: widget.duration)
                  : Duration.zero,
              opacity: _opacity,
              curve: Curves.easeIn,
              child: Card(
                elevation: widget.background != null ? 4.0 : 16.0,
                margin: const EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                color: widget.cardColor,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  constraints: BoxConstraints(maxWidth: 550),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        widget.asset != null
                            ? ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 216),
                                child: FittedBox(
                                  child: Image.asset(widget.asset),
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 20),
                        TextField(
                          keyboardType: widget.loginKeyboard,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            hintText: widget.loginHintText,
                            labelText: widget.loginLabelText ?? 'Login',
                            errorText: showLoginErrorMessage
                                ? widget.loginErrorMessage ?? ""
                                : null,
                          ),
                          onChanged: (value) => setState(() => login = value),
                        ),
                        const SizedBox(height: 12.0),
                        TextField(
                          keyboardType: widget.passwordKeyboard,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline),
                            hintText: widget.passwordHintText,
                            labelText: widget.passwordLabelText ?? 'Password',
                            errorText: showPasswordErrorMessage
                                ? widget.passwordErrorMessage ?? ""
                                : null,
                          ),
                          onChanged: (value) =>
                              setState(() => password = value),
                        ),
                        const SizedBox(height: 4.0),
                        widget.rememberOption
                            ? Checkbox(
                                value: remember,
                                onChanged: (value) =>
                                    setState(() => remember = value),
                              )
                            : Container(),
                        const SizedBox(height: 8.0),
                        showAuthenticationErrorMessage
                            ? Text(
                                widget.passwordErrorMessage ?? "",
                                style: TextStyle(color: Colors.red),
                              )
                            : Container(),
                        const SizedBox(height: 12.0),
                        Center(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            color: widget.buttonColor ?? Colors.blue,
                            textColor: widget.buttonTextColor ?? Colors.white,
                            child: widget.buttonContent ?? Text("Login"),
                            onPressed: tryLogin,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void tryLogin() async {
    var result = false;

    if (widget.loginValidator(login)) {
      if (widget.passwordValidator(password)) {
        result = await widget.authenticator(login, password);

        if (result)
          Navigator.of(context).pushReplacementNamed(widget.nextRouteName);
        else
          setState(() => showAuthenticationErrorMessage = true);
      } else {
        setState(() => showPasswordErrorMessage = true);
      }
      setState(() => showLoginErrorMessage = true);
    }
  }
}
