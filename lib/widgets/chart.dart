import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTansactionValue {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'price': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTansactionValue.fold(0.0, (sum, item) {
      return sum + (item['price'] as num);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTansactionValue);
    return Card(
      margin: const EdgeInsets.all(25),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTansactionValue.map((data) {
            return Expanded(
              child: ChartBar(
                data['day'].toString(),
                data['price'] as double,
                totalSpending == 0.0
                    ? 0.0
                    : (data['price'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
