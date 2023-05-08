import 'dart:convert';
import 'dart:io';
import 'package:books_app/pages/first.dart';
import 'package:books_app/pages/preview.dart';
import 'package:books_app/pages/search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../users/user_class.dart';
import 'package:books_app/users/google_signin.dart';

class Explore extends StatefulWidget {
  final User user;

  const Explore({Key? key, required this.user}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  static const colorText = Color.fromARGB(221, 22, 22, 22);
  final TextEditingController searchController = TextEditingController();
  List<dynamic>? _books;
  List<dynamic>? _newBooks;
  List<dynamic>? _listBooks;

  final _urlimg ="fa0e-2806-2f0-8160-4e97-f0a3-bd0d-755c-79c5.ngrok-free.app";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getBooks();
    
  }

  void _getBooks() async {
    try {
      var url = Uri.https(
          'fa0e-2806-2f0-8160-4e97-f0a3-bd0d-755c-79c5.ngrok-free.app', 'books/');
      var response = await http.get(url);
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      if (response.statusCode == 200) {
        //print(response.body);
        final res_list = jsonDecode(response.body);
        setState(() {
          _books = res_list;
          _newBooks = _books!.sublist(_books!.length - 5, _books!.length);
          _listBooks = _books!.sublist(0, _books!.length - 5);
          print(_newBooks!.length);
          print(_listBooks!.length);

          print(res_list);

          
        });
        sendEmail();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future sendEmail () async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': 'service_7cxt1sk',
        'template_id': 'template_9t32mt4',
        'user_id': 'Zo6ohOYqNSNMV98r7',
        'template_params': {
          'user_name': widget.user.name,
          'user_email': widget.user.email,
          'user_subject': 'Inicio de sesión',
          'intro_email': 'Bienvenido',
          'user_message': 'Se ha detectado un nuevo inicio de sesión en su cuenta'
        }
      }),
    );

    print(response.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 160,
        title: Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Explorar",
                    style: TextStyle(
                        color: colorText,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    width: 70,
                    child: OutlinedButton(
                      onPressed: () async {
                        if (widget.user.type == 'GOOGLE') {
                          await GoogleSignInApi.logout();
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const FirstPage())));
                      },
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 246, 246, 246),
                          side: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 246, 246, 246)),
                          elevation: 1),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          "Salir",
                          style: TextStyle(fontSize: 13, color: colorText),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.215),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0.15, 2.5),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 245, 245, 245),
                      hintText: "Buscar libros",
                      prefixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Colors.black38),
                          onPressed: () {
                            if (searchController.text != ""){
                              FocusManager.instance.primaryFocus?.unfocus();
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>  SearchBook(search: searchController.text)));
                            }
                          }),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints viewportConstrains) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: viewportConstrains.maxHeight),
                    child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
        child: _books != null
            ? Column(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Nuevos libros",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _newBooks?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PreviewBook(
                                                id: _newBooks![index]['id'])))
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, right: 18),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 6),
                                          child: SizedBox(
                                              width: 110,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.19,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          const Color.fromARGB(
                                                                  255,
                                                                  114,
                                                                  114,
                                                                  114)
                                                              .withOpacity(0.3),
                                                      spreadRadius: 3,
                                                      blurRadius: 7,
                                                      offset:
                                                          const Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.network(
                                                    _newBooks![index]['files'][1]['url'].toString().replaceFirst(RegExp(r'http://localhost:8000'), 'https://$_urlimg'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            _newBooks![index]['title'],
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: colorText),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.5),
                                          child: SizedBox(
                                            width: 100,
                                            child: Text(
                                              _newBooks![index]['autor'],
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w400,
                                                  color: colorText,
                                                  fontStyle: FontStyle.italic),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 15),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Más libros",
                        style: TextStyle(
                            fontSize: 16.5, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 330,
                    child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, crossAxisSpacing: 0,  mainAxisSpacing: 10, mainAxisExtent: 150),
                      children: List.generate(_listBooks!.length, (index) {
                        return InkWell(
                          onTap: () => {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PreviewBook(id: _listBooks![index]['id'])))
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                width: 90,
                                height: 126,
                              child: InkWell(
                                child:
                                 ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(6),
                                  child: Image.network(
                                    _listBooks![index]['files'][1]['url'].toString().replaceFirst(RegExp(r'http://localhost:8000'), 'https://$_urlimg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              ),
                            ],
                          )
                        );
                      }),
                    ),
                  )
                ],
              )
            : const Center(
                child: Text("No se han registrado libros"),
              ),
      ),
                  ),
                );
              },
          )
      ),
    );
  }
}
