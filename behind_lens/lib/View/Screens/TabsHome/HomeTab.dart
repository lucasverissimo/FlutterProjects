import 'package:behind_lens/View/Common/ItemPost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color(0xff444444),
                borderRadius: BorderRadius.circular(5)
            ),
            child: Center(
              child: Container(
                height: 210.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(10, (int index) {
                    return Card(
                      color: Color(0xff222222),
                      child: Container(
                        width: 160.0,
                        height: 210.0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, "/profile");
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage("assets/user-example-image.jpg"),
                                    radius: 50,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text("Gabrielle Aplin", style: TextStyle(color: Colors.white, fontSize: 14), textAlign: TextAlign.center,),
                              ),
                              RaisedButton(
                                child: Text("Seguir"),
                                color: Colors.transparent,
                                textColor: Color(0xfffe386b),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(
                                    width: 2,
                                    color: Color(0xfffe386b)
                                  ),
                                ),
                                onPressed: (){}
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),            
          ),
          // posts abaixo
        /*
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index){
              return ItemPost(index, {});
            }
          ),*/
        ],
      ),
    );
  }
}
