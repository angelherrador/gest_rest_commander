import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../functions/functions.dart';


class DishesPage extends StatefulWidget {
  const DishesPage({super.key,
    required this.idWaiter,
    required this.nameFamily,
    required this.idTable,
    required this.idFamily
  });

  final String idWaiter;
  final String nameFamily;
  final String idTable;
  final String idFamily;

  @override
  State<DishesPage> createState() => _DishesPageState();
}

class _DishesPageState extends State<DishesPage> {
  List list = [];
  String vApiUrl = "https://herradormartinez.es/gestrest/api_gestrest/dishes";
  String vImageUrl="https://herradormartinez.es/gestrest/images/dishes";

  Future readData(idFamily) async {
    var vFile="readData.php?idFamily=$idFamily";
    var url = "$vApiUrl/$vFile";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200){
      var redX = jsonDecode(res.body);

      setState(() {
        list.addAll(redX);
        _streamController.add(redX);
      });
    }
  }

  late StreamController<List<dynamic>> _streamController;
  late Stream<List<dynamic>> _stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _streamController = StreamController();
      _stream = _streamController.stream;
    });

    getData(widget.idFamily);
  }

  getData(idFamily) async {
    await readData(idFamily);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          title: Text(widget.nameFamily),
          centerTitle: true,
        ),
      body: Column(
        children: [
          const SizedBox(height: 5,),
          Expanded(
            //flex: 2,
            child: StreamBuilder<List<dynamic>>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // number of items in each row
                        mainAxisSpacing: 8.0, // spacing between rows
                        crossAxisSpacing: 8.0, // spacing between columns
                      ),
                      padding: const EdgeInsets.all(8.0), // padding around the grid
                      itemCount: snapshot.data!.length, //families.length, // total number of items
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              width: 120,
                              height: 100,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10.0),
                                  image:  DecorationImage(
                                    image: NetworkImage('$vImageUrl/${snapshot.data![index]['directory']}/${snapshot.data![index]['image']}'),
                                    fit: BoxFit.cover,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey, //Color(0xffA4A4A4),
                                      offset: Offset(1.0, 5.0),
                                      blurRadius: 3.0,
                                    ),
                                  ]),
                              child: InkWell(
                                onTap: () async {
                                    await addCommandDetail(widget.idTable, snapshot.data![index]['id']);
                                    final snackBar = SnackBar(
                                      content: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text('Añadido: ${snapshot.data![index]['name']}'),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.add_circle_outlined,
                                              color: Colors.white,
                                            ), onPressed: () {  },
                                          ),
                                        ],
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 1),
                                      showCloseIcon: true,
                                      width: 400,
                                    );
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  },
                              ),
                            ),
                            Text(snapshot.data![index]['name'], style: const TextStyle(color: Colors.white,
                              fontSize: 14, fontWeight: FontWeight.bold,)),
                          ],
                        );
                      },
                    );
                  }else if(snapshot.hasError){
                    return const Center(child: Text('Se ha producido un error. No hay datos disponibles !!!'));
                  }
                  return const Center(child: Text("Sin datos!!!"));
                  //return const Center(child: CircularProgressIndicator());
                }
            ),
          ),
        ],
      ),
    );
  }
}
