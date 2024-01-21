import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

Future addCommandDetail(tableNumber,idDish) async{
  String vApiUrl = "https://herradormartinez.es/gestrest/api_gestrest/commander";
  var vFile="addCommandDetail.php";
  var url = "$vApiUrl/$vFile";
  await http.post(Uri.parse(url), body: {
    'tableNumber': tableNumber,
    'idDish': idDish,
  });
}



class CommonBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CommonBottomNavigationBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.stay_primary_landscape),
          label: 'Salas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.table_restaurant_sharp),
          label: 'Mesas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_rounded),
          label: 'Comanda',
        ),

      ],
    );
  }
}
