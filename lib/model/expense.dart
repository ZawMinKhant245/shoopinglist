import 'package:hive/hive.dart';
part 'expense.g.dart';

@HiveType(typeId: 1)
class Expense extends HiveObject{

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int? amount;

  @HiveField(3)
  bool isBought;

  @HiveField(4)
  String? note;

  @HiveField(5)
  String category;

  Expense({
    required this.id,
    required this.name,
    this.amount=0,
    this.isBought = false,
    this.note,
    required this.category,
  });
}