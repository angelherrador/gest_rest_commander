import 'package:flutter/material.dart';
import 'package:gest_rest/screens/command_page.dart';
import 'dishes_page.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key, required this.idWaiter, required this.idTable});

  final String idWaiter;
  final String idTable;

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {

  List listFavorites = [];
  List listFamilies = [];
  String vApiUrlFavorites = "https://herradormartinez.es/gestrest/api_gestrest/dishes";
  String vImageUrl="https://herradormartinez.es/gestrest/images/dishes";

  String vApiUrlFamilies = "https://herradormartinez.es/gestrest/api_gestrest/families";

  Future readDataFavorites() async {
    var vFile="readDataFavorites.php";
    var url = "$vApiUrlFavorites/$vFile";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200){
      var redX = jsonDecode(res.body);

      setState(() {
        listFavorites.addAll(redX);
        _streamController.add(redX);
      });
      print(listFavorites);
    }
  }
  Future readDataFamilies() async {
    var vFile="readData.php";
    var url = "$vApiUrlFamilies/$vFile";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200){
      var redX = jsonDecode(res.body);

      setState(() {
        listFamilies.addAll(redX);
        _streamControllerFamilies.add(redX);
      });
      print(listFamilies);
    }
  }

  late StreamController<List<dynamic>> _streamController;
  late Stream<List<dynamic>> _stream;

  late StreamController<List<dynamic>> _streamControllerFamilies;
  late Stream<List<dynamic>> _streamFamilies;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _streamController = StreamController();
      _stream = _streamController.stream;

      _streamControllerFamilies = StreamController();
      _streamFamilies = _streamControllerFamilies.stream;
    });

    //getData(widget.idRoom);
    getDataFavorites();
    getDataFamilies();
  }


  getDataFavorites() async {
    await readDataFavorites();
  }

  getDataFamilies() async {
    await readDataFamilies();
  }

  @override
  Widget build(BuildContext context) {

    Widget listFavorites = SizedBox(
      height: 80,
      child: StreamBuilder<List<dynamic>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              // This next line does the trick.
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
              //children: <Widget>[
                return
                  _buildFavorites(snapshot.data![index]['name'],
                    '$vImageUrl/${snapshot.data![index]['directory']}/${snapshot.data![index]['image']}');
              },
            );
          }else if(snapshot.hasError){
            return const Center(child: Text('Se ha producido un error. No hay datos disponibles !!!'));
          }
          return const Center(child: Text('Sin Favoritos!!'));
        } //builder
      ),
    );

    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      appBar: AppBar(
        title: Text('Favoritos / Familias ${widget.idWaiter} - ${widget.idTable}'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          listFavorites,
          const SizedBox(height: 5,),
          Expanded(
            //flex: 2,
            child: StreamBuilder<List<dynamic>>(
              stream: _streamFamilies,
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
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DishesPage(
                                                idWaiter : widget.idWaiter,
                                                idTable: widget.idTable,
                                                idFamily: snapshot.data![index]['id'],
                                                nameFamily: snapshot.data![index]['name'],
                                            )));
                              },
                            ),
                          ),
                          Text(snapshot.data![index]['name'],),
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
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }
}

Builder _buildFavorites(String label, String favoriteImage) {
  return Builder(builder: (context) {
    return Container(
      margin: const EdgeInsets.only(right: 5.0),
      width: 100,
      height: 80,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: NetworkImage(favoriteImage),
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
        onTap: ()  {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CommandPage()));
        },
      ),
    );
  });
}
