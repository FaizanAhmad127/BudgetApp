import 'package:budget_app/Models/totals.dart';
import 'package:gsheets/gsheets.dart';

class UserSheetApi
{
  static const _credentials=r'''
  {
  "type": "service_account",
  "project_id": "budgetappgsheet",
  "private_key_id": "bfe0ca555cc24ad95103c2586589d9762cdbbdee",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDLFMKDcHa3G/RU\na/nZRBuBrYjE8NxrX+KjLl/ul++hKTqPQJfeLCEKuxbDiDKE7vtvhCMvtjRXlcs5\nR6nWPzmg08pihHLSVSO6BwUjGsYfgzfGvJK2ZeWq+dCWlWGcA6A7gx0RMC5qFTo2\nQgOD6hAIcx9bHz3UOWRz3fCqPC4VCNALu2XTS3BvOG3oH3HxuVP4Iw4E1vJ5ylgQ\n3xcmj8uHjCrmgFwGDY+5QRqv2unWZHztipEZhI0sywfgIuEQ+z1Y+tR+wo8R5cTd\npEbOkKmCp4R8sjzaTuDxZyohja6/4eCnd7HDotamSwTBILsV88vT6BPIPLA7FCzW\nlyLS3VNdAgMBAAECggEASkhZrgJhKjFLeeXVCifjd9emA4Om3I/CMrYv2PIycNzH\n0sZpxpaVr3snpHYZJI7V4cCPrlATbUYZg+Y2tWuDBNTzXn3cEhuaad1Pf7u3ZKd2\nq3cmoxk6nQOrzKjvf0XEQoB/DV52W89P77DN4F6pZq3VdltDHnGv0MIJ2fsRUBe2\nTGxICZ/7g+0GG38loi9kirqFZLg20vTMFLGmkZI1caN2MNBRAFYQMGNLieArL5AQ\nfnikFU3H49IszhfdxttsNFGAgCt2lAWy80V1utxRyM5FSHdD57nWvv+IDLa3/Rct\nBdrzsJcYVwpsiKv24iKw930m8ZX+Wh/rPdylnZOVcQKBgQDoRf/VmEpbtWCSs9NH\nnMCr5k2+f/Em683cBmUnc9csJiI6lbriNIoYDtlz2d1GcKw6ln+D3HgZmpjEcXWR\nUBOjTz3nVGPNldQYfS8C/eRnSkxRdO6BgzW2XfIWCd7wCLYVW/g0sayBiQ22HNzH\nW3jHcvwXk6yi9E0KTdCjSFXzswKBgQDf01/YnVZfptQeQ32/RSe+Y0LKrc2Jeyb/\na8QZnIATki+3zHOclSpFECk+Ya1G9jHqRjNkOzEh1lmOT746iX0Tp5mXVIgeZgY8\nfe2WK0ughrKeIlQRIDBgsFoicVCiDgXL7LXZpEd74MQgAUECZoaaVTzSUFxzc/2K\nh6p7VMdUrwKBgQDcNYkgQtq0aZgeXZiAe097acPpSLkjkknAQNvj9IJaW+j1rADa\n9r65olJs8G9FmgrfHNHV/M5sT9Jn4713v/huSvFAgRSB03uaoAxTBMxnVNxYGckJ\nRpFEzXp3hHI1Fb0zMNd3db87q+kw79ossz8lsJDp9Vqlv4HOtAmK1EiQ2wKBgQCF\nX2MhpL+vR63mSrlHnGHOZT+Lnn13itb2JLU5vbPj9ZxRnZbWm1wQw0yQS4wBWPrt\nat98vnjMfPnof0QPhZXufFRdhJWH56uXqEJG1Y2/HgSZjkMh4VhyhSNwmq09o7V4\nipjiE6409v5nQ9gFIirbFCel+xTcByXxwl2oGCCfKQKBgDFpbkxns8Mq2zkM8bml\neaIEu/Zs5xL73ZiopHyHcNHbFeMXKKVETcb52mJw5Sov05uYqLpMMcVqG18KjWkL\nAI3DMnoXdY1Me3mGY+gXTw3nWN4YvOpWZjT4MoQTlsm0Uoc88od1eW7tY3oJQfMN\n0aUetLDBWZ8kND/Dnir3V4Hb\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheet@budgetappgsheet.iam.gserviceaccount.com",
  "client_id": "103432454506527468777",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheet%40budgetappgsheet.iam.gserviceaccount.com"
}
  
  ''';
  static const _spreadsheetId='1zPWEQllurGMo5dvRAS-SfOVixRnkCrDhVSlgLDEJA1E';
   static final _gsheets=GSheets(_credentials);
   static Worksheet? _totalSheet;
  static Worksheet? _detailsSheet;

   static Future<List<Worksheet?>> init() async{
     try{
       final spreedsheet=await _gsheets.spreadsheet(_spreadsheetId);
       _totalSheet=await _getWorkSheet(spreedsheet, title:'Totals');
       _detailsSheet=await _getWorkSheet(spreedsheet, title:'Details');
       if(_totalSheet==null || _detailsSheet==null)
         {
           return [];
         }
       else
         {
           return [_totalSheet,_detailsSheet];
         }
       return [_totalSheet,_detailsSheet];
       //retrieve first row which is the name of columns
       // final totalFirstRow=TotalFields.getFields();
       // _totalSheet!.values.insertRow(1, totalFirstRow);
     }
     catch(e)
     {
       return [];
       print("error $e");
     }


   }
   static Future<Worksheet?> _getWorkSheet(
       Spreadsheet spreadsheet,{
         required String title,}) async {
     try
     {
       return await spreadsheet.addWorksheet(title);
     }
     catch(e)
     {
       return await spreadsheet.worksheetByTitle(title);
     }
   }





}