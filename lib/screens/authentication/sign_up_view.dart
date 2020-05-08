import 'package:mathy/screens/widgets/auth_container.dart';
import 'package:mathy/screens/widgets/gradient_btn.dart';
import 'package:mathy/services/authentication/auth_provider.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  final ScrollController _c;
  final Function _loadAd;
  final GlobalKey<ScaffoldState> _scaffoldKey;
  SignUpView(this._c, this._scaffoldKey, this._loadAd);
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final Color _textColor = Color(0xff413D7A);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _showProgressBar = false;

  _signUpUser() async {
    widget._loadAd();
    if (_nameController.text != "" &&
        _emailController.text != "" &&
        _passController.text != "" &&
        !_showProgressBar) {
      FocusScope.of(context).unfocus();
      setState(() {
        _showProgressBar = true;
      });
      final _result = await AuthProvider().signUpUser(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passController.text.trim());
      if (_result.contains("myError")) {
        setState(() {
          _showProgressBar = false;
        });
        widget._scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Unexpected error occured ! Please try again.")));
      } else {
        widget._loadAd();
      }
    }
  }

  _googleSignIn() async {
    setState(() {
      _showProgressBar = true;
    });
    final _result = await AuthProvider().signInWithGoogle();
    if (_result.contains("myError")) {
      setState(() {
        _showProgressBar = false;
      });
      widget._scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Unexpected error occured ! Please try again.")));
    } else {
      widget._loadAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Sign up",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 26.0,
                            color: _textColor)),
                    SizedBox(
                      width: 10.0,
                    ),
                    _showProgressBar
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(_textColor),
                          )
                        : Container(),
                  ],
                ),
                MyGradientBtn(
                  colors: [Color(0xff413D7A), Colors.purple],
                  icon: Icons.arrow_forward_ios,
                  function: () {
                    _signUpUser();
                  },
                ),
              ],
            ),
          ),
          AuthContainer(
            nameController: _nameController,
            emailController: _emailController,
            passController: _passController,
            googleSignIn: () {
              _nameController.clear();
              _emailController.clear();
              _passController.clear();
              _googleSignIn();
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          GestureDetector(
            onTap: () {
              if (!_showProgressBar) {
                widget._c.animateTo(-1,
                    duration: Duration(milliseconds: 800), curve: Curves.ease);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    "Already have an account? Login here",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.0,
                        color: _textColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
