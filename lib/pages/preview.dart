import 'package:books_app/pages/explore.dart';
import 'package:books_app/pages/preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:books_app/users/local_notification.dart';

class PreviewBook extends StatefulWidget {
  final int id;

  const PreviewBook({Key? key, required this.id}): super(key: key);

  @override
  State<PreviewBook> createState() => _PreviewBookState();
}

class _PreviewBookState extends State<PreviewBook> {
  String? _title, _autor, _year, _edit, _editPlace, _pages, _url, _img;
  int counter = 0;
  static const colorText = Color.fromARGB(221, 22, 22, 22);
  final _urlPdf ="fa0e-2806-2f0-8160-4e97-f0a3-bd0d-755c-79c5.ngrok-free.app";
  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getBook();
  }

  void _getBook() async {
    try {
      var url = Uri.https('fa0e-2806-2f0-8160-4e97-f0a3-bd0d-755c-79c5.ngrok-free.app', 'books/${widget.id}');
      var response = await http.get(url);
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      if (response.statusCode == 200) {
        final res_list = jsonDecode(response.body);
        setState(() {
          _title = res_list["title"];
          _autor = res_list["autor"];
          _edit = res_list["editorial"];
          _year = res_list["year_edition"].toString();
          _pages = res_list["pages_number"].toString();
          _editPlace = res_list["edition_place"];
          _url = res_list["files"][0]["url"];
          _img = res_list["files"][1]["url"];

          _url = _url!.replaceFirst(RegExp(r'http'), 'https');
          _url = _url!.replaceFirst(RegExp(r'localhost:8000'), _urlPdf);
          _img = _img!.replaceFirst(RegExp(r'http'), 'https');
          _img = _img!.replaceFirst(RegExp(r'localhost:8000'), _urlPdf);

          print(_url);
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> launchURL() async {
    setState(() {
      counter++;
    });
     NotificationService.showNotification(
            id: counter,
            title: "¡Disfruta tu libro!",
            body: "La descarga ha comenzado...",
            payload: "Nueva descarga",
          );
    if (!await launchUrl(Uri.parse(_url!), mode: LaunchMode.externalApplication)) {
      throw Exception("URL ERROR");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: SafeArea(
          child: _title != null ?
          Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18, left: 25, right: 25),
            child: SizedBox(
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
                    _title!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorText,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.11),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 40, bottom: 45, left: 25, right: 25),
            child: SizedBox(
                width: 125,
                height: MediaQuery.of(context).size.height * 0.22,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 114, 114, 114)
                            .withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _img!,
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 40, left: 40, right: 40, bottom: 20),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      _title!,
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: colorText),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      _autor!,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: colorText),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: SizedBox(
                        width: double.infinity,
                        height: 110,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("$_year", textAlign: TextAlign.center, style: const TextStyle(fontStyle: FontStyle.italic),),
                            Text("$_pages páginas", textAlign: TextAlign.center, style: const TextStyle(fontStyle: FontStyle.italic),),
                            Text("Editorial: $_edit", textAlign: TextAlign.center, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w500),),
                            Text("Editado en: $_editPlace", textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
                            
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 110),
                      child: SizedBox(
                        width: double.infinity,
                        height: 62,
                        child: OutlinedButton(
                          onPressed: () => {
                            launchURL(),
                          },
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor: const Color(0xFF8388DE),
                              side: const BorderSide(
                                  width: 1.5, color: Color(0xFF8388DE)),
                              elevation: 5),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 18, bottom: 18),
                            child: Text(
                              "Descargar",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Color.fromARGB(255, 241, 241, 241)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ))
        ],
      ) :
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18, left: 25, right: 25),
            child: SizedBox(
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
                  const Text(
                    "Obteniendo datos...",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorText,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.11),
                ],
              ),
            ),
          ),
        ],
      )
      ), 
      
    );
  }
}
