import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shoopinglist/model/expense.dart';
import 'package:shoopinglist/provider/category_provider.dart';
import 'package:shoopinglist/provider/expense_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({required this.name,super.key});

  final name;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {


  String totalAmount(){
    final provider=Provider.of<ExpenseProvider>(context,listen: true);
    Provider.of<CategoryProvider>(context,listen: false);
    int amount =0;
    // provider.expenses[index].isBought;
    final categoryExpense= provider.expenses
        .where((e)=>e.category == widget.name)
        .toList();
    for(int i=0;i<categoryExpense.length;i++){
      if(categoryExpense[i].isBought){
        amount += categoryExpense[i].amount!;
      }
    }
    return '$amount';
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   Provider.of<CategoryProvider>(context,listen: false).initBox();
  // }


  Future<void>_printVoucher(List<Expense>expense)async{
    final pdf=pw.Document();
    final todayDate=DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayTime=DateFormat('HH:mm:ss').format(DateTime.now());

    final iamgebyte= await rootBundle.load('assets/img_2.png');
    final image=pw.MemoryImage(iamgebyte.buffer.asUint8List());

    final fontData = await rootBundle.load('assets/fonts/NotoSansMyanmar-Regular.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    pdf.addPage(
      pw.Page(build: (pw.Context context){
        return pw.Column(
          children:[
            pw.Text('Voucher',style: pw.TextStyle(
                fontSize: 20, fontWeight: pw.FontWeight.bold,
            )),
            pw.SizedBox(height: 20),
            pw.Row(
              children: [
                pw.Text('Print Date: $todayDate'),
                pw.SizedBox(width: 20),
                pw.Text('Time: $todayTime'),
              ]
            ),
            pw.Divider(),
            
            pw.ListView.builder(
                itemBuilder:(context,index){
                  final item=expense[index];
                  return pw.Container(
                    padding: const pw.EdgeInsets.symmetric(vertical: 4),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(color: PdfColors.grey, width: 0.5),
                      ),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(item.name ?? 'Unnamed',style: pw.TextStyle(font: ttf)),
                        pw.Text('${item.amount ?? 0} B'),
                      ],
                    ),
                  );
                },
                itemCount: expense.length
            ),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total:'),
                pw.Text(
                  '${expense.fold<int>(0, (sum, item) => sum + (item.amount ?? 0))} B',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.SizedBox(height: 20,),
            pw.Image(image,width: 80),
            pw.SizedBox(height: 10,),
            pw.Text('Thank You',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 24)),
          ]
        );
      })
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 92, 117, 209),
        title: Text('Voucher'),
        actions: [
          TextButton(onPressed: (){
            final provider=Provider.of<ExpenseProvider>(context,listen: false);
            final categoryExpense=provider.expenses
            .where((e)=> e.category == widget.name && e.isBought).toList();
            _printVoucher(categoryExpense);
          }, child: Text('Print',style: TextStyle(color: Colors.white),))
        ],
      ),
      body: FutureBuilder(
          future:Provider.of<ExpenseProvider>(context,listen: false).initBox(),
          builder: (context,snapShoot){
            if(snapShoot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }else{

              DateTime today= DateTime.now();
              String printDate=DateFormat('yyyy-MM-dd').format(today);
              String printTime=DateFormat('HH:mm:ss').format(today);
              return Column(
                children:[
                  SizedBox(height: 10,),
                  Image.asset('assets/img_1.png',width: 80,),
                  SizedBox(height: 10,),
                  Text('Voucher of ${widget.name}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 10),
                   child: Row(
                     children: [
                       Expanded(flex: 2,
                         child: Row(
                           children: [
                             Text('Date - '),
                             Text(printDate),
                           ],
                         ),
                       ),
                       SizedBox(width: 20,),
                       Expanded(

                         child: Row(
                           children: [
                             Text('Time - '),
                             Text(printTime),
                           ],
                         ),
                       )


                     ],
                   ),
                 ),
                  ListTile(
                    dense: true,
                    visualDensity: VisualDensity(vertical: -4),
                    title:Text('Items',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                    trailing: Text('Amount',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                  ),
                  Expanded(
                child: Consumer<ExpenseProvider>(
                    builder: (context,provider,child){
                      final categoryExpense= provider.expenses
                          .where((e)=>e.category == widget.name && e.isBought)
                          .toList();
                      return ListView.builder(
                          itemCount: categoryExpense.length,
                          itemBuilder: (context,index){
                            bool isChecked=categoryExpense[index].isBought;
                            final exp=categoryExpense[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey, // Set your border color
                                      width: 1.0,         // Set your border width
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  title: isChecked ? Text('${exp.name} ') : Center(child: Text('Please select the items')),
                                  trailing: isChecked ? Text('${exp.amount} B'):Text('Please select the items'),
                                ),
                              ),
                            );
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListTile(
                      tileColor:  Color.fromARGB(255, 216, 206, 206),
                      title: Text('Total',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                      trailing: Text('${totalAmount()} B',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                    ),
                  ),
                ]

              );
            }
          }
      ),
    );
  }
}
