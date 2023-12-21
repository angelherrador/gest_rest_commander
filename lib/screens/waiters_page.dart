import 'package:flutter/material.dart';

class WaiterPage extends StatelessWidget {
  const WaiterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text('Selección de camarero'),
          centerTitle: true,
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              Text('Escribe tu password y clica en la imagen correspondiente'),
            ],
          ),
        ));
  }
}
