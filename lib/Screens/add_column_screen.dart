import 'package:budget_app/Models/details.dart';
import 'package:budget_app/Screens/total_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AddColumnScreen extends StatefulWidget {
  const AddColumnScreen({Key? key}) : super(key: key);

  @override
  _AddColumnScreenState createState() => _AddColumnScreenState();
}

class _AddColumnScreenState extends State<AddColumnScreen> {
  TextEditingController columnNameController=TextEditingController();
  late DetailsField detailsField;
  bool isLoading=false;

  @override
  void initState() {
    super.initState();
    detailsField=DetailsField(description:"");
  }

  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    final snackBar = SnackBar(
      content: const Text('Please fill the text field'),
      action: SnackBarAction(
        label: 'O.K',
        onPressed: () {
          ScaffoldMessenger.of(context).clearSnackBars();
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
          child: Text(
            "Add Column",
            style: TextStyle(
                fontSize: 20,
                letterSpacing: 1.5
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              isLoading==true?
                  Container(
                    height: h*0.03,
                      child: Text("Loading..")):Container(height: h*0.03,),
              SizedBox(height: h*0.04,),
              Text("Enter the column name",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                letterSpacing: 1.4

              ),),
              SizedBox(height: h*0.04,),
              TextFormField(
                controller: columnNameController,
                decoration: InputDecoration(
                  labelText: "Column Name",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blueGrey,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: h*0.04,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      width: w*0.35,
                      height: h*0.075,
                      child: ElevatedButton(
                        onPressed: ()async
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
                        onPressed: ()async
                        {
                          if(isLoading==false)
                            {
                              if(columnNameController.text.isEmpty)
                              {
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                              else
                              {
                                setState(() {
                                  isLoading=true;
                                });
                                await detailsField.init().then((value) {
                                  detailsField.addColumns(colName: columnNameController.text).then((value) {
                                    Future.delayed(Duration(seconds: 2)).then((value) {
                                      setState(() {
                                        isLoading=false;
                                      });
                                      Navigator.pushReplacement(context, PageTransition(
                                          duration: Duration(milliseconds: 1000),
                                          type: PageTransitionType.leftToRightWithFade, child: TotalScreen(
                                      )));
                                    });

                                  });
                                });


                              }
                            }



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
        ),
      ),
    );
  }
}
