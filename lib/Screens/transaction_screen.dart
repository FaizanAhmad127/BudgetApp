
import 'package:budget_app/Models/details.dart';
import 'package:budget_app/Screens/details_screen.dart';
import 'package:budget_app/Screens/total_screen.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:page_transition/page_transition.dart';

class TransactionScreen extends StatefulWidget {

  final description;
  TransactionScreen({required this.description});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late DetailsField detailsField;
  TextEditingController descriptionController=TextEditingController();
  TextEditingController valueController=TextEditingController();
  String dropdownvalue="d";
  bool isLoaded=false;
  bool isLoading=false;
  late Future _myNetworkFuture;

  @override
  void initState() {
    super.initState();
    detailsField=DetailsField( description: widget.description);
    _myNetworkFuture=detailsField.init().then((value) {
      return detailsField.getColumnNames();});

  }
  bool validate({required String des, required String val})
  {
    if(des.isEmpty || val.isEmpty)
      {
        print("one of the field is empty");
        return false;
      }
    else
      {
        return true;
      }
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
    if(_myNetworkFuture==null)
      {
        _myNetworkFuture=detailsField.init().then((value) {
          return detailsField.getColumnNames();});
      }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            "Budget App",
            style: TextStyle(
                fontSize: 20,
                letterSpacing: 1.5
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: FutureBuilder(
            future: _myNetworkFuture,
            builder: (context,AsyncSnapshot snapshot)
            {
              if(snapshot.hasData)
              {

                List<String> items=List.from(snapshot.data);
                if(isLoaded==false)
                  {
                    if(widget.description!="")
                      {
                        dropdownvalue=widget.description;
                      }
                    else
                      {
                        dropdownvalue=items[0];
                      }

                    isLoaded=true;
                  }

                return Column(
                  children: [
                    isLoading==true?Container(
                        height: h*0.03,
                        child: Text("Loading..")):Container(height: h*0.03,),
                    SizedBox(height: h*0.04,),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: w,

                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: DropdownButton(

                            dropdownColor: Colors.grey.shade300,
                            isExpanded: true,
                            underline: Container(),
                            // Initial Value
                            value: dropdownvalue,

                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),

                            // Array list of items
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h*0.07,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: "Description",
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
                    SizedBox(
                      height: h*0.07,
                    ),
                    TextFormField(
                      controller: valueController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Value",
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
                    SizedBox(
                      height: h*0.07,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: w*0.35,
                            height: h*0.075,
                            child: ElevatedButton(
                              onPressed: ()
                              {
                                if(widget.description=="")
                                  {
                                    Navigator.pushReplacement(context, PageTransition(
                                        duration: Duration(milliseconds: 500),
                                        type: PageTransitionType.leftToRightWithFade, child: TotalScreen(

                                    )));
                                  }
                                else
                                  {
                                    Navigator.pushReplacement(context, PageTransition(
                                        duration: Duration(milliseconds: 500),
                                        type: PageTransitionType.leftToRightWithFade, child: DetailsScreen(

                                      description: widget.description,
                                    )));
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

                                String description=descriptionController.text;
                                String value=valueController.text;
                                if(validate(des: description,
                                    val: value)==true)
                                {
                                  if(isLoading==false)
                                  {
                                    setState(() {
                                      isLoading=true;
                                    });

                                    await detailsField.addRow(des: description,
                                        val: value,descript: dropdownvalue)
                                        .then((value) {
                                      Future.delayed(const Duration(seconds: 2)).then((value) {
                                        if(widget.description=="")
                                        {
                                          Navigator.pushReplacement(context, PageTransition(
                                              duration: const Duration(milliseconds: 500),
                                              type: PageTransitionType.leftToRightWithFade, child: const TotalScreen(

                                          )));
                                        }
                                        else
                                        {
                                          Navigator.pushReplacement(context, PageTransition(
                                              duration: const Duration(milliseconds: 500),
                                              type: PageTransitionType.leftToRightWithFade, child: DetailsScreen(

                                            description: widget.description,
                                          )));
                                        }
                                      });

                                    });
                                  }

                                }
                                else
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                                "Submit",
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
                );
              }
              else
              {
                return Center(
                  child: Text("Loading..."),
                );
              }

            },

          ),

        ),
      ),
    );
  }
}
