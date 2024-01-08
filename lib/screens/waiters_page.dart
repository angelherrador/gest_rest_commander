import 'package:flutter/material.dart';

class WaiterPage extends StatefulWidget {
  const WaiterPage({super.key});

  @override
  State<WaiterPage> createState() => _WaiterPageState();
}

class _WaiterPageState extends State<WaiterPage> {
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
