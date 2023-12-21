import 'package:flutter/material.dart';

class TablePage extends StatelessWidget {
  const TablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text('Selección de mesa'),
          centerTitle: true,
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              Text('Selecciona la mesa a atender'),
            ],
          ),
        ));
  }
}
