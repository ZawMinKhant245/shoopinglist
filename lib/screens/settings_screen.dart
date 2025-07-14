import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoopinglist/model/expense.dart';
import 'package:shoopinglist/provider/expense_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({required this.name,super.key});

  final name;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 92, 117, 209),
        title: Text('Voucher'),
      ),
      body: FutureBuilder(
          future:Provider.of<ExpenseProvider>(context,listen: false).initBox(),
          builder: (context,snapShoot){
            if(snapShoot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }else{
              return Column(
                children:[
                  Image.asset('assets/img.png',width: 150,),
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
                                      title: isChecked ? Text('${exp.name} ') : Text('Please select the items'),
                                      trailing: isChecked ? Text('${exp.amount} B'):Text('Please select the items'),
                                    ),
                                  ),
                                );
                              }
                          );
                        }),
                  ),
                ]

              );
            }
          }
      ),
    );
  }
}
