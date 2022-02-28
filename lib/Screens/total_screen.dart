import 'package:budget_app/Models/details.dart';
import 'package:budget_app/Models/totals.dart';
import 'package:budget_app/Screens/add_column_screen.dart';
import 'package:budget_app/Screens/details_screen.dart';
import 'package:budget_app/Screens/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:page_transition/page_transition.dart';


class TotalScreen extends StatefulWidget {
  const TotalScreen({Key? key}) : super(key: key);




  @override
  _TotalScreenState createState() => _TotalScreenState();
}

class _TotalScreenState extends State<TotalScreen> {
  late TotalFields totalFields;
  late Future? _myNetworkFuture;
  bool isLoading=false;

  Widget cardWidget({required double h,required double w,required String description, required double value,required int rowNo})
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
          padding: const EdgeInsets.only(left: 10,right: 10,top: 5),
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
                    "\$${value.toString()}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                    ),
                  ),
                )),
                 Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.end,
                       children: [
                   Expanded(
                       flex:1,
                       child: FittedBox(

                           child: GestureDetector(
                             onTap: (){
                               Navigator.pushReplacement(context, PageTransition(
                                   duration: Duration(milliseconds: 500),
                                   type: PageTransitionType.rightToLeftWithFade, child: DetailsScreen(
                                 description: description,
                               )));
                             },
                             child: const Icon(
                               Icons.arrow_forward_ios_outlined,
                             ),
                           )
                       )),
                   SizedBox(height:h*0.005),
                   Expanded(
                       child: GestureDetector(
                         onTap: ()async
                         {
                           if(isLoading==false)
                             {
                               setState(() {
                                 isLoading=true;
                               });
                               await totalFields.deleteRow(rowNo).then((value) {
                                 DetailsField(description: "").init().then((detailsField) {
                                   //deleting the description col
                                   detailsField.deleteColumn(colName: description).then((value){
                                     //deleting the dollars col
                                     detailsField.deleteColumn(colName: description+"_V").then((value) {
                                       Navigator.pushReplacement(context, PageTransition(
                                           duration: Duration(milliseconds: 500),
                                           type: PageTransitionType.leftToRightWithFade, child: TotalScreen(
                                       )));
                                     });
                                   });
                                 });

                               });

                             }

                         },
                         child: FittedBox(
                             child: Text("Delete",
                               style: TextStyle(color: Colors.red),)),
                       ))
                 ],))

          ],)),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    totalFields=TotalFields();
    _myNetworkFuture=totalFields.init().then((value) {
      return totalFields.getRows();
    });

  }

  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    if(_myNetworkFuture==null)
    {
      _myNetworkFuture=totalFields.init().then((value) {
        return totalFields.getRows();
      });
    }
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(child: Text(
          "Budget App",
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 1.5
          ),
        ),),
      ),

      body: FutureBuilder(
        future: _myNetworkFuture,
        builder: (context, AsyncSnapshot snapshot)
        {
          if(snapshot.hasData)
            {
              List<Map<String,dynamic>> l =List.from(snapshot.data);
              return Stack(
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(w*0.06,h*0.005 , w*0.04, h*0.01),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: h*0.75,
                              width: w,
                              child:
                              l.isNotEmpty?ListView.builder(
                                        itemCount: l.length,
                                        itemBuilder: (context,index){
                                          return cardWidget(h: h,w: w,
                                              description: l[index]["description"], 
                                              value: l[index]["total"],
                                              rowNo: l[index]["rowNo"],
                                          );
                                        }):
                                    const Center(
                                      child: Text(
                                          "Nothing to show"
                                      ),
                                    ),

                          ),
                          Container(
                              width: w*0.5,
                              height: h*0.075,
                              child: ElevatedButton(
                                onPressed: ()
                                {
                                  Navigator.pushReplacement(context, PageTransition(
                                      duration: Duration(milliseconds: 500),
                                      type: PageTransitionType.leftToRightWithFade, child:TransactionScreen(

                                    description: "",
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
                                  "ADD",
                                  style: TextStyle(
                                    letterSpacing: 1.5,
                                    fontSize: 15,
                                  ),
                                ),
                              )
                          ),

                        ],

                      )


                  ),


                  Positioned(
                    right: 0,
                    top: h*0.4,
                    child: Container(
                      width: w*0.3,
                      height: h*0.07,
                      child: ElevatedButton(
                        onPressed: ()
                        {
                          Navigator.pushReplacement(context, PageTransition(
                              duration: Duration(milliseconds: 500),
                              type: PageTransitionType.leftToRightWithFade, child: AddColumnScreen(
                          )));
                        },
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(20),
                            backgroundColor: MaterialStateProperty.all(Colors.blue),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(

                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(0),
                                    topRight: Radius.circular(0),
                                  )
                              ),
                            )
                        ),
                        child: FittedBox(
                          child: Text(
                            "Add Column",
                            style: TextStyle(
                                fontSize: 16,

                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                    ),
                   ),
                  isLoading==true?
                  Positioned(
                      child: Opacity(
                        opacity: 0.7,
                        child: Container(
                           color: Colors.white,
                          child: Center(
                            child: Text(
                              "Loading...",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2
                              ),
                            ),
                          ),

                  ),
                      )):Container(),

                ],
              );
            }
          else
          {
            return const Center(child: Text("Loading"),);
          }
        },
      ),


      );

  }
}
