import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:shoopinglist/model/category.dart';


class CategoryProvider with ChangeNotifier{
  List<Category>categories=[];
  // final box=Hive.box<Category>("categories");

  late Box <Category>box;

  Future<void>initBox()async{
    box=await Hive.openBox<Category>("categories");
    // await Hive.box<Category>("categories").clear();
    print('Box is open');

    fetchItemFromHiveDB();
  }


  void fetchItemFromHiveDB(){
    categories=box.values.toList().reversed.toList();
    print("category${categories.length}");
    notifyListeners();
  }

  void addItem(Category category){

    box.add(category);
    categories.add(category);
    notifyListeners();
  }

  void deleteItem(int index){

    box.deleteAt(index);
    categories.removeAt(index);
    notifyListeners();
  }

  void updateItem(int index,Category category){
    box.putAt(index, category);
    categories[index]=category;
    notifyListeners();
  }
}
