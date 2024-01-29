import 'dart:async';
import 'dart:convert';
import 'onboarding_page.dart';
import 'room_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../functions/functions.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
import 'dishes_crud.dart';

class WaiterPage extends StatefulWidget {
   const WaiterPage({super.key});

   @override
  State<WaiterPage> createState() => _WaiterPageState();
}

class _WaiterPageState extends State<WaiterPage> {

  String password="";
  String passMask="";

  List list = [];
  String vApiUrl = '$vApiUrlP/waiters';
  String vImageUrl='$vApiUrlI/waiters';


  Future readData() async {
    var vFile="readData.php";
    var url = "$vApiUrl/$vFile";
    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200){
      var redX = jsonDecode(res.body);

      setState(() {
        list.addAll(redX);
        _streamController.add(redX);
      });
      //print(list);
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

    getData();
  }

  getData() async {
    await readData();
  }

  onKeyboardTap(String value) {
    setState(() {
      password = password + value;
      passMask = '$passMask*';
    });
  }

  Future checkPassWord(idWaiter, vPassword) async{
    String vApiUrl = '$vApiUrlP/waiters';
    var vFile="checkPassWord.php";
    var url = "$vApiUrl/$vFile";
    var res = await http.post(Uri.parse(url), body: {
      'idWaiter': idWaiter,
      'vPassword': password,
    });

    setState(() {
      password = '';
      passMask = '';
    });

    if (res.statusCode == 200) {
      if (!context.mounted) return;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RoomPage(idWaiter : idWaiter,)));
    } else {
      if (!context.mounted) return;
      PrettySnackBar.show(context, 'Contraseña no válida!!!');
    }
  }

  @override
  Widget build(BuildContext context) {
    //var imageWidth = MediaQuery.of(context).size.width *0.25; //% del ancho de pantalla
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          title: const Text('Selección de camarero'),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  image: DecorationImage(
                    image: NetworkImage('$vApiUrlI/logos/logo1.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: const Stack(
                  children: [
                    Positioned(
                      bottom: 8.0,
                      left: 4.0,
                      child: Text(
                        "Delicius Food",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text("Tutorial"),
                onTap: ()
                  async {
                    Navigator.pop(context);
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('showHome', false);
                    if (!context.mounted) return;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const OnBoardingPage()),
                    );
                },
              ),
              ListTile(
                leading: const Icon(Icons.dining_sharp),
                title: const Text("Platos"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const Dishes()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.align_vertical_bottom_outlined),
                title: const Text("Acerca de..."),
                onTap: () {},
              )
            ],
          ),
        ),
        body:
        Column(
          children: [
            Expanded(
              child: StreamBuilder<List<dynamic>>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ListTile(

                            title: Text(snapshot.data![index]['name'],style: const TextStyle(fontSize: 16),),
                            subtitle: const Text(" "),
                            leading: InkWell(
                                onTap: (){
                                  checkPassWord(snapshot.data![index]['id'], password);
                                },
                                child:
                              CircleAvatar(
                                radius: 40,
                                foregroundImage: snapshot.data![index]['image'] == "" ? null : NetworkImage('$vImageUrl/${snapshot.data![index]['image']}'),
                              ),
                            ),
                          );
                        });
                  }else if(snapshot.hasError){
                    return const Center(child: Text('Se ha producido un error. No hay datos disponibles !!!'));
                  }
                  //return const Center(child: Text("Server Error!!!"));
                  return const Center(child: CircularProgressIndicator());
                }, // builder:
              ),
            ),
            Text(passMask),
            const Text('Teclea password y clica en tu avatar'),
            NumericKeyboard(
                onKeyboardTap: onKeyboardTap,
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
                rightButtonFn: () {
                  if (password.isEmpty) return;
                  setState(() {
                    password = password.substring(0, password.length - 1);
                    passMask = passMask.substring(0, passMask.length - 1);
                  });
                },
                rightButtonLongPressFn: () {
                  if (password.isEmpty) return;
                  setState(() {
                    password = '';
                    passMask = '';
                  });
                },
                rightIcon: const Icon(
                  Icons.backspace_outlined,
                  color: Colors.blueGrey,
                ),
                mainAxisAlignment: MainAxisAlignment.spaceBetween),
          ],
        )
    );
  }
}
