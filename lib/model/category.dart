import 'package:hive/hive.dart';
import 'package:shoopinglist/model/expense.dart';
part 'category.g.dart';

@HiveType(typeId: 0)
class Category extends HiveObject{

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime? date;

  Category({required this.id,required this.name,this.date,});
}