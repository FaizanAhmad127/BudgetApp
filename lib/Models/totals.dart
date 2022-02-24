import 'package:gsheets/gsheets.dart';

class TotalFields{


   final Worksheet? totalWorksheet;
  TotalFields({required this.totalWorksheet});

  Future<List<Map<String, dynamic>>> getRows()async
  {
    try{
      List<Map<String,dynamic>> listOfTotals=[];
      int rowNo=1;
      await totalWorksheet!.values.allRows(fromRow: 2).then((value) {
        value.forEach((element) {
          listOfTotals.add({
            "rowNo":++rowNo,
            "description":element[0],
            "total":double.parse(element[1]),
          });
        });
      });
      return listOfTotals;
    }
    catch(e){
      print("error $e");
      return [];
    }


  }

}