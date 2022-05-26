import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:securevideo/constants_data/ui_constants.dart';
import 'package:securevideo/models/drivemodel.dart';

class SingleDriveItem extends StatefulWidget {
  final Drivemodel drivemodel;

  const SingleDriveItem({
    Key? key,
    required this.drivemodel,
  }) : super(key: key);

  @override
  _SingleDriveItemState createState() => _SingleDriveItemState();
}

class _SingleDriveItemState extends State<SingleDriveItem> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.25,
      // height: size.height * 0.2,
      decoration: BoxDecoration(
          color: Colors.indigoAccent.withOpacity(0.2),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              child: Padding(
                  padding: EdgeInsets.all(size.height * 0.00),
                  child: Image.asset(
                      'assets/icons/fileicon.png')), // Image.network(fiximagelink + widget.imgname)
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: size.height * 0.01),
            child: Text(
              widget.drivemodel.fileName + widget.drivemodel.extesion,
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
            ),
          ),
          // Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //   Text(
          //     widget.drivemodel.date,
          //     style: TextStyle(
          //         color: Colors.redAccent, fontWeight: FontWeight.bold),
          //   ),
          // ]),
          //Customtost.commontost("THis item out of stock", Colors.amber);
        ],
      ),
    );
  }
}
