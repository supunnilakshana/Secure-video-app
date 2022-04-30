import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:securevideo/pages/Home/playvidescreen.dart';
import 'package:securevideo/service/encryption/video_encrypt.dart';
import 'package:securevideo/service/validater/validate_handeler.dart';
import 'package:securevideo/test/testscreen.dart';
import 'package:securevideo/ui_components/or_divider.dart';
import 'package:securevideo/ui_components/textfileds.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as p;

class Homescreen extends StatefulWidget {
  @override
  _Homescreen createState() => _Homescreen();
}

class _Homescreen extends State<Homescreen> {
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailcon = TextEditingController();

  XFile? _video;
  bool isvudeoload = false;
  bool iserror = false;
  String errorname = "This Email is not in secure video ";
  String _basevideostring = "";
  File? _playfile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    child: isvudeoload
                        ? GestureDetector(
                            onDoubleTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlayVideoScreen(
                                            file: _playfile!,
                                            name: _video!.name,
                                          )));
                            },
                            child: Container(
                              //   height: size.height * 0.6,
                              decoration:
                                  BoxDecoration(color: Colors.deepPurpleAccent),
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
                                          "assets/animation/playbutton.json"),
                                    ),
                                  ),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: size.width * 0.05),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Video is loaded',
                                            style: TextStyle()),
                                        TextSpan(
                                            text: ' Double tap',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: size.width * 0.045,
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text: 'to Play', style: TextStyle())
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
                            decoration:
                                BoxDecoration(color: Colors.deepPurpleAccent),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: size.height * 0.02),
                                  child: Container(
                                    height: size.height * 0.34,
                                    // child: Image.asset("assets/icons/butterfly1.png")
                                    child: Lottie.asset(
                                        "assets/animation/videoanimation.json"),
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: size.width * 0.05),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'You need to',
                                          style: TextStyle()),
                                      TextSpan(
                                          text: ' Upload',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: size.width * 0.045,
                                              fontWeight: FontWeight.w600)),
                                      TextSpan(
                                          text: ' your video',
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
                  ),
                  _buildMidContainerWithButton(size.height * 0.065),
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
                              onTap: () {
                                _videoFromGallery();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
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
                                    Icons.enhanced_encryption,
                                    size: size.width * 0.07,
                                    color: Colors.blueGrey.withOpacity(0.8),
                                  ),
                                  title: Text(
                                    "Tap to Encrypt Video",
                                    style: TextStyle(
                                        fontSize: size.width * 0.043,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Colors.blueGrey.withOpacity(0.7)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          isvudeoload
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      top: size.height * 0.04,
                                      left: size.width * 0.075,
                                      right: size.width * 0.075),
                                  child: GestureDetector(
                                    onTap: () {
                                      _videoFromGallery();
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
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                            ),
                                          ],
                                        ),
                                        child: Gnoiconformfiled(
                                            onchange: (text) {},
                                            valid: (email) {
                                              return Validater.vaildemail(
                                                  email!);
                                            },
                                            save: (text) {},
                                            controller: _emailcon)),
                                  ),
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          iserror
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    errorname,
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          Expanded(
                              child: Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: () async {
                                Cryptovideo cryptovideo = Cryptovideo();
                                // EncryptedItem enfile =
                                //     cryptovideo.ecryptText(_basevideostring);
                                // String enfilepath = await _createFileFromString(
                                //     enfile.video, ".mp4");
                                // File imageFile = new File(enfilepath);

                                // List<int> videoBytes =
                                //     imageFile.readAsBytesSync();
                                // String newenstring =
                                //     Base64Encoder().convert(videoBytes);
                                // String decryptfile = cryptovideo.decryptText(
                                //     enfile.video, enfile.key);
                                // String dcfilepath = await _createFileFromString(
                                //     enfile.video, ".mp4");
                                // print(dcfilepath);
                                // if (enfile.video == decryptfile) {
                                //   print("eqaul");
                                // } else {
                                //   print("not eqal");
                                // }
                                // _playfile = File(dcfilepath);
                                // print("-----done------------");
                                EncryptedItem enitem = await cryptovideo
                                    .encryptFile(File(_video!.path));
                                _playfile = await cryptovideo.decryptFile(
                                    enitem.video, enitem.key);
                                print("-----done------------");
                              },
                              child: Container(
                                height: size.height * 0.081,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[800],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(35),
                                      topRight: Radius.circular(35)),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 3,
                                      color: Colors.grey.withOpacity(0.3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: size.width * 0.1,
                                      right: size.width * 0.1),
                                  child: Center(
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.send_rounded,
                                        color: Colors.white,
                                        size: size.width * 0.07,
                                      ),
                                      title: Text(
                                        " Send encrypted video",
                                        style: TextStyle(
                                            fontSize: size.width * 0.043,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))
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
  }

  Widget _buildMidContainerWithButton(double height) {
    final buttonHeight = height;
    return Stack(
      children: [
        // Use same background color like the second container
        Container(
          height: buttonHeight,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50))),
        ),
        // Translate the button
        Transform.translate(
          offset: Offset(0.0, -buttonHeight / 2.0),
          child: Center(
            child: GestureDetector(
              onTap: () {
                _videoFromGallery();
              },
              child: Container(
                height: buttonHeight,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[700],
                  borderRadius: BorderRadius.circular(buttonHeight / 2.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 16.0,
                      offset: Offset(0.0, 6.0),
                      color: Colors.black.withOpacity(0.16),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(24.0, 3.0, 24.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.video_library,
                      size: 20.0,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Choose a Video',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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

  _videoFromGallery() async {
    XFile? video = await _picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        _video = video;
        File imageFile = new File(_video!.path);
        final path = _video!.path;
        print(path);
        final extension = p.extension(path);
        print(extension);
        List<int> videoBytes = imageFile.readAsBytesSync();
        isvudeoload = true;
        print("okkkkkkkkkkkk");
        String base64vide0 = Base64Encoder().convert(videoBytes);
        _basevideostring = base64vide0;

        // widget.onimgfileChanged(base64Image);
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _videoFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      // _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
