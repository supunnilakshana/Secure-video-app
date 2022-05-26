import 'package:flutter/material.dart';
import 'package:securevideo/constants_data/ui_constants.dart';
import 'package:securevideo/pages/sign_in_up/authcheckingscreen.dart';
import 'package:securevideo/service/auth/auth.dart';
import 'package:securevideo/service/auth/emailverification.dart';
import 'package:securevideo/service/firebase_handeler/user_handeler.dart';
import 'package:securevideo/service/validater/validate_handeler.dart';
import 'package:securevideo/ui_components/already_have_an_account_acheck.dart';
import 'package:securevideo/ui_components/buttons.dart';
import 'package:securevideo/ui_components/or_divider.dart';
import 'package:securevideo/ui_components/textfileds.dart';

import 'background.dart';
import 'dart:math';
import 'signup.dart';

class EmailVerifyScreen extends StatefulWidget {
  final String sendcode;
  final String email;
  final String password;

  const EmailVerifyScreen(
      {Key? key,
      required this.sendcode,
      required this.email,
      required this.password})
      : super(key: key);
  @override
  _EmailVerifyScreenState createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  bool failstatus = false;
  String vcode = "";
  String password = "";
  var emailauth = EmailAuth();
  String statusString = "Invalid Verification Code!!";
  late String verifycode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController usernamecontroller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    verifycode = widget.sendcode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kprimarylightcolor,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
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
                      "Please verify your video!!",
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
                          keybordtype: TextInputType.number,
                          hintText: "Verification Code",
                          label: "Verification Code",
                          onchange: (text) {
                            vcode = text;
                          },
                          save: (text) {
                            vcode = text!;
                          },
                          controller: usernamecontroller,
                          icon: Icons.code,
                          valid: (text) {
                            return Validater.genaralemptyvalid(text!);
                          },
                        ),
                      ),
                    ),
                    failstatus
                        ? Padding(
                            padding: EdgeInsets.only(
                              bottom: size.height * 0.05,
                            ),
                            child: Wrap(
                              children: [
                                Text(
                                  statusString,
                                  textAlign: TextAlign.center,
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
                          bicon: Icon(Icons.verified_user_outlined),
                          onpress: () async {
                            if (_formKey.currentState!.validate()) {
                              if (verifycode == vcode) {
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

                                int r = await emailauth.emailsignUp(
                                    widget.email, widget.password);

                                if (r == 1) {
                                  await UserdbHandeler.adduser(widget.email);
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
                                  setState(() {
                                    statusString =
                                        "The account already exists for that email";
                                    failstatus = true;
                                  });
                                  print("all used email");
                                }

                                print("valid");
                              } else {
                                setState(() {
                                  failstatus = true;
                                });
                              }
                            } else {
                              print("not complete");
                            }
                          },
                          color: kprimaryColor,
                          text: "Verify",
                        ),
                      ),
                    ),
                    OrDivider(),
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0),
                      child: GestureDetector(
                        onTap: () async {
                          Random random = Random();
                          String code = random.nextInt(9).toString() +
                              random.nextInt(9).toString() +
                              random.nextInt(9).toString() +
                              random.nextInt(9).toString() +
                              random.nextInt(9).toString();
                          print(code);
                          verifycode = code;
                          int res = await Emailverification.sendcode(
                              widget.email, code);
                          print(res);
                          setState(() {});
                          if (res == 1) {
                            print("send email");
                          } else {}
                        },
                        child: Text(
                          "Send Verification Code Again.",
                          style: TextStyle(
                              //fontSize: size.width * 0.025,
                              fontWeight: FontWeight.bold,
                              color: failstatus
                                  ? kprimaryColor
                                  : Colors.black.withOpacity(0.7)),
                        ),
                      ),
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
