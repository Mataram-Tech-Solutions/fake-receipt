
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_fake_receipt/app/modules/JSB/views/jsb_view.dart';
import 'package:project_fake_receipt/app/modules/JSN/views/jsn_view.dart';
import 'package:project_fake_receipt/app/modules/JTJ/views/jtj_view.dart';
import 'package:project_fake_receipt/app/modules/JTJindo/views/j_t_jindo_view.dart';
import 'package:project_fake_receipt/app/modules/Pertamina/views/pertamina_view.dart';
import 'package:project_fake_receipt/app/modules/TMJ/views/tmj_view.dart';
import 'package:project_fake_receipt/app/modules/mandiri/views/mandiri_view.dart';

class GridDashboard extends StatelessWidget {
  Items item1 = new Items(
      title: "Pertamina",
      img: "assets/images/pertamina.png",
      route: PertaminaView());

  Items item2 = new Items(
      title: "Jasamarga Solo Ngawi",
      img: "assets/images/jsn.png",
      route: JSNView());

  Items item3 = new Items(
      title: "Trans Marga Jateng",
      img: "assets/images/tmj.png",
      route: TMJView());

  Items item4 = new Items(
      title: "Jasamarga Semarang Batang",
      img: "assets/images/jsb.png",
      route: JSBView());

  Items item5 = new Items(
      title: "Jasamarga Transjawa",
      img: "assets/images/jtj.png",
      route: JTJView());

  Items item6 = new Items(
      title: "Mandiri",
      img: "assets/images/mandiri.png",
      route: MandiriView());

  Items item7 = new Items(
      title: "Indonesia High Corp",
      img: "assets/images/jtj.png",
      route: JTJindoView());


  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4, item5, item6, item7];
    var color = 0xFF4B8E6A;
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => data.route),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color(color), borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      data.img,
                      width: 110,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      data.title,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
    );
  }
}

class Items {
  String title;
  String img;
  Widget route;
  Items({required this.title, required this.img, required this.route});
}


