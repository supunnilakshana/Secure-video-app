import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:securevideo/service/encryption/keys.dart';

class Cryptovideo {
  var random = new Random();
  KeyStore _keyStore = KeyStore();

  //decrypt
  String decryptText(String text, String keytext) {
    // String keytext = _keyStore.findkey(keycode);
    print(keytext);
    final key = Key.fromUtf8(keytext);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final decryptedText = encrypter.decrypt64(text, iv: iv);
    print(decryptedText);
    return decryptedText;
  }

//encrypt
  EncryptedItem ecryptText(String text) {
    KeyItem keyItem = _keyStore.genarateKeyitem();

    String keytext = keyItem.key;
    print(keytext);
    final key = Key.fromUtf8(keytext);
    final iv = IV.fromLength(16);
    // print(iv.base64);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(text, iv: iv);

    print(encrypted.base64);

    String encryptedText = encrypted.base64;

    return EncryptedItem(video: File(encryptedText), key: keytext); //wrong
  }

  Future<EncryptedItem> encryptFile(File video) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File outFile = new File("$dir/videoenc.aes");
    KeyItem keyItem = _keyStore.genarateKeyitem();

    String keytext = keyItem.key;

    bool outFileExists = await outFile.exists();

    if (!outFileExists) {
      outFile.create();
      print("created");
    }

    final videoFileContents = video.readAsStringSync(encoding: latin1);

    final key = Key.fromUtf8(keytext);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(videoFileContents, iv: iv);
    await outFile.writeAsBytes(encrypted.bytes);

    print("encrypted");

    return (EncryptedItem(video: outFile, key: keytext));
  }

  Future<File?> decryptFile(File inFile, String keycode) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File outFile = File("$dir/videodec.mp4");

    bool outFileExists = await outFile.exists();

    if (!outFileExists) {
      outFile.create();
    }

    final videoFileContents = inFile.readAsBytesSync();

    final key = Key.fromUtf8(keycode);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));

    final encryptedFile = Encrypted(videoFileContents);
    final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

    final decryptedBytes = latin1.encode(decrypted);
    await outFile.writeAsBytes(decryptedBytes);
    print("decrypted");
    return outFile;
  }
}

class EncryptedItem {
  final File video;
  final String key;

  EncryptedItem({required this.video, required this.key});
}
