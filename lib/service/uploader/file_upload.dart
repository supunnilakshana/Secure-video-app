import 'dart:convert' show utf8;
import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:mime_type/mime_type.dart';
import 'package:path_provider/path_provider.dart';

class ImageUploader {
  static firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  static final firestoreInstance = FirebaseFirestore.instance;

  static final user = FirebaseAuth.instance.currentUser;

  static Future<String> uploadData(File data, String videoname) async {
    String collection = "/users/" + user!.email.toString() + "/files/";
    String downloadedData = "false";
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref(collection + '/' + videoname);

    try {
      await ref.putFile(data);
      print("uploaded");

      downloadedData = await ref.getDownloadURL();

      print(downloadedData);
    } on Exception catch (e) {
      print(e.toString());
    }
    return downloadedData;
  }

  static Future<String> downloadfile(String url, String filename) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';

    try {
      myUrl = url;
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$filename';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else
        filePath = 'Error code: ' + response.statusCode.toString();
    } catch (ex) {
      filePath = 'Can not fetch url';
    }
    print(filePath);
    return filePath;
  }

  static Future<int> deletefile(String collection, String name) async {
    int a = 0;
    try {
      await storage.ref(collection + '/' + name).delete();
    } on Exception catch (e) {
      print(e.toString());
    }
    a = 1;
    return a;
  }
}










// static Future<void> uploadFile(Uint8List filePath) async {
  //   // Uint8List imageInUnit8List = filePath; // store unit8List image here ;
  //   // final tempDir = await getTemporaryDirectory();
  //   File file = File.fromRawPath(filePath);
  //   //file.writeAsBytesSync(imageInUnit8List);
  //   //   print(file.path);
  //   firebase_storage.Reference ref =
  //       firebase_storage.FirebaseStorage.instance.ref('images/a.png');
  //   try {
  //     print("intry");
  //     await ref.putFile(file);
  //   } on FirebaseException catch (e) {
  //     print(e.toString());
  //   }
  // }