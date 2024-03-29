import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserdbHandeler {
  static final user = FirebaseAuth.instance.currentUser;
  static final firestoreInstance = FirebaseFirestore.instance;

  //check doc is exists
  static Future<int> checkdocstatus(String collectionpath, String docid) async {
    var a = await FirebaseFirestore.instance
        .collection(collectionpath)
        .doc(docid)
        .get();
    if (a.exists) {
      print('Exists');
      return 0;
    } else if (!a.exists) {
      print('Not exists');
      return 1;
    } else {
      return 2;
    }
  }

//--------------------------------------add user----------------------------------------------------------------------------
  static Future<void> adduser(String email) async {
    int existuser = await checkdocstatus("/users/", email);

    if (existuser == 1) {
      firestoreInstance.collection("users").doc(email).set({
        "email": email,
      }).then((_) {
        print("create user doc");
      });
    } else
      print("user doc allready user doc");
  }

  //--------------------------------------get user user list---------------------------------------------------------------------------
  static Future<List<String>> getuserlist() async {
    List<dynamic> users = [];
    List<String> userlist = [];
    var firebaseUser = FirebaseAuth.instance.currentUser;
    int count = 0;
    await firestoreInstance
        .collection("users")
        .doc("userlist")
        .get()
        .then((value) {
      print(value.data()!["user_list"]);
      users = value.data()!["user_list"];
      users.forEach((element) {
        userlist.add(element.toString());
      });
    });
    return userlist;
  }

  //--------------------------------------get user user count----------------------------------------------------------------------------
  static Future userusercount() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    int count = 0;
    await firestoreInstance
        .collection("users")
        .doc("userlist")
        .get()
        .then((value) {
      print(value.data()!["users"]);
      count = (value.data()!["users"]);
      // print("----------------------------------------------------------------" +  count.toString());
    });
    return count;
  }

  //--------------------------------------update user user count----------------------------------------------------------------------------
  static Future updateusercount() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    int count = await userusercount();
    await firestoreInstance
        .collection("users")
        .doc("userlist")
        .update({"users": count + 1}).then((_) {
      print("success!");
    });
  }

  static Future updateuserlist(String name) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    List<String> currentlist = await getuserlist();
    currentlist.add(name);
    await firestoreInstance
        .collection("users")
        .doc("userlist")
        .update({"user_list": currentlist}).then((_) {
      print("added");
    });
  }

  static Future inituserlist(String name) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    List<String> currentlist = [];
    currentlist.add(name);
    await firestoreInstance
        .collection("users")
        .doc("userlist")
        .update({"user_list": currentlist}).then((_) {
      print("added");
    });
  }
}
