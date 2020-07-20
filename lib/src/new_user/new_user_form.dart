import 'package:flutter/material.dart';

class NewUserForm extends StatefulWidget {
  const NewUserForm({
    Key key,
    @required this.asset,
    @required this.newUserKeyboard,
    @required this.newUserHintText,
    @required this.newUserLabelText,
    @required this.passwordKeyboard,
    @required this.passwordHintText,
    @required this.passwordLabelText,
    @required this.passwordVisibilityToggable,
    @required this.buttonColor,
    @required this.buttonTextColor,
    @required this.buttonContent,
    @required this.tryCreateUser,
    this.loginValidator,
    this.passwordValidator,
  }) : super(key: key);

  final String asset;
  final TextInputType newUserKeyboard;
  final String newUserHintText;
  final String newUserLabelText;
  final TextInputType passwordKeyboard;
  final String passwordHintText;
  final String passwordLabelText;
  final bool passwordVisibilityToggable;
  final Color buttonColor;
  final Color buttonTextColor;
  final Widget buttonContent;
  final Future<void> Function(String, String) tryCreateUser;
  final String Function(String) loginValidator;
  final String Function(String) passwordValidator;

  @override
  NewUserFormState createState() => NewUserFormState();
}

class NewUserFormState extends State<NewUserForm> {
  GlobalKey<FormState> _form = GlobalKey();
  bool remember;
  bool obscure;

  String newUser;
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
                keyboardType: widget.newUserKeyboard,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: widget.newUserHintText,
                  labelText: widget.newUserLabelText ?? 'newUser',
                ),
                validator: widget.loginValidator,
                onChanged: (value) => setState(() => newUser = value),
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
              const SizedBox(height: 12.0),
              TextFormField(
                keyboardType: widget.passwordKeyboard,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  hintText: widget.passwordHintText,
                  labelText: widget.passwordLabelText ?? 'Repeat password',
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
                validator: (value) {
                  if (value.compareTo(password) != 0) {
                    return 'Password is not the same.';
                  }
                  return null;
                },
              ),
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
                      : widget.buttonContent ?? Text("newUser"),
                  onPressed: () {
                    setState(() => loading = true);

                    if (_form.currentState.validate()) {
                      try {
                        widget.tryCreateUser(newUser, password);
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
