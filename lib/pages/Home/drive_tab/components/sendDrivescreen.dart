import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:securevideo/models/drivemodel.dart';
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
import 'package:securevideo/ui_components/or_divider.dart';
import 'package:securevideo/ui_components/textfileds.dart';
import 'package:securevideo/ui_components/tots.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as p;

class SendDrivescreen extends StatefulWidget {
  @override
  _SendDrivescreen createState() => _SendDrivescreen();
}

class _SendDrivescreen extends State<SendDrivescreen> {
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailcon = TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;

  final user = FirebaseAuth.instance.currentUser;

  XFile? _video;
  File? getedfile;
  bool isvudeoload = false;
  late String _keytext;
  bool iserror = false;
  bool isencrpting = false;
  bool isencrpted = false;
  bool isuploading = false;
  bool isemailavilabel = true;
  String errorname = "This Email is not available  ";
  String _basevideostring = "";
  String fileextension = "";
  File? _enfile;

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
            Form(
              key: _formKey,
              child: Container(
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
                                OpenFile.open(getedfile!.path);
                              },
                              child: Container(
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
                                            "assets/animation/openfile.json"),
                                      ),
                                    ),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            fontSize: size.width * 0.05),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: 'File is loaded',
                                              style: TextStyle()),
                                          TextSpan(
                                              text: ' Double tap',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: size.width * 0.045,
                                                  fontWeight: FontWeight.w600)),
                                          TextSpan(
                                              text: ' to open',
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
                                          "assets/animation/addfile.json"),
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
                                            text: ' your file',
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
                                onTap: () async {
                                  isencrpted = false;
                                  isencrpting = true;
                                  setState(() {});
                                  Cryptovideo cryptovideo = Cryptovideo();

                                  EncryptedItem enitem =
                                      await cryptovideo.encryptFile(getedfile!);

                                  _enfile = enitem.video;
                                  _keytext = enitem.key;

                                  print("-----done------------");
                                  isencrpting = false;
                                  isencrpted = true;
                                  setState(() {});
                                  Customtost.commontost(
                                      "Encrypted", Colors.deepPurpleAccent);
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
                                  child: isencrpting
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
                                            isencrpted
                                                ? "Encrypted"
                                                : "Tap to Encrypt File",
                                            style: TextStyle(
                                                fontSize: size.width * 0.043,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blueGrey
                                                    .withOpacity(0.7)),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            isencrpted
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
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                              ),
                                            ],
                                          ),
                                          child: Gnoiconformfiled(
                                              hintText: "Enter File name",
                                              label: "Enter File name",
                                              onchange: (text) {},
                                              valid: (email) {
                                                return Validater.genaralvalid(
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
                                onTap: isencrpted
                                    ? () async {
                                        if (_formKey.currentState!.validate()) {
                                          isuploading = true;
                                          setState(() {});
                                          String id = Date.getDateTimeId();

                                          final extension =
                                              p.extension(_enfile!.path);
                                          print(extension);
                                          String vlink =
                                              await ImageUploader.uploadData(
                                                  _enfile!, id + extension);
                                          print(vlink);
                                          if (vlink != "false") {
                                            Drivemodel gmodel = Drivemodel(
                                                id: id,
                                                extesion: fileextension,
                                                fileName: _emailcon.text,
                                                fileUrl: vlink,
                                                date: Date.getDatetimenow());
                                            int res1 = await FireDBhandeler
                                                .addDrivedoc(gmodel);

                                            Keymodel keymodel = Keymodel(
                                                id: id,
                                                key: _keytext,
                                                addeddate:
                                                    Date.getDatetimenow(),
                                                type: extension);
                                            int res2 = await FireDBhandeler
                                                .adddriveKeydoc(keymodel);

                                            isuploading = false;
                                            setState(() {});
                                            print("res1--$res1 res2--$res2");
                                            if (res1 == 1 && res2 == 1) {
                                              // iserror = true;
                                              setState(() {});
                                              Customtost.commontost("Uploaded",
                                                  Colors.blueAccent);
                                            } else {
                                              Customtost.commontost(
                                                  "Uploading failed",
                                                  Colors.redAccent);
                                            }
                                          } else {
                                            Customtost.commontost(
                                                "Uploading failed",
                                                Colors.redAccent);
                                          }
                                          isuploading = false;
                                          setState(() {});
                                        } else {
                                          print("not complete");
                                        }
                                      }
                                    : () {
                                        Customtost.commontost(
                                            "Encrypt your file",
                                            Colors.amberAccent);
                                      },
                                child: isuploading
                                    ? Container(
                                        height: size.height * 0.18,
                                        child: Lottie.asset(
                                            "assets/animation/uploading.json"),
                                      )
                                    : Container(
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
                                              color:
                                                  Colors.grey.withOpacity(0.3),
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
                                                Icons.upload_rounded,
                                                color: Colors.white,
                                                size: size.width * 0.07,
                                              ),
                                              title: Text(
                                                " Upload encrypted file",
                                                style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.043,
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
                _chooeseFile();
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
                        'Choose a file',
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

  _chooeseFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        getedfile = file;

        final path = file.path;
        print(path);
        final extension = p.extension(path);
        fileextension = extension;
        print(extension);
        List<int> videoBytes = file.readAsBytesSync();
        isvudeoload = true;
        print("okkkkkkkkkkkk");

        String base64vide0 = Base64Encoder().convert(videoBytes);
        _basevideostring = base64vide0;

        // widget.onimgfileChanged(base64Image);
      });
    } else {
      // User canceled the picker
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
