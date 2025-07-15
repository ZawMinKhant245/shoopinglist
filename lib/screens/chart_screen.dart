import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoopinglist/model/expense.dart';
import 'package:shoopinglist/provider/category_provider.dart';
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

  Map<String, int> totalAmount() {
    final provider   = Provider.of<ExpenseProvider>(context, listen: false);

    final Map<String, int> data = {};

    Set<String> setName=provider.expenses.map((e)=>e.category).toSet();
    for(String cat in setName){

      int total=0;
     List<Expense>filterExpense= provider.expenses.where((c)=>c.category ==cat).toList();
     for(Expense fe in filterExpense){
       if(fe.isBought){
         total += fe.amount!;
       }
     }
     data[cat]=total;
    }

    return data;
  }
  Widget build(BuildContext context) {

    print(totalAmount());
    Map<String,int>data=totalAmount();
    List<ChartData>chartData=data.entries.map((e)=>ChartData(label: e.key, amount: e.value)).toList();
    return Scaffold(
      body: Consumer<ExpenseProvider>(
          builder: (context,provider,child){
            if(provider.expenses.isEmpty){
              return Center(child: Text('No Shopping list'));
            }else{
              return SizedBox(
                width: 600,
                child:  SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      labelStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                    ),
                    primaryYAxis:NumericAxis(
                        labelStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)
                    ),
                    title: ChartTitle(
                        text: 'DashBoard',
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        )
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: [
                      ColumnSeries<ChartData,dynamic>(
                          dataSource: chartData,
                          xValueMapper: (chartData,_)=>chartData.label,
                          yValueMapper:(chartData,_)=>chartData.amount,
                        pointColorMapper: (chartData,_){
                          Random random=Random();
                          return Color.fromRGBO(
                            random.nextInt(256),
                            random.nextInt(256),
                            random.nextInt(256),
                            1,
                          );
                        },
                        borderRadius: BorderRadius.only(topRight: Radius.circular(5),topLeft: Radius.circular(5)),
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ),
                    ],
                  ),
              );
            }

          }
      ),
    );
  }
}
