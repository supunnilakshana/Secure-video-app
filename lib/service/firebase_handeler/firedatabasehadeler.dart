import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:securevideo/models/eventnewsachievementsmodel.dart';
import 'package:securevideo/models/galleryitemmodel.dart';

class FireDBhandeler {
  static final firestoreInstance = FirebaseFirestore.instance;
  static final DatabaseReference dbRef = FirebaseDatabase.instance.ref("count");
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

  //add gallery item
  static Future<int> addgalleryitem(GalleryItemmodel gmodel) async {
    int status = await checkdocstatus("gallery", gmodel.id);
    if (status == 1) {
      firestoreInstance
          .collection("gallery")
          .doc(gmodel.id)
          .set(gmodel.toMap())
          .then((_) {
        print("creategalley doc");
      });
    } else {
      print("  already exsists");
    }
    return status;
  }

  //get gallery items
  static Future<List<GalleryItemmodel>> getGallery() async {
    List<GalleryItemmodel> glist = [];
    GalleryItemmodel gmodel;
    QuerySnapshot querySnapshot =
        await firestoreInstance.collection("gallery").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];

      // teachermodel = Teachermodel.fromSnapshot(a);
      gmodel = GalleryItemmodel.fromMap(a.data() as Map<String, dynamic>);
      glist.add(gmodel);
      // print(teachermodel.serialno);
    }
    return glist;
  }

  //add event, news or achievement
  static Future<int> addEventNews(EventNewsAchievementsModel enmodel) async {
    int status = await checkdocstatus("eventnews", enmodel.id);
    if (status == 1) {
      firestoreInstance
          .collection("eventnews")
          .doc(enmodel.id)
          .set(enmodel.toMap())
          .then((_) {
        print("create eventnews doc");
      });
    } else {
      print(" event or news item already exists");
    }
    return status;
  }

  //get event/news items
  static Future<List<EventNewsAchievementsModel>> getEventsNews() async {
    List<EventNewsAchievementsModel> enlist = [];
    EventNewsAchievementsModel enmodel;
    QuerySnapshot querySnapshot =
        await firestoreInstance.collection("eventnews").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      print(a.data());
      enmodel =
          EventNewsAchievementsModel.fromMap(a.data() as Map<String, dynamic>);
      enlist.add(enmodel);
      print("passed");
    }
    print(enlist);
    return enlist;
  }

  //update events/news

  static Future<int> updateEventNews(EventNewsAchievementsModel enmodel) async {
    int status = await checkdocstatus("eventnews", enmodel.id);
    if (status == 0) {
      firestoreInstance
          .collection("eventnews")
          .doc(enmodel.id)
          .update(enmodel.toMap())
          .then((_) {
        print("updated event/news doc");
      });
    } else {
      print(" no such event/doc");
    }
    return status;
  }

  //add achievement
  static Future<int> addAchievement(EventNewsAchievementsModel enmodel) async {
    int status = await checkdocstatus("achievements", enmodel.id);
    if (status == 1) {
      firestoreInstance
          .collection("achievements")
          .doc(enmodel.id)
          .set(enmodel.toMap())
          .then((_) {
        print("create achievements doc");
      });
    } else {
      print(" achievements item already exists");
    }
    return status;
  }

  //get achievement
  static Future<List<EventNewsAchievementsModel>> getAchievements() async {
    List<EventNewsAchievementsModel> enlist = [];
    EventNewsAchievementsModel enmodel;
    QuerySnapshot querySnapshot =
        await firestoreInstance.collection("achievements").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      print(a.data());
      enmodel =
          EventNewsAchievementsModel.fromMap(a.data() as Map<String, dynamic>);
      enlist.add(enmodel);
      print("passed");
    }
    print(enlist);
    return enlist;
  }

  //update achievement
  static Future<int> updateAchievement(
      EventNewsAchievementsModel enmodel) async {
    int status = await checkdocstatus("achievements", enmodel.id);
    if (status == 0) {
      firestoreInstance
          .collection("achievements")
          .doc(enmodel.id)
          .update(enmodel.toMap())
          .then((_) {
        print("updated achievements doc");
      });
    } else {
      print(" no such achievement");
    }
    return status;
  }

  //getdoccount

  static Future<int> getDocCount(String collection) async {
    QuerySnapshot _myDoc = await firestoreInstance.collection(collection).get();

    return _myDoc.docs.length;
    // Count of Documents in Collection
  }

  static updateDocCountRealtime(String key, int value) async {
    await dbRef.update({
      key: value,
    });
  }

  //delete document
  static Future<int> deletedoc(String id, String collection) async {
    int ishere = await checkdocstatus(collection, id);
    if (ishere == 0) {
      await firestoreInstance.collection(collection).doc(id).delete();
    }
    return ishere;
  }
}
