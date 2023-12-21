import 'package:flutter/material.dart';

class ZonePage extends StatelessWidget {
  const ZonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text('Selección de Sala'),
          centerTitle: true,
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              Text('Selecciona la Sala'),
            ],
          ),
        ));
  }
}
