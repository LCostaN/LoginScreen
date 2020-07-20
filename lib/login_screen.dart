// Copyright (c) 2020.  Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library login_screen;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:login_screen/src/login/login_form.dart';
import 'package:login_screen/src/new_user/new_user_form.dart';

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
    @required this.nextRoute,
    this.loginLabelText,
    this.loginHintText,
    this.passwordLabelText,
    this.passwordHintText,
    this.asset,
    this.rememberOption = false,
    this.onRemember,
    this.rememberText,
    this.newUserOption = true,
    this.newUserWidget,
    this.passwordVisibilityToggable = true,
    this.loginKeyboard = TextInputType.emailAddress,
    this.passwordKeyboard = TextInputType.visiblePassword,
    this.newUserText,
    this.createUser,
  })  : assert(authenticator != null),
        assert(nextRoute != null && nextRoute.isNotEmpty),
        assert(!newUserOption || (newUserOption && newUserWidget != null)),
        assert(!rememberOption || (rememberOption && onRemember != null)),
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

  /// If true, login screen will allow also show User Creation form in desktop or show a link button
  /// under login form to change to User creation screen. Defaults to true.
  final bool newUserOption;

  /// Whether to add a `Remember me` checkbox. Defaults to false.
  /// This is only a visual checkbox and the funcion should be provided in
  /// [onRemember].
  final bool rememberOption;

  /// An Image to show above the login fields.
  final String asset;

  /// RaisedButton's child. Usually a [Text].
  final Widget buttonContent;

  /// Login Button Color. Defaults to blue.
  final Color buttonColor;

  /// Button's textColor. Defaults to white.
  final Color buttonTextColor;

  /// Login's field label text
  final String loginLabelText;

  /// Login's field hint text
  final String loginHintText;

  /// Password's field label text
  final String passwordLabelText;

  /// Password's field hint text
  final String passwordHintText;

  /// Text to show in remember checkbox. Defaults to 'Keep me logged in'
  final String rememberText;

  /// Text to be shown in Create New User button. This is only shown in
  /// mobile screen.
  final String newUserText;

// Fields' Options

  /// Keyboard type for login field.
  final TextInputType loginKeyboard;

  /// Keyboard type for password field.
  final TextInputType passwordKeyboard;

// Callbacks

  /// Function called when login button is pressed.
  final FutureOr<bool> Function(String, String) authenticator;

  /// Validator callback for login. Defaults to:
  ///   -  Must not be null or empty
  ///   -  Must be formatted like an email. (email@example.com)
  final String Function(String) loginValidator;

  /// Validator callback for password. Defaults to:
  ///   -  Length >= 6 And <= 20
  ///   -  Must contain at least 1 digit and 1 letter
  final String Function(String) passwordValidator;

  /// Remember me Callback. Must be informed if [rememberOption] is true.
  final FutureOr<void> Function(bool) onRemember;

  /// Callback to create user. Receives a [String] login parameter and
  /// [String] password parameter. If callback returns [true], it sign the
  /// new user in automatically and move to the [nextRoute].
  final FutureOr<bool> Function(String, String) createUser;

// -- Routing Options  ------------------------------------------------------------------

  /// Next Route's name to be inserted in [Navigator.pushNamed(context, routeName)].
  /// Must not be null
  final String nextRoute;

  /// Optional widget for newUserOption screen.
  /// If newUserOption is [true] and newUserWidget is nor informed, the basic
  /// template is used.
  final Widget newUserWidget;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double _opacity;

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
    var isMobile = MediaQuery.of(context).size.width <= 450;

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: Hero(
              tag: 'background',
              child: widget.background ?? Container(),
            ),
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
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LoginForm(
                          asset: widget.asset,
                          buttonColor: widget.buttonColor,
                          buttonContent: widget.buttonContent,
                          buttonTextColor: widget.buttonTextColor,
                          loginHintText: widget.loginHintText,
                          loginKeyboard: widget.loginKeyboard,
                          loginLabelText: widget.loginLabelText,
                          passwordHintText: widget.passwordHintText,
                          passwordKeyboard: widget.passwordKeyboard,
                          passwordLabelText: widget.passwordLabelText,
                          passwordVisibilityToggable:
                              widget.passwordVisibilityToggable,
                          rememberOption: widget.rememberOption,
                          rememberText: widget.rememberText,
                          tryLogin: tryLogin,
                          loginValidator: widget.loginValidator,
                          passwordValidator: widget.passwordValidator,
                        ),
                        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                        // Here goes other buttons
                        // Other Auth services, like Google,Facebook, Instagram, etc.
                        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                        widget.newUserOption && isMobile
                            ? widget.newUserWidget ??
                                FlatButton(
                                  onPressed: goToNewUser,
                                  child: Text(widget.newUserText ?? 'New User'),
                                )
                            : Container(),
                      ],
                    ),
                    isMobile ? VerticalDivider() : const SizedBox(width: 0),
                    isMobile
                        ? NewUserForm(
                            asset: widget.asset,
                            buttonColor: widget.buttonColor,
                            buttonContent: widget.buttonContent,
                            buttonTextColor: widget.buttonTextColor,
                            newUserHintText: widget.loginHintText,
                            newUserKeyboard: widget.loginKeyboard,
                            newUserLabelText: widget.loginLabelText,
                            passwordHintText: widget.passwordHintText,
                            passwordKeyboard: widget.passwordKeyboard,
                            passwordLabelText: widget.passwordLabelText,
                            passwordVisibilityToggable:
                                widget.passwordVisibilityToggable,
                            tryCreateUser: tryCreateUser,
                            loginValidator: widget.loginValidator,
                            passwordValidator: widget.passwordValidator,
                          )
                        : const SizedBox(width: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void goToNewUser() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewUserForm(
          asset: widget.asset,
          buttonColor: widget.buttonColor,
          buttonContent: widget.buttonContent,
          buttonTextColor: widget.buttonTextColor,
          newUserHintText: widget.loginHintText,
          newUserKeyboard: widget.loginKeyboard,
          newUserLabelText: widget.loginLabelText,
          passwordHintText: widget.passwordHintText,
          passwordKeyboard: widget.passwordKeyboard,
          passwordLabelText: widget.passwordLabelText,
          passwordVisibilityToggable: widget.passwordVisibilityToggable,
          tryCreateUser: tryCreateUser,
          loginValidator: widget.loginValidator,
          passwordValidator: widget.passwordValidator,
        ),
      ),
    );
  }

  Future<void> tryCreateUser(String login, String password) async {
    var result = false;
    result = await widget.createUser(login, password);

    if (result) {
      await tryLogin(login, password);
    }
  }

  Future<void> tryLogin(
    String login,
    String password, [
    bool remember = false,
  ]) async {
    var result = false;
    result = await widget.authenticator(login, password);

    if (result) {
      if (widget.rememberOption ?? false) {
        await widget.onRemember(remember);
      }

      Navigator.of(context).pushReplacementNamed(widget.nextRoute);
    }
  }
}
