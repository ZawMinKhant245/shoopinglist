import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shoopinglist/model/category.dart';
import 'package:shoopinglist/provider/category_provider.dart';
import 'package:shoopinglist/provider/expense_provider.dart';
import 'package:shoopinglist/screens/add_shopping_list_details.dart';
import 'package:uuid/uuid.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {


  final categoryController=TextEditingController();
  List<CheckboxListTile>addNewCheckList=[];
  void buildDialog({bool isUpdate= false,int? index,Category? category}){
    if(isUpdate == true){
      categoryController.text=category!.name;
    }
     showDialog(
         context: context,
         builder: (context){
           return Dialog(
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                    Text(isUpdate ? 'Update list name':'New Shopping List',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                   const SizedBox(height: 10,),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: TextFormField(
                       controller: categoryController,
                       keyboardType: TextInputType.name,
                       decoration: const InputDecoration(
                         hintText: 'Add here',
                         border: OutlineInputBorder()
                       ),
                     ),
                   ),
                   const SizedBox(height: 10,),
                   ElevatedButton(
                       onPressed: (){
                         Uuid uuid=const Uuid();
                         DateTime now=DateTime.now();
                         DateTime today=DateTime(now.year,now.month,now.day,now.hour,now.minute,now.second);

                         if(categoryController.text.isNotEmpty){

                           if(isUpdate){
                             category!.name=categoryController.text.trim();
                             Provider.of<CategoryProvider>(context,listen: false).updateItem(index!, category);
                           }else{
                             Provider.of<CategoryProvider>(context,listen: false).addItem(
                                 Category(id:uuid.v1(), name: categoryController.text.trim(),date:today)
                             );
                           }
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text(isUpdate ? 'List name updated': 'List added successfully!!'))
                           );
                         }
                         categoryController.clear();
                         Navigator.of(context).pop();
                       },
                       child: Text(isUpdate?'Update':'Save'),
                       style: ElevatedButton.styleFrom(
                           minimumSize: Size(120, 40),
                           backgroundColor: Colors.white70,
                           foregroundColor: Colors.black,
                           shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                       )
                   ),
                 ],
               ),
             ),
           );
     }
     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:FutureBuilder(
          future: Provider.of<CategoryProvider>(context,listen: false).initBox(),
          builder: (context,snapShoot){
            if (snapShoot.connectionState == ConnectionState.waiting) {
              return Center(child:Text('No shopping list'));
            }else{
              Provider.of<ExpenseProvider>(context,listen: false).initBox();
              return Consumer<CategoryProvider>(
                  builder:(context,provider,child){
                   return ListView.builder(
                     itemCount: provider.categories.length,
                       itemBuilder: (context,index){
                         return Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                           child: InkWell(
                             splashColor: Colors.black12,
                             onLongPress: (){

                               buildDialog(isUpdate: true,index: index,category: provider.categories[index]);
                               },
                             onTap: (){
                               String name=provider.categories[index].name;
                               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddShoppingListDetails(name: name,)));
                             },
                             child: Card(
                               color: Color.fromARGB(255, 216, 206, 206),
                               child: ListTile(
                                 title:Text('List of ${provider.categories[index].name}'),
                                 subtitle: Text(DateFormat('yyyy-MM-dd').format(provider.categories[index].date!)),
                                 trailing: IconButton(onPressed: (){
                                   final name=provider.categories[index].name;
                                   Provider.of<CategoryProvider>(context,listen: false).deleteItem(index);
                                   final providerExpense=Provider.of<ExpenseProvider>(context,listen: false);
                                   providerExpense.expenses.removeWhere((e)=>e.category == name);
                                   providerExpense.deleteCategory(index);
                                 }, icon: Icon(Icons.delete)),
                               ),
                             ),
                           ),
                         );
                         
                       }
                   );
              }
              );
            }
          }
      ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 92, 117, 209),
              onPressed: (){
                buildDialog();
              },
            child: Icon(Icons.add,),
          ),
    );
  }
}
