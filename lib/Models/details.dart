import 'package:budget_app/Models/totals.dart';
import 'package:budget_app/sheets/api/user_sheets_api.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';

class DetailsField{
  late final Worksheet? detailWorksheet;
  final String description;
  DetailsField({required this.description});
  Future<DetailsField> init()async
  {
    return await UserSheetApi.init().then((value) {
      detailWorksheet=value[1];
      return this;
    });
  }
  Future<List<Map<String,dynamic>>> getRows()async
  {
    try{
      List<Map<String,dynamic>> listOfTotals=[];
      List<String>? col1=await detailWorksheet!.values.columnByKey(description);
      List<String>? col2=await detailWorksheet!.values.columnByKey("$description"+"_V");
      for(int i=0;i<col1!.length;i++)
      {
        if(col1[i].isNotEmpty)
          {
            listOfTotals.add({
              "rowNo":i+2,
              "description":col1[i],
              "total":col2![i],
            });
          }

      }
      return listOfTotals;
    }
    catch(e)
    {
      print("error at getRows details.dart$e");
      return [];
    }}

    Future addRow({required String des, required String val,required descript})async{
    //des is the cell value in string
      //val is cell value in dollars
      // descript is the dropdownvalue(categories) or column name
    try {
      await detailWorksheet!.values.columnIndexOf(descript).then((index) {
        //enter data in first cell, the string
          detailWorksheet!.values.appendRow([des],fromColumn: index,inRange: true).then((nothing){
          //enter data in second cell, the dollar value
            detailWorksheet!.values.appendRow([val],fromColumn: index+1,inRange: true).then((value){
              //sum up of all the dollars
              detailWorksheet!.values.columnByKey(descript+"_V").then((listOfColValues) {
                double sum=0;
                for (var element in listOfColValues!) {
                  if(element.isNotEmpty)
                    {
                      sum=sum+double.parse(element);
                    }

                }
                TotalFields().init().then((value){
                  value.totalWorksheet!.values.insertValueByKeys(sum, columnKey: "Total", rowKey: descript);
                });
              });
            });
          });
        });
      
      }
    catch(e)
      {
        print("error at addRow details.dart$e");
      }

    }

    Future<List<String>> getColumnNames()async
    {
      try{
        List<String> colNames=[];
        await detailWorksheet!.values.row(1).then((value)  {
          int a=1;
          value.forEach((element) {
            if(a%2!=0)
            {
              colNames.add(element);
            }
            a++;

          });
        });
        return colNames;
      }
      catch(e)
      {
        print("error at getColumnNames details.dart$e");
        return [];
      }


    }
  Future addColumns({required String colName}) async
  {
    try{
      TotalFields().init().then((value){
        value.totalWorksheet!.values.appendRow([colName,0],inRange: true);
      }).then((value) {
        detailWorksheet!.values.appendColumn([colName],inRange: true).then((value){
          detailWorksheet!.values.appendColumn([colName+"_V"]);
        });
      });
    }
    catch(e)
    {
      print("error at addColumns details.dart $e");
    }
  }
  Future deleteColumn({required String colName})async
  {
    await detailWorksheet!.values.columnIndexOf(colName).then((index) {
      detailWorksheet!.deleteColumn(index);
    });
  }
  
}