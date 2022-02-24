import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';

class DetailsField{
  final Worksheet? detailWorksheet;
  final String description;
  DetailsField({required this.detailWorksheet,required this.description});

  Future<List<Map<String,dynamic>>> getRows()async
  {
    try{
      print("getting rows");
      List<Map<String,dynamic>> listOfTotals=[];
      List<String>? col1=await detailWorksheet!.values.columnByKey(description);
      List<String>? col2=await detailWorksheet!.values.columnByKey("$description"+"_V");
      print(col2);
      for(int i=0;i<col1!.length;i++)
      {
        listOfTotals.add({
          "rowNo":i+2,
          "description":col1[i],
          "total":col2![i],
        });
      }
      return listOfTotals;
    }
    catch(e)
    {
      print("error $e");
      return [];
    }}

    Future addRow({required String des, required String val,required descript})async{
    try {
      await detailWorksheet!.values.columnByKey(descript).then((value)  {
        int lastRowNo=value!.length+1;
        detailWorksheet!.values.columnIndexOf(descript).then((index) {
          detailWorksheet!.values.appendRow([des],fromColumn: index,inRange: true).then((nothing){
            detailWorksheet!.values.appendRow([val],fromColumn: index+1,inRange: true);
          });
        });
      });
      }
    catch(e)
      {
        print("error $e");
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
        print("error $e");
        return [];
      }


    }
}