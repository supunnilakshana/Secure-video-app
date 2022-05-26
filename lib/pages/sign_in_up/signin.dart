import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securevideo/constants_data/ui_constants.dart';
import 'package:securevideo/pages/Home/homescreen.dart';
import 'package:securevideo/service/auth/auth.dart';
import 'package:securevideo/service/auth/google/GoogleSignAuth.dart';
import 'package:securevideo/service/validater/validate_handeler.dart';
import 'package:securevideo/ui_components/already_have_an_account_acheck.dart';
import 'package:securevideo/ui_components/buttons.dart';
import 'package:securevideo/ui_components/or_divider.dart';
import 'package:securevideo/ui_components/social_icon.dart';
import 'package:securevideo/ui_components/textfileds.dart';

import 'background.dart';
import 'signup.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool status = false;
  String email = "";
  String password = "";
  var emailauth = EmailAuth();
  String stringstatus = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController usernamecontroller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Background(
                child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Welcome to  cDrive",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: size.width * 0.068,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.75)),
                    ),
                    SizedBox(
                      height: size.height * 0.12,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.02),
                      child: Container(
                        width: size.width * 0.8,
                        child: Gtextformfiled(
                          keybordtype: TextInputType.text,
                          hintText: "Email",
                          label: "Email",
                          onchange: (text) {
                            email = text;
                          },
                          save: (text) {
                            email = text!;
                          },
                          controller: usernamecontroller,
                          icon: Icons.email_outlined,
                          valid: (text) {
                            return Validater.vaildemail(text!);
                          },
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.01),
                        child: Container(
                            width: size.width * 0.8,
                            child: Gpasswordformfiled(
                              onchange: (text) {
                                print(text);
                                password = text;
                              },
                              save: (text) {
                                password = text!;
                              },
                              icon: Icons.lock,
                            ))),
                    status
                        ? Padding(
                            padding: EdgeInsets.only(
                              bottom: size.height * 0.05,
                            ),
                            child: Wrap(
                              children: [
                                Text(
                                  "Invalid email number or password ",
                                  style: TextStyle(
                                      fontSize: size.width * 0.03,
                                      color: Colors.redAccent),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            height: size.height * 0,
                          ),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: size.height * 0.02, left: size.width * 0.079),
                      child: Container(
                        width: size.width * 0.65,
                        child: Iconbutton(
                          bicon: Icon(Icons.login),
                          onpress: () async {
                            if (_formKey.currentState!.validate()) {
                              _scaffoldKey.currentState!
                                  // ignore: deprecated_member_use
                                  .showSnackBar(new SnackBar(
                                duration: new Duration(seconds: 3),
                                backgroundColor: kprimaryColor,
                                content: new Row(
                                  children: <Widget>[
                                    new CircularProgressIndicator(),
                                    new Text("Authenticating ...")
                                  ],
                                ),
                              ));
                              print("valid");

                              print("press login");
                              print(email);
                              print(password);
                              int r =
                                  await emailauth.emailsignIN(email, password);

                              if (r == 1) {
                                print("loged");
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Homescreen();
                                    },
                                  ),
                                );
                              } else {
                                setState(() {
                                  status = true;
                                });
                              }
                            } else {
                              print("not complete");
                            }
                          },
                          color: kprimaryColor,
                          text: "Sign In",
                        ),
                      ),
                    ),
                    AlreadyHaveAnAccountCheck(
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Signup();
                            },
                          ),
                        );
                      },
                    ),
                    OrDivider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SocalIcon(
                          iconSrc: "assets/icons/google-symbol.svg",
                          press: () {
                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            provider.googleLogin();
                          },
                        ),
                      ],
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: size.height * 0),
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       // Navigator.push(
                    //       //   context,
                    //       //   MaterialPageRoute(
                    //       //     builder: (context) {
                    //       //       return Forgetpasswordscreen();
                    //       //     },
                    //       //   ),
                    //       // );
                    //     },
                    //     child: Text(
                    //       "Forgot password ?",
                    //       style: TextStyle(
                    //           //fontSize: size.width * 0.025,
                    //           fontWeight: FontWeight.bold,
                    //           color: status
                    //               ? kprimaryColor
                    //               : Colors.black.withOpacity(0.7)),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: size.height * 0.08,
                    ),
                  ]),
            ))),
      ),
    );
  }
}
