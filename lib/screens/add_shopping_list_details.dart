import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoopinglist/model/expense.dart';
import 'package:shoopinglist/provider/category_provider.dart';
import 'package:shoopinglist/provider/expense_provider.dart';
import 'package:shoopinglist/screens/settings_screen.dart';
import 'package:uuid/uuid.dart';

class AddShoppingListDetails extends StatefulWidget {
  const AddShoppingListDetails({required this.name,super.key});
  final String name;
  @override
  State<AddShoppingListDetails> createState() => _AddShoppingListDetailsState();
}

class _AddShoppingListDetailsState extends State<AddShoppingListDetails> {

  final itemController=TextEditingController();
  final amountController=TextEditingController();
  final _keys=GlobalKey<FormState>();


  void buildDialog({bool isUpdate=false,int? index,Expense? expense}){
    if(isUpdate){
      itemController.text=expense!.name;
      // amountController.text=expense.amount;
    }
    showDialog(context: context, builder: (context){
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _keys,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isUpdate?'Update Item':'Set Item',style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold),),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: itemController,
                          validator: (val){
                            return val==null || val.isEmpty ?'enter item':null;
                          },
                          decoration: InputDecoration(
                            hintText: 'enter item',
                            border: OutlineInputBorder()
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          validator: (val){
                            return val==null || val.isEmpty ?'enter amount':null;
                          },
                          decoration: InputDecoration(
                              hintText: 'amount',
                            border: OutlineInputBorder()
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                ElevatedButton(onPressed: (){
                  Provider.of<ExpenseProvider>(context,listen: false).initBox();
                  if(_keys.currentState!.validate()){
                    Uuid uuid=Uuid();
                    DateTime now=DateTime.now();
                    DateTime today=DateTime(now.year,now.month,now.day,);
                    int amount=int.parse(amountController.text.trim());

                    if(itemController.text.isNotEmpty){

                      if(isUpdate){
                        expense!.name=itemController.text.trim();
                        expense.name=itemController.text.trim();
                        Provider.of<ExpenseProvider>(context,listen: false).updateCategory(index!, expense);
                      }else{
                        Provider.of<ExpenseProvider>(context,listen: false).addCategory(
                            Expense(id: uuid.v4(), name: itemController.text.trim(),amount:amount, category: widget.name)
                        );
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(isUpdate ?'Updated':'Added'))
                      );
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('no added'))
                      );
                    }

                    itemController.clear();
                    amountController.clear();
                    Navigator.of(context).pop();
                  }
                }, child: Text(isUpdate?'Update':'save'))
              ],
            ),
          ),
        ),
      );
    });
  }

  void buildAlertDialog({required int index}){
    showDialog(context: context, builder: (context){
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _keys,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Alert Dialog',style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold),),
                SizedBox(height: 5,),
                Text('Click To Voucher',style: TextStyle(fontSize: 15),),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                ),
                SizedBox(height: 5,),
                ElevatedButton(onPressed: (){
                      final provider=Provider.of<ExpenseProvider>(context,listen: false);
                      final categoryExpense= provider.expenses
                          .where((e)=>e.category == widget.name && e.isBought)
                          .toList();
                      if(categoryExpense.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select the items to print'))
                        );
                         Navigator.of(context).pop();
                      }else{
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SettingsScreen(name: widget.name,)));
                      }


                      // Navigator.of(context).pop();

                    }, child: Text('Voucher')),
              ],
            ),
          ),
        ),
      );
    });
  }


  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initBoxAsync();
  }

  Future<void> _initBoxAsync() async {
    await Provider.of<ExpenseProvider>(context, listen: false).initBox();
    await Provider.of<CategoryProvider>(context, listen: false).initBox();
    
    // provider.categories[0].name == widget.name;
    // print(provider.categories[0].name == widget.name);
     // Init checklist state
  }

  String totalAmount(){
    final provider=Provider.of<ExpenseProvider>(context,listen: true);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 92, 117, 209),
        title: Text('${widget.name} cost'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Text('${totalAmount()} B',
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
          )

      ]),
      body:Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          final categoryExpense= provider.expenses
              .where((e)=>e.category == widget.name)
          .toList();
      if (categoryExpense.isEmpty) {
        return Center(child: Text('No items found'));
      }
      return ListView.builder(
        itemCount: categoryExpense.length,
        itemBuilder: (context, index) {
          final exp=categoryExpense[index];
          return Padding(
            padding: const EdgeInsets.only(top: 10,left: 10,right: 10),
            child: InkWell(
              onTap: (){
                buildDialog(isUpdate: true,index: index,expense: provider.expenses[index]);
              },
              onLongPress: (){
                buildAlertDialog(index: index);
              },
              child: Card(
                color: exp.isBought
                    ? Color.fromARGB(255, 216, 206, 206)
                    : Color.fromARGB(255, 216, 206, 206),
                child:  ListTile(
                  leading: Checkbox(
                    value: exp.isBought,
                    onChanged: (val) {
                      setState(() {
                        exp.isBought = val!;
                        exp.save();
                      });
                    },
                  ),
                  title: Text(
                    exp.name,
                    style: TextStyle(
                      decoration: exp.isBought
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontWeight:
                      exp.isBought ? FontWeight.w500 : FontWeight.normal,
                      color:exp.isBought ? Colors.grey : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    '${exp.amount} B',
                    style: TextStyle(
                      decoration: exp.isBought
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontWeight:
                      exp.isBought ? FontWeight.w500 : FontWeight.bold,
                      color:exp.isBought ? Colors.grey : Colors.black,
                    ),
                  ),
                  trailing: IconButton(onPressed: (){
                    Provider.of<ExpenseProvider>(context,listen: false).deleteCategory(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Item deleted'))
                    );
                  }, icon: Icon(Icons.delete)),
                  
                ),
              ),
            ),
          );
        },
      );
    },
    ),


    floatingActionButton: FloatingActionButton(
      backgroundColor: Color.fromARGB(255, 92, 117, 209),
        onPressed: (){
          buildDialog();
        },child: Icon(Icons.add),

      ),
    );
  }
}
