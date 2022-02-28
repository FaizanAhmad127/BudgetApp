import 'package:budget_app/sheets/api/user_sheets_api.dart';
import 'package:gsheets/gsheets.dart';

class TotalFields{


   late final Worksheet? totalWorksheet;
   Future<TotalFields> init()async
   {
     return await UserSheetApi.init().then((value) {
       totalWorksheet=value[0];
       return this;
     });
   }

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
      print("error at GetRows totals.dart$e");
      return [];
    }
  }
  Future deleteRow(int rowNo) async{
     await totalWorksheet!.deleteRow(rowNo);
  }

}