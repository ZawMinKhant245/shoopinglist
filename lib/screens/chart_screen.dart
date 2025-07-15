import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoopinglist/provider/expense_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class ChartData{
  String label;
  int amount;
  ChartData({required this.label,required this.amount});
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ExpenseProvider>(
          builder: (context,provider,child){
            return SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
              ),
              primaryYAxis:CategoryAxis(
                 labelStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)
              ),
              title: ChartTitle(
                text: 'DashBoard'
              ),
            );
          }
      ),
    );
  }
}
