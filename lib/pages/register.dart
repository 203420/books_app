import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:books_app/pages/login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:books_app/users/local_notification.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  bool obsText = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwController = TextEditingController();

   void register(BuildContext context) async {
    try {
        var url = Uri.https('fa0e-2806-2f0-8160-4e97-f0a3-bd0d-755c-79c5.ngrok-free.app', 'auth/register');
        //print("here");
        
        //  NotificationService.showNotification(
        //     id: 0,
        //     title: "Hola",
        //     body: "Ejemplo de notificacion",
        //     payload: "Payload",
        //   );

        var response = await http.post(url, body: {'nombre': nameController.text, 'email': emailController.text, 'password': passwController.text});
        if (kDebugMode) {
          print('Response status: ${response.statusCode}');
        }
        if (response.statusCode == 200) {
          // ignore: use_build_context_synchronously
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
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
        child: Center(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstrains) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: viewportConstrains.maxHeight),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 25, right: 25),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/icon_register.png",
                            height: 250,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                "Comencemos creando una cuenta",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.26,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextFormField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      hintText: "Nombre",
                                      prefixIcon: const Icon(Icons.person,
                                          color: Colors.black38),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty || !RegExp(r'^[A-Za-zÁ-Úá-ú ]+$').hasMatch(value)){
                                        return "Por favor, escriba su nombre correctamente";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      hintText: "Correo electrónico",
                                      prefixIcon: const Icon(
                                          Icons.email_rounded,
                                          color: Colors.black38),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)){
                                        return "Correo electrónico no válido";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  TextFormField(
                                    controller: passwController,
                                    decoration: InputDecoration(
                                        hintText: "Contraseña",
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          color: Colors.black38,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(obsText
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              obsText = !obsText;
                                            });
                                          },
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                    obscureText: obsText,
                                    validator: (value) {
                                      if (value!.isEmpty || !RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%\^&\*])(.{6,})$').hasMatch(value)){
                                        return "La contraseña debe contener un número, una mayúscula, y un símbolo";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: SizedBox(
                              width: double.infinity,
                              height:
                                  MediaQuery.of(context).size.height * 0.110,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "¿Ya tienes una cuenta? ",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Color.fromARGB(
                                                255, 73, 73, 73)),
                                      ),
                                      InkWell(
                                        onTap: () => {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      const Login())))
                                        },
                                        child: const Text(
                                          "Inicia sesión",
                                          style: TextStyle(
                                              fontSize: 16.5,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF8388DE)),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                        onPressed: () => {
                                          if (formKey.currentState!.validate()){
                                            register(context)
                                          }
                                        },
                                        style: OutlinedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            backgroundColor:
                                                const Color(0xFF8388DE),
                                            side: const BorderSide(
                                                width: 1.5,
                                                color: Color(0xFF8388DE)),
                                            elevation: 5),
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          child: Text(
                                            "Crear cuenta",
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Color.fromARGB(
                                                    255, 241, 241, 241)),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
