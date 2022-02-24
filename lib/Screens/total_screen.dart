import 'package:budget_app/Models/details.dart';
import 'package:budget_app/Models/totals.dart';
import 'package:budget_app/Screens/details_screen.dart';
import 'package:budget_app/Screens/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:page_transition/page_transition.dart';


class TotalScreen extends StatefulWidget {
 final List<Worksheet?> workSheetList;
   TotalScreen({required this.workSheetList});

  @override
  _TotalScreenState createState() => _TotalScreenState();
}

class _TotalScreenState extends State<TotalScreen> {
  late TotalFields totalFields;
  late DetailsField detailsField;
  Widget cardWidget({required double h,required double w,required String description, required double value})
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
                    "\$${value.toString()}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                    ),
                  ),
                )),
                 Expanded(
                    flex:1,
                    child: FittedBox(

                      child: GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context, PageTransition(
                              duration: Duration(milliseconds: 500),
                              type: PageTransitionType.rightToLeftWithFade, child: DetailsScreen(
                            workSheetList: widget.workSheetList,
                            description: description,
                          )));
                        },
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                        ),
                      )
                    )),
          ],)),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    totalFields=TotalFields(totalWorksheet: widget.workSheetList[0]);
    detailsField=DetailsField(detailWorksheet: widget.workSheetList[1], description: "");
    detailsField.getColumnNames();
  }

  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
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

      body: Padding(
        padding: EdgeInsets.fromLTRB(w*0.06,h*0.005 , w*0.04, h*0.01),
        child: widget.workSheetList!=[]?Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: h*0.75,
                width: w,
                child: FutureBuilder(
                  builder: (context,AsyncSnapshot snapshot)
                  {
                    if(snapshot.hasData)
                    {
                      List<Map<String,dynamic>> l =List.from(snapshot.data);
                      return l.isNotEmpty?ListView.builder(
                          itemCount: l.length,
                          itemBuilder: (context,index){
                            return cardWidget(h: h,w: w,description: l[index]["description"], value: l[index]["total"]);
                          }):
                      Container(child: Center(
                        child: Text(
                            "Nothing to show"
                        ),
                      ),);
                    }
                    else
                    {
                      return Center(child: Text("Loading"),);
                    }
                  },
                  future: totalFields.getRows(),
                )

            ),

            Container(
              width: w*0.5,
              height: h*0.075,
              child: FloatingActionButton(
                elevation: 20,
                backgroundColor: Colors.black,
                splashColor: Colors.green,
                hoverColor: Colors.black54,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                ),

                onPressed: (){
                  Navigator.pushReplacement(context, PageTransition(
                      duration: Duration(milliseconds: 500),
                      type: PageTransitionType.leftToRightWithFade, child:TransactionScreen(
                    workSheetList: widget.workSheetList,
                    description: "",
                  )));
                },
                tooltip: "Add Transaction",
                child: Text(
                  "ADD",
                  style: TextStyle(
                    letterSpacing: 1.5,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],

        ):
        Container(child: Center(
          child: Text(
            "Nothing to show.."
          ),
        ),),
      ),
    );
  }
}
