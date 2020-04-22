import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task2/main.dart';
import 'package:flutter/gestures.dart';

void main() => runApp(MyApp());

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _key = new GlobalKey();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmPasswordController =
      new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _validate = false;
  //final

  // To adjust the layout according to the screen size
  // so that our layout remains responsive ,we need to
  // calculate the screen height
  double screenHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color.fromRGBO(86, 89, 122, 1),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            upperHalf(context),
            signUpCard(context),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (this.mounted) super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 2,
      child: Image(
        image: AssetImage("images/pluto.png"),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget signUpCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Opacity(
          opacity: .9,
          child: Container(
            margin: EdgeInsets.only(top: screenHeight / 3),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Form(
                      key: _key,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                                labelText: "Your Email",
                                hasFloatingPlaceholder: true),
                            validator: validateEmail,
                            onSaved: (str) => _emailController.text = str,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            validator: validatePassword,
                            decoration: InputDecoration(
                                labelText: "Password",
                                hasFloatingPlaceholder: true),
                            onSaved: (str) => _passwordController.text = str,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _confirmPasswordController,
                            validator: (confirmation) {
                              return confirmation.isEmpty
                                  ? 'Confirm password is required'
                                  : validationEqual(confirmation,
                                          _passwordController.text)
                                      ? null
                                      : 'Password not match';
                            },
                            decoration: InputDecoration(
                              labelText: " Confirm Password",
                              hasFloatingPlaceholder: true,
                            ),
                            onSaved: (str) =>
                                _confirmPasswordController.text = str,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Password must be at least 8 characters and include a special character and number",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 15),
                          ),
                          color: Color(0xFF4B9DFE),
                          textColor: Colors.white,
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: () {
                            _submit();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Already have an account?   ",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              TextSpan(
                text: 'Login',
                style: TextStyle(color: Colors.yellow, fontSize: 15),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage()));
                  },
              ),
            ],
          ),
        ),

      ],
    );
  }

  void _submit() {
    final FormState form = _key.currentState;
    if (_key.currentState.validate()) {
      _key.currentState.save();
      final snackBar = SnackBar(
          content: Text(
        'Signed Up Successfully',
      ));
      scaffoldKey.currentState.showSnackBar(snackBar);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Email is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Invalid email';
    } else {
      return null;
    }
  }

  String validatePassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    print(value);
    if (value.isEmpty) {
      return 'Please enter password';
    } else if (value.length < 8) {
      return 'Confirm password must be at least 8 characters';
    } else {
      if (!regex.hasMatch(value))
        return 'Enter valid password';
      else
        return null;
    }
  }

  bool validationEqual(String currentValue, String checkValue) {
    if (currentValue == checkValue) {
      return true;
    } else {
      return false;
    }
  }
}
