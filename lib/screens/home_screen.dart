import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoopinglist/provider/category_provider.dart';
import 'package:shoopinglist/provider/expense_provider.dart';
import 'package:shoopinglist/screens/category_screen.dart';
import 'package:shoopinglist/screens/chart_screen.dart';
import 'package:shoopinglist/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   int currentIndex=0;
  List<Widget>currentWidget=[
    CategoryScreen(),
    ChartScreen(),
  ];
  List<String>appBarTitle=['Total Expense','Analysis DashBoard '];

   String totalAmount(int index){
     final provider=Provider.of<ExpenseProvider>(context,listen: false);
     final cProvider=Provider.of<CategoryProvider>(context,listen: false);

     String name=cProvider.categories[index].name;

     final categoryExpense= provider.expenses
         .where((e)=>e.category == name)
         .toList();
     int amount =0;
     for(int i=0;i<categoryExpense.length;i++){
       amount += categoryExpense[i].amount!;
     }

     return '$amount';
   }

  Widget buildDrawerCard(){
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.camera_alt),
              ),
              accountName:Text('ME') ,
              accountEmail: Text('me@gamil.com')
          ),
          Expanded(child: Column(
            children: [
              Text('Voucher')
            ],
          )),
          Divider(),
           ListTile(
             onTap: (){
               showDialog(context: context, builder: (context)=>AlertDialog(
                 title: Text('Alert Dialog'),
                 content: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Text('Are you sure to Sign Out'),
                     OverflowBar(
                       children: [
                         TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('No')),
                         TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('Yes')),
                       ],)
                   ],
                 ),
               ));
             },
              title: Text('Sign Out'),
              trailing: Icon(Icons.logout),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawerCard(),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 92, 117, 209),
        title: Text(appBarTitle[currentIndex],style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Text(
              '0 B',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),
            ),
          )
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: currentWidget[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
          onTap: (index){
          setState(() {
            currentIndex =index;
          });
          },
          selectedItemColor: Colors.red,
          items:[
            BottomNavigationBarItem(icon: Icon(Icons.library_books_outlined),label: 'list'),
            BottomNavigationBarItem(icon: Icon(Icons.pie_chart),label: 'chart'),
            ]
      ),
    );
  }
}
