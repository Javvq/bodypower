import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 


class DaysListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    DateTime today = DateTime.now();

 
 
    List<String> daysList = List.generate(16, (index) {
      DateTime date = today.add(Duration(days: index));
      return DateFormat('dd/MM/yyyy').format(date);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Días'),
      ),
      body: ListView.builder(
        itemCount: daysList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(daysList[index]),
          );
        },
      ),
    );
  }
}