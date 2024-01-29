import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


String vPrincipalUrl = 'https://herradormartinez.es/gestrest';
String vApiUrlP = '$vPrincipalUrl/api_gestrest';
String vApiUrlI = '$vPrincipalUrl/images';

Future addCommandDetail(tableNumber,idDish) async{
  String vApiUrl = '$vApiUrlP/commander';
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

class PrettySnackBar {
  final String message;

  const PrettySnackBar({
    required this.message,
  });

  static show(
      BuildContext context,
      String message,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0.0,
        //behavior: SnackBarBehavior.floating,
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        width: 400,
        duration: const Duration(seconds: 2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        backgroundColor: Colors.redAccent,
        // action: SnackBarAction(
        //   textColor: const Color(0xFFFAF2FB),
        //   label: 'OK',
        //   onPressed: () {},
        // ),
      ),
    );
  }
}
