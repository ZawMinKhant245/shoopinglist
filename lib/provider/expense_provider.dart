import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:shoopinglist/model/expense.dart';

class ExpenseProvider with ChangeNotifier{

  late Box<Expense> box;
  List<Expense>expenses=[];

  void saveToBox() {
    final box = Hive.box<Expense>('expenses');
    box.clear(); // Clear old data
    for (var exp in expenses) {
      box.add(exp);
    }
  }
  Future<void> initBox() async {
    box = await Hive.openBox<Expense>('expenses');
    // await Hive.box<Expense>('expenses').clear();
    print('box is open');
    fetchAllExpense();
  }

  void fetchAllExpense(){
    expenses=box.values.toList().reversed.toList();
    print('expense list: ${expenses.length}');
    // box.clear();
    notifyListeners();
  }
  


  String getAllListAmount(){
    int total=0;
    DateTime today=DateTime.now();
    for(Expense e in expenses){
      total += e.amount!;
    }
    return '$total';
  }

  void addCategory(Expense exp){
    box.add(exp);
    expenses.insert(0, exp);
    notifyListeners();
  }

  void deleteCategory(int index){
    box.deleteAt(index);
    expenses.removeAt(index);
    notifyListeners();
  }

  void updateCategory(int index,Expense exp){
    box.putAt(index, exp);
    expenses[index]=exp;
    notifyListeners();
  }



}