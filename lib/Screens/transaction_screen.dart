import 'package:budget_app/Models/details.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';

class TransactionScreen extends StatefulWidget {
  final List<Worksheet?> workSheetList;
  final description;
  TransactionScreen({required this.workSheetList,required this.description});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late DetailsField detailsField;
  TextEditingController descriptionController=TextEditingController();
  TextEditingController valueController=TextEditingController();
  String dropdownvalue="d";
  bool isLoaded=false;

  @override
  void initState() {
    super.initState();
    detailsField=DetailsField(detailWorksheet: widget.workSheetList[1], description: widget.description);

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
                            color: Colors.green,
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
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h*0.07,
                    ),
                    Container(
                        width: w*0.35,
                        height: h*0.075,
                        child: ElevatedButton(
                          onPressed: ()
                          {
                            String description=descriptionController.text;
                            String value=valueController.text;
                            if(validate(des: description,
                                val: value)==true)
                              {
                                detailsField.addRow(des: description,
                                    val: value,descript: dropdownvalue)
                                    .then((value) {
                                  Navigator.pop(context);
                                });
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
                );
              }
              else
              {
                return Center(
                  child: Text("Loading"),
                );
              }

            },
            future: detailsField.getColumnNames(),
          ),

        ),
      ),
    );
  }
}
