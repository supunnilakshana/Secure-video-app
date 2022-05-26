import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icon.dart';
import 'package:lottie/lottie.dart';

import 'package:securevideo/constants_data/ui_constants.dart';

import 'package:securevideo/models/drivemodel.dart';
import 'package:securevideo/pages/Home/drive_tab/components/singelDriveitem.dart';
import 'package:securevideo/pages/Home/drive_tab/components/viewDrivescreen.dart';
import 'package:securevideo/pages/Home/sendvideoscreen.dart';
import 'package:securevideo/pages/Home/viewvideoscreen.dart';
import 'package:securevideo/service/firebase_handeler/firedatabasehadeler.dart';
import 'package:securevideo/ui_components/errorpage.dart';

import 'components/sendDrivescreen.dart';

class Drivescreen extends StatefulWidget {
  const Drivescreen({Key? key}) : super(key: key);
  @override
  _DrivescreenState createState() => _DrivescreenState();
}

class _DrivescreenState extends State<Drivescreen> {
  late Future<List<Drivemodel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = FireDBhandeler.getDrive();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            elevation: 0.0,
            label: Text("Upload File to Drive"),
            icon: Icon(Icons.upload),
            backgroundColor: kprimaryColor,
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SendDrivescreen()))
                  .then((val) => val ? loaddata() : null);
            }),
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: size.width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LineIcon.folder(
                      size: size.width * 0.09,
                      color: Colors.deepPurple.shade500,
                    ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Text(
                      "My Drive",
                      style: TextStyle(
                          fontSize: size.width * 0.08,
                          color: Colors.deepPurple.shade500),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: FutureBuilder(
                    future: futureData,
                    builder: (context, snapshot) {
                      print(snapshot.hasData);
                      if (snapshot.hasData) {
                        List<Drivemodel> data =
                            snapshot.data as List<Drivemodel>;
                        print(data);
                        if (data.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset("assets/animation/emptybox.json",
                                  width: size.width * 0.75),
                              Text(
                                "Your Drive is empty",
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: size.width * 0.045,
                                    color: kheadingcolorlight),
                              ),
                            ],
                          ); //nodatafound.json
                        } else {
                          return Container(
                            child: GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              childAspectRatio: size.width / size.height * 1.5,
                              crossAxisCount: 3,
                              mainAxisSpacing: size.height * 0.01,
                              crossAxisSpacing: size.width * 0.03,
                              shrinkWrap: true,
                              children: List.generate(data.length, (index) {
                                return Container(
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewDriveItemScreen(
                                                          drivemodel:
                                                              data[index])));
                                        },
                                        child: SingleDriveItem(
                                            drivemodel: data[index])));
                              }),
                            ),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Errorpage(size: size.width * 0.7);
                      }
                      // By default show a loading spinner.
                      return Center(
                          child: Lottie.asset("assets/animation/msgload.json",
                              width: size.width * 0.6));
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  loaddata() async {
    futureData = FireDBhandeler.getDrive();
    setState(() {});
  }
}

  // child: ListView.builder(
                                  // itemCount: data.length,
                                  // itemBuilder: (context, indext) {
                                  //   return Padding(
                                  //     padding: EdgeInsets.only(
                                  //         left: size.width * 0.02,
                                  //         right: size.width * 0.02),
                                  //     child: Card(
                                  //       shape: RoundedRectangleBorder(
                                  //           borderRadius:
                                  //               BorderRadius.circular(20)),
                                  //       color: kmenucolor.withOpacity(0.8),
                                  //       child: GestureDetector(
                                  //         onTap: () {
                                  //           // print(indext);
                                  //           // Navigator.push(
                                  //           //     context,
                                  //           //     MaterialPageRoute(
                                  //           //         builder: (context) =>
                                  //           //             ViewVideoScreen(
                                  //           //                 Drivemodel:
                                  //           //                     data[indext],
                                  //           //                 issent: false)));
                                  //         },
                                  //         child: ListTile(
                                  //             contentPadding:
                                  //                 EdgeInsets.symmetric(
                                  //                     horizontal: 20.0,
                                  //                     vertical: 10.0),
                                  //             leading: Container(
                                  //               padding: EdgeInsets.only(
                                  //                   right: 12.0),
                                  //               decoration: BoxDecoration(
                                  //                   border: Border(
                                  //                       right: BorderSide(
                                  //                           width: 1.0,
                                  //                           color: Colors
                                  //                               .white24))),
                                  //               child: Icon(Icons.mail_outline,
                                  //                   color: Colors.white),
                                  //             ),
                                  //             title: Row(
                                  //               children: [
                                  //                 Flexible(
                                  //                   child: Text(
                                  //                     data[indext].fileName +
                                  //                         data[indext].extesion,
                                  //                     style: TextStyle(
                                  //                         color: Colors.white,
                                  //                         fontSize:
                                  //                             size.width * 0.05,
                                  //                         fontWeight:
                                  //                             FontWeight.w500),
                                  //                     maxLines: 1,
                                  //                     overflow:
                                  //                         TextOverflow.ellipsis,
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //             // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                  //             subtitle: Row(
                                  //               children: [
                                  //                 Icon(
                                  //                     Icons.date_range_outlined,
                                  //                     color:
                                  //                         Colors.yellowAccent),
                                  //                 SizedBox(
                                  //                     width: size.width * 0.01),
                                  //                 Expanded(
                                  //                   child: Text(
                                  //                       data[indext].date,
                                  //                       overflow:
                                  //                           TextOverflow.clip,
                                  //                       maxLines: 1,
                                  //                       style: TextStyle(
                                  //                           color:
                                  //                               Colors.white)),
                                  //                 )
                                  //               ],
                                  //             ),
                                  //             trailing: GestureDetector(
                                  //                 onTap: () async {},
                                  //                 child: Icon(Icons.delete,
                                  //                     color:
                                  //                         Colors.yellowAccent,
                                  //                     size:
                                  //                         size.width * 0.08))),
                                  //       ),
                                  //     ),
                                  //   );
                                  // }),