import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key key,
    @required this.asset,
    @required this.loginKeyboard,
    @required this.loginHintText,
    @required this.loginLabelText,
    @required this.passwordKeyboard,
    @required this.passwordHintText,
    @required this.passwordLabelText,
    @required this.passwordVisibilityToggable,
    @required this.rememberOption,
    @required this.rememberText,
    @required this.buttonColor,
    @required this.buttonTextColor,
    @required this.buttonContent,
    @required this.tryLogin,
    this.loginValidator,
    this.passwordValidator,
  }) : super(key: key);

  final String asset;
  final TextInputType loginKeyboard;
  final String loginHintText;
  final String loginLabelText;
  final TextInputType passwordKeyboard;
  final String passwordHintText;
  final String passwordLabelText;
  final bool passwordVisibilityToggable;
  final rememberOption;
  final String rememberText;
  final Color buttonColor;
  final Color buttonTextColor;
  final Widget buttonContent;
  final Future<void> Function(String, String, [bool]) tryLogin;
  final String Function(String) loginValidator;
  final String Function(String) passwordValidator;

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _form = GlobalKey();
  bool remember;
  bool obscure;

  String login;
  String password;

  String errorMessage = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    errorMessage = '';

    return Form(
      key: _form,
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
              TextFormField(
                keyboardType: widget.loginKeyboard,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: widget.loginHintText,
                  labelText: widget.loginLabelText ?? 'Login',
                ),
                validator: widget.loginValidator,
                onChanged: (value) => setState(() => login = value),
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                keyboardType: widget.passwordKeyboard,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  hintText: widget.passwordHintText,
                  labelText: widget.passwordLabelText ?? 'Password',
                  suffix: widget.passwordVisibilityToggable
                      ? IconButton(
                          icon: Icon(obscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => setState(() => obscure = !obscure),
                        )
                      : null,
                ),
                obscureText: widget.passwordVisibilityToggable ? obscure : true,
                onChanged: (value) => setState(() => password = value),
                validator: widget.passwordValidator,
              ),
              const SizedBox(height: 4.0),
              widget.rememberOption
                  ? ListTile(
                      leading: Icon(
                        remember
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: remember ? Colors.green : Colors.grey,
                      ),
                      title: Text(widget.rememberText ?? 'Keep me logged in'),
                      onTap: () => setState(() => remember = !remember),
                    )
                  : Container(),
              const SizedBox(height: 8.0),
              errorMessage?.isEmpty ?? false
                  ? Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    )
                  : Container(),
              const SizedBox(height: 12.0),
              Center(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  color: widget.buttonColor ?? Theme.of(context).primaryColor,
                  textColor: widget.buttonTextColor ??
                          Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  child: loading
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(),
                        )
                      : widget.buttonContent ?? Text("Login"),
                  onPressed: () {
                    setState(() => loading = true);

                    if (_form.currentState.validate()) {
                      try {
                        widget.tryLogin(login, password, remember);
                      } catch (e) {
                        setState(() => errorMessage = e.toString());
                      }
                    }

                    setState(() => false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
