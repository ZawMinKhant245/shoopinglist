import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shoopinglist/model/expense.dart';
import 'package:shoopinglist/provider/category_provider.dart';
import 'package:shoopinglist/provider/expense_provider.dart';

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


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 92, 117, 209),
        title: Text('Voucher'),
        actions: [
          TextButton(onPressed: (){}, child: Text('Print',style: TextStyle(color: Colors.white),))
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
              return Column(
                children:[
                  SizedBox(height: 10,),
                  Image.asset('assets/img_1.png',width: 80,),
                  Text('Voucher of ${widget.name}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  ListTile(
                    dense: true,
                    visualDensity: VisualDensity(vertical: -4),
                    title:Text('Print Date'),
                    trailing: Text(printDate,style: TextStyle(fontSize: 15),),
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
