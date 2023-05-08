import 'package:books_app/pages/preview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchBook extends StatefulWidget {
  final String search;

  const SearchBook({Key? key, required this.search}) : super(key: key);

  @override
  State<SearchBook> createState() => _SearchBookState();
}

class _SearchBookState extends State<SearchBook> {
  static const colorText = Color.fromARGB(221, 22, 22, 22);
  int? _idBook;
  String? _urlImg;
  String? _title;
  String? _autor;
  bool? _searching = true;

  final _urlFinal ="fa0e-2806-2f0-8160-4e97-f0a3-bd0d-755c-79c5.ngrok-free.app";


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getBook();
  }

  void _getBook() async {
    try {
      var url = Uri.https(
          'fa0e-2806-2f0-8160-4e97-f0a3-bd0d-755c-79c5.ngrok-free.app',
          'books/name/${widget.search}');
      var response = await http.get(url);
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      if (response.statusCode == 200) {
        final res_list = jsonDecode(response.body);
        //print(res_list);
        setState(() {
          if (res_list.toString() != "[]") {
            _idBook = res_list[0]['id'];
            _title = res_list[0]['title'];
            _autor = res_list[0]['autor'];
            _urlImg = res_list[0]["files"][1]["url"];

            print(_idBook);
            print(_title);
            print(_autor);
            print(_urlImg);

          } else {
            _searching = false;
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: _title != null 
              ? Padding(
                  padding: const EdgeInsets.only(
                      top: 18, left: 25, right: 25, bottom: 30),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => {Navigator.pop(context)},
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              widget.search,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: colorText,
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.11),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 10, right: 10),
                        child: SizedBox(
                          width: double.infinity,
                          height: 240,
                          child: Row(
                            children: [
                              InkWell(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PreviewBook(
                                                id: _idBook!)))
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
                                                    _urlImg!.toString().replaceFirst(RegExp(r'http://localhost:8000'), 'https://$_urlFinal'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            _title!,
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
                                              _autor!,
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
                                ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                      top: 18, left: 25, right: 25, bottom: 30),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => {Navigator.pop(context)},
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              widget.search,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: colorText,
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.11),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 220),
                        child: _searching == true
                            ? const Text("Realizando busqueda...")
                            : const Text("No se encontraron resultados"),
                      ),
                    ],
                  ))),
    );
  }
}
