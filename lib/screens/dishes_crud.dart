import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../functions/functions.dart';

class Dishes extends StatefulWidget {
  const Dishes({super.key});

  @override
  State<Dishes> createState() => _DishesState();
}

class _DishesState extends State<Dishes> {

  XFile? img;
  ImagePicker imgPic = ImagePicker();

  getImg(id) async{
    final vPic = await imgPic.pickImage(source: ImageSource.gallery);

    setState(() {
      img = XFile(vPic!.path);
    });

    addImage(id);

  }

  TextEditingController vName = TextEditingController();
  TextEditingController vImage = TextEditingController();
  final FocusNode _nameFocus = FocusNode();

  List list = [];
  String vApiUrl = '$vApiUrlP/dishes_crud';
  String vImageUrl='$vApiUrlI/dishes';

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

  Future addData() async {
    var url = "$vApiUrl/addData.php";
    var res = await http.post(Uri.parse(url), body: {
      'name': vName.text,
    });
    if(res.statusCode == 200){
      var redX = jsonDecode(res.body);
      print(redX);
      await readData();
      updateName(vName.text);
    }
  }

  Future editData(id) async {
    var url = "$vApiUrl/editData.php";
    var res = await http.post(Uri.parse(url), body: {
      'id': id,
      'name': vName.text,
    });
    if(res.statusCode == 200){
      //var redX = jsonDecode(res.body);
      //print(redX);
      await readData();
      updateName(vName.text);
    }
  }

  Future deleteData(id) async {
    var url = "$vApiUrl/deleteData.php";
    var res = await http.post(Uri.parse(url), body: {
      'id': id,
    });
    if(res.statusCode == 200){
      //var redX = jsonDecode(res.body);
      //print(redX);
      await readData();
    }
  }

  Future uploadImage(id) async{
    var url = "$vApiUrl/uploadImage.php";
    var req = http.MultipartRequest("post", Uri.parse(url));
    req.fields['id'] = id;
    var pic = await http.MultipartFile.fromPath('img', img!.path);

    req.files.add(pic);

    var res =await req.send();

    if(res.statusCode == 200){
      //print('done upload image');
      await readData();
    }

  }

  late StreamController<List<dynamic>> _streamController;
  late Stream<List<dynamic>> _stream;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _nameFocus.requestFocus();

    setState(() {
      _streamController = StreamController();
      _stream = _streamController.stream;
    });

    getData();
  }

  @override
  void dispose() {
    vName.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  void updateName(String newName) {
    setState(() {
      vName.text = newName;
    });
  }

  getData() async {
    await readData();
  }

  addDishes(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            content: SizedBox(
                //height: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: vName,
                      maxLength: 40,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.dining),
                        labelText: 'Nombre del plato',
                      ),

                    ),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:[
                          ElevatedButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: const Text("Cancelar")
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                //if (vName.text.length >=1) {
                                // if (vName.text.isNotEmpty) {
                                //   await addData();
                                // }
                                await addData();
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              },
                              child: const Text("Guardar")
                          ),
                        ]
                    ),
                  ],
                )
            ),
          );
        });
  }

  editDishes(id, dishName){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            content: SizedBox(
                height: 300,
                child: Column(
                  children: [
                    TextFormField(
                      controller: vName,
                      maxLength: 40,
                      focusNode: _nameFocus,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.dining),
                        hintText: dishName,
                        labelText: 'Nombre del plato',
                      ),

                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:[
                          ElevatedButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: const Text("Cancelar")
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                await editData(id);
                                if (!context.mounted) return;
                                Navigator.pop(context);
                                readData();
                              },
                              child: const Text("Guardar")
                          ),
                        ]
                    ),
                  ],
                )
            ),
          );
        });
  }

  addImage(id){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Guardar Imagen'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(onPressed: () async {
                        uploadImage(id);
                        // await readData();
                        // if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                          child: const Text('Guardar')),
                      ElevatedButton(onPressed: (){
                        Navigator.pop(context);
                      },
                          child: const Text('Cancelar')),
                    ],
                  ),
                ],
              )
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          title: const Text('Gestión de Platos'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: (){
                  addDishes();
                },
                icon: const Icon(Icons.add,size: 35))
          ],
        ),
        body:
        StreamBuilder<List<dynamic>>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index]['name'],style: const TextStyle(fontSize: 16),),
                      subtitle: Text(snapshot.data![index]['familyName']),
                      leading: InkWell(
                        onTap: (){
                          getImg(snapshot.data![index]['id']);
                        },
                        child:
                        Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10.0),
                              image:  DecorationImage(
                                image: snapshot.data![index]['image'] != ""
                                        ? NetworkImage('$vImageUrl/${snapshot.data![index]['directory']}/${snapshot.data![index]['image']}')
                                        : NetworkImage('$vImageUrl/no-photo.png'),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey, //Color(0xffA4A4A4),
                                  offset: Offset(1.0, 5.0),
                                  blurRadius: 3.0,
                                ),
                              ]),
                        ),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                            children: [
                              IconButton(onPressed: () {
                                editDishes(snapshot.data![index]['id'],snapshot.data![index]['name']);
                              }, icon: const Icon(
                                  Icons.edit, color: Colors.teal)),
                              IconButton(onPressed: () {
                                if (snapshot.data![index]['id'] == '11'){
                                  deleteData(snapshot.data![index]['id']);
                                }else {
                                  PrettySnackBar.show(context, 'Sólo se pueden eliminar platos de fogones!!!');
                                }
                              }, icon: const Icon(
                                  Icons.delete, color: Colors.redAccent)),
                            ]
                        ),
                      ),
                    );
                  });
            }else if(snapshot.hasError){
              return const Center(child: Text('No data available right now'));
            }
            //return const Center(child: Text("Server Error!!!"));
            return const Center(child: CircularProgressIndicator());
          }, // builder:
        )

      // //pequeño selector de imagen
      // Column(
      //   children: [
      //     ElevatedButton(onPressed: (){
      //       getImg();
      //     }, child: const Text('PicImage')),
      //
      //     Container(
      //       child: img == null ? Container() : Image.file(File(img!.path)),
      //     ),
      //   ],
      // ),
    );
  }
}
