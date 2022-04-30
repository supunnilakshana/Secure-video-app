import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:securevideo/constants_data/init_constansdata.dart';
import 'package:securevideo/constants_data/ui_constants.dart';
import 'package:securevideo/models/keymodel.dart';
import 'package:securevideo/models/videomodel.dart';
import 'package:securevideo/pages/Home/homescreen.dart';
import 'package:securevideo/pages/Home/playvidescreen.dart';
import 'package:securevideo/service/encryption/video_encrypt.dart';
import 'package:securevideo/service/firebase_handeler/firedatabasehadeler.dart';
import 'package:securevideo/service/uploader/file_upload.dart';
import 'package:securevideo/service/validater/date.dart';
import 'package:securevideo/service/validater/validate_handeler.dart';
import 'package:securevideo/test/testscreen.dart';
import 'package:securevideo/ui_components/errorpage.dart';
import 'package:securevideo/ui_components/or_divider.dart';
import 'package:securevideo/ui_components/textfileds.dart';
import 'package:securevideo/ui_components/tots.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as p;

class ViewVideoScreen extends StatefulWidget {
  final Videomodel videomodel;
  final bool issent;

  const ViewVideoScreen(
      {Key? key, required this.videomodel, required this.issent})
      : super(key: key);
  @override
  _ViewVideoScreen createState() => _ViewVideoScreen();
}

class _ViewVideoScreen extends State<ViewVideoScreen> {
  final user = FirebaseAuth.instance.currentUser;

  bool isvudeoload = false;

  bool iserror = false;
  bool isdecrpting = false;
  bool isdecrpted = false;
  bool isuploading = false;
  String errorname = "This Email is not in secure video ";
  String _basevideostring = "";
  File? _enfile;
  File? _decryptfile;

  late Future<Keymodel> futureData;

  @override
  void initState() {
    super.initState();
    if (widget.issent) {
      futureData = FireDBhandeler.getsentkey(widget.videomodel.id);
    } else {
      futureData = FireDBhandeler.getrecivekey(widget.videomodel.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: futureData,
      builder: (context, snapshot) {
        print(snapshot.hasData);
        if (snapshot.hasData) {
          Keymodel data = snapshot.data as Keymodel;
          print(data);

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurpleAccent,
              elevation: 0,
            ),
            backgroundColor: Colors.white,
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  Container(
                    color: Colors.deepPurpleAccent,
                    width: size.width,
                    height: size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 8,
                          child: isdecrpted
                              ? GestureDetector(
                                  onDoubleTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PlayVideoScreen(
                                                  file: _decryptfile!,
                                                  name: "_video!.name",
                                                )));
                                  },
                                  child: Container(
                                    //   height: size.height * 0.6,
                                    decoration: BoxDecoration(
                                        color: Colors.deepPurpleAccent),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: size.height * 0.02),
                                          child: Container(
                                            height: size.height * 0.34,
                                            // child: Image.asset("assets/icons/butterfly1.png")
                                            child: Lottie.asset(
                                                "assets/animation/playbutton.json"),
                                          ),
                                        ),
                                        RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                fontSize: size.width * 0.05),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: 'Video is decrypted',
                                                  style: TextStyle()),
                                              TextSpan(
                                                  text: ' Double tap',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          size.width * 0.045,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              TextSpan(
                                                  text: 'to Play',
                                                  style: TextStyle())
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  //   height: size.height * 0.6,
                                  decoration: BoxDecoration(
                                      color: Colors.deepPurpleAccent),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * 0.02),
                                        child: Container(
                                          height: size.height * 0.34,
                                          // child: Image.asset("assets/icons/butterfly1.png")
                                          child: Lottie.asset(
                                              "assets/animation/lockedvideo.json"),
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              fontSize: size.width * 0.05),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Video is',
                                                style: TextStyle()),
                                            TextSpan(
                                                text: 'Ecrypted!',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        size.width * 0.045,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        Flexible(
                          flex: 6,
                          child: Container(
                            width: size.width,
                            //  height: size.height * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: size.height * 0.008,
                                      left: size.width * 0.075,
                                      right: size.width * 0.075),
                                  child: GestureDetector(
                                    onTap: () async {
                                      isdecrpted = false;
                                      isdecrpting = true;
                                      setState(() {});
                                      try {
                                        String downloadfilepath =
                                            await ImageUploader.downloadfile(
                                                widget.videomodel.videourl,
                                                Date.getDateTimeId() +
                                                    enextenion);
                                        Cryptovideo cryptovideo = Cryptovideo();

                                        File decryptfile =
                                            await cryptovideo.decryptFile(
                                                File(downloadfilepath),
                                                data.key);
                                        _decryptfile = decryptfile;
                                        setState(() {});

                                        print("-----done------------");
                                        isdecrpting = false;
                                        isdecrpted = true;
                                        setState(() {});
                                        Customtost.commontost("Decrypted",
                                            Colors.deepPurpleAccent);
                                      } on Exception catch (e) {
                                        print(e);
                                        Customtost.commontost(
                                            "Somthing went wrong",
                                            Colors.redAccent);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 1),
                                            blurRadius: 3,
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                        ],
                                      ),
                                      child: isdecrpting
                                          ? Container(
                                              height: size.height * 0.13,
                                              child: Lottie.asset(
                                                  "assets/animation/encrypting.json"),
                                            )
                                          : ListTile(
                                              leading: Icon(
                                                Icons.enhanced_encryption,
                                                size: size.width * 0.07,
                                                color: Colors.blueGrey
                                                    .withOpacity(0.8),
                                              ),
                                              title: Text(
                                                isdecrpted
                                                    ? "Decrypted"
                                                    : "Download & Decrypt Video",
                                                style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.043,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.blueGrey
                                                        .withOpacity(0.7)),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: size.height * 0.008,
                                        left: size.width * 0.075,
                                        right: size.width * 0.075),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 1),
                                            blurRadius: 3,
                                            color: Colors.grey.withOpacity(0.3),
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.mail,
                                          size: size.width * 0.07,
                                          color:
                                              Colors.blueGrey.withOpacity(0.8),
                                        ),
                                        title: Text(
                                          widget.videomodel.reciveremail,
                                          style: TextStyle(
                                              fontSize: size.width * 0.043,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blueGrey
                                                  .withOpacity(0.8)),
                                        ),
                                        subtitle: Text(
                                          "Date : " + widget.videomodel.date,
                                          style: TextStyle(
                                              fontSize: size.width * 0.023,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blueGrey
                                                  .withOpacity(0.7)),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Errorpage(size: size.width * 0.7);
        }
        // By default show a loading spinner.
        return Center(
            child: Lottie.asset("assets/animation/downloading.json",
                width: size.width * 0.6));
      },
    );
  }

  Future<String> _createFileFromString(
      String encodedStr, String extension) async {
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + extension);
    await file.writeAsBytes(bytes);
    return file.path;
  }
}
