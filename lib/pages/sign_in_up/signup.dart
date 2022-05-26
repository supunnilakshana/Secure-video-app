import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securevideo/constants_data/ui_constants.dart';
import 'package:securevideo/pages/sign_in_up/emailveryficationscreen.dart';
import 'package:securevideo/pages/sign_in_up/signin.dart';
import 'package:securevideo/service/auth/auth.dart';
import 'package:securevideo/service/auth/emailverification.dart';
import 'package:securevideo/service/auth/google/GoogleSignAuth.dart';
import 'package:securevideo/service/firebase_handeler/user_handeler.dart';
import 'package:securevideo/service/validater/validate_handeler.dart';
import 'package:securevideo/ui_components/already_have_an_account_acheck.dart';

import 'package:securevideo/ui_components/buttons.dart';
import 'package:securevideo/ui_components/or_divider.dart';
import 'package:securevideo/ui_components/social_icon.dart';

import 'package:securevideo/ui_components/textfileds.dart';
import 'package:securevideo/ui_components/tots.dart';

import 'authcheckingscreen.dart';
import 'background.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool status = false;

  String email = "";
  String password = "";
  var emailauth = EmailAuth();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();

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
                      "SignUp With Us",
                      style: TextStyle(
                          fontSize: size.width * 0.068,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.75)),
                    ),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.02),
                      child: Container(
                        width: size.width * 0.8,
                        child: Gtextformfiled(
                          hintText: "Email ",
                          label: "Email",
                          onchange: (text) {
                            email = text;
                          },
                          save: (text) {
                            email = text!;
                          },
                          controller: emailcontroller,
                          icon: Icons.mail,
                          valid: (text) {
                            return Validater.vaildemail(email);
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
                                  "Account already exist ",
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
                          bicon: Icon(Icons.app_registration),
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
                                    new Text("Verifying ...")
                                  ],
                                ),
                              ));
                              int r =
                                  await emailauth.emailsignUp(email, password);

                              if (r == 1) {
                                await UserdbHandeler.adduser(email);
                                // await UserdbHandeler.updateuserlist(
                                //     widget.email);
                                print("r name");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return AuthChecking();
                                    },
                                  ),
                                );
                              } else {
                                Customtost.commontost(
                                    "Email already exists", Colors.red);
                              }
                            }
                          },
                          color: kprimaryColor,
                          text: "Sign Up",
                        ),
                      ),
                    ),
                    AlreadyHaveAnAccountCheck(
                      login: false,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Signin();
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
                    SizedBox(
                      height: size.height * 0.08,
                    ),
                  ]),
            ))),
      ),
    );
  }
}
