import 'package:budget_app/Models/details.dart';
import 'package:budget_app/Models/totals.dart';
import 'package:budget_app/Screens/total_screen.dart';
import 'package:budget_app/Screens/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:page_transition/page_transition.dart';


class DetailsScreen extends StatefulWidget {

  final description;
  DetailsScreen({required this.description});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late DetailsField detailFields;
  late Future _myNetworkFuture;
  Widget cardWidget({required double h,required double w,required String description, required String value,required int rowNo})
  {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        height: h*0.12,
        decoration: BoxDecoration(
            border: Border.all(

            ),
            color: Colors.grey[300],
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade300,
                  offset: Offset(100.0, 1.0),
                  blurRadius: 10.0,
                  spreadRadius: 0.1),
              const BoxShadow(
                  color:  Colors.white30,
                  offset: Offset(-100.0, -1.0),
                  blurRadius: 10.0,
                  spreadRadius: 0.1),
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: (
              Row(

                children: [
                  Expanded(flex:3,
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.3,
                        ),
                      )),
                  SizedBox(
                    width: w*0.07,
                  ),
                   Expanded(
                      flex:3,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "\$$value",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1,
                          ),
                        ),
                      )),
                  // Expanded(
                  //   flex: 1,
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: const [
                  //       Icon(
                  //         Icons.delete_forever,
                  //         color: Colors.red,
                  //       ),
                  //       FittedBox(
                  //         child: Text(
                  //           "Delete"
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // )

                ],)),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    detailFields=DetailsField(description:widget.description);
    _myNetworkFuture=detailFields.init().then((value) {
      return detailFields.getRows();});
  }

  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    if(_myNetworkFuture==null)
    {
      _myNetworkFuture=detailFields.init().then((value) {
        return detailFields.getRows();
      });
    }
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:  Center(child: Text(
          widget.description,
          style: TextStyle(
              fontSize: 20,
              letterSpacing: 1.5
          ),
        ),),
      ),


      body: Padding(
        padding: EdgeInsets.fromLTRB(w*0.06,h*0.005 , w*0.04, h*0.01),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: h*0.75,
                width: w,
                child: FutureBuilder(
                  future: _myNetworkFuture,

                  builder: (context,AsyncSnapshot snapshot)
                  {
                    if(snapshot.hasData)
                    {
                      List<Map<String,dynamic>> l =List.from(snapshot.data);
                      return l.isNotEmpty? ListView.builder(
                          itemCount: l.length,
                          itemBuilder: (context,index){
                            return cardWidget(h: h,w: w,description: l[index]["description"],
                                value: l[index]["total"],rowNo:l[index]["rowNo"]);
                          }):
                      const Center(
                        child: Text(
                            "Nothing to show"
                        ),
                      );
                    }
                    else
                    {
                      return Center(child: Text("Loading"),);
                    }
                  },

                )

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    width: w*0.35,
                    height: h*0.075,
                    child: ElevatedButton(
                      onPressed: ()
                      {
                        Navigator.pushReplacement(context, PageTransition(
                            duration: Duration(milliseconds: 500),
                            type: PageTransitionType.leftToRightWithFade, child: TotalScreen(
                        )));
                      },
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(20),
                          backgroundColor: MaterialStateProperty.all(Colors.black),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),)
                      ),
                      child: Text(
                        "Back",
                        style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 15,
                        ),
                      ),
                    )
                ),
                Container(
                    width: w*0.35,
                    height: h*0.075,
                    child: ElevatedButton(
                      onPressed: ()
                      {
                        Navigator.pushReplacement(context, PageTransition(
                            duration: Duration(milliseconds: 500),
                            type: PageTransitionType.leftToRightWithFade, child:TransactionScreen(
                          description: widget.description,
                        )));
                      },
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(20),
                          backgroundColor: MaterialStateProperty.all(Colors.black),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),)
                      ),
                      child: Text(
                        "Add",
                        style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 15,
                        ),
                      ),
                    )
                ),

              ],
            )

          ],

        ),
      )

    );
  }
}
