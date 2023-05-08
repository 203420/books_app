import 'dart:convert';
import 'package:books_app/pages/explore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:books_app/pages/preview.dart';
import 'package:books_app/pages/register.dart';
import 'package:books_app/users/user_class.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:books_app/users/local_notification.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool obsText = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwController = TextEditingController();
  static const colorText =  Color.fromARGB(221, 22, 22, 22);

  void login(BuildContext context) async {
    try {
        var url = Uri.https('fa0e-2806-2f0-8160-4e97-f0a3-bd0d-755c-79c5.ngrok-free.app', 'auth/login');
        var response = await http.post(url, body: {'email': emailController.text, 'password': passwController.text});
        if (kDebugMode) {
          print('Response status: ${response.statusCode}');
        }

        

        
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          User user = User(data['nombre'], data['email'], data['token'], 'local');

          // ignore: use_build_context_synchronously
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  Explore(user: user)));
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
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/icon_login.png",
                          height: 250,
                        ),
                        const Padding (
                          padding:  EdgeInsets.only(top: 15),
                          child:  SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Inicio de sesión",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: colorText),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Ingresa tus datos",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: colorText),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:40),
                          child: SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.175,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    hintText: "Correo electrónico",
                                    prefixIcon: const Icon(Icons.email_rounded,
                                        color: Colors.black38),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
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
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 170),
                          child: SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.110,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                const Text(
                                  "¿No tienes una cuenta? ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 73, 73, 73)),
                                ),
                                InkWell(
                                  onTap: () => {
                                    Navigator.push(context, MaterialPageRoute(builder: ((context) => const Register())))
                                  },
                                  child: const Text(
                                  "Crear cuenta",
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
                                      onPressed: () => {login(context)},
                                      style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          backgroundColor: const Color(0xFF8388DE),
                                          side: const BorderSide(
                                              width: 1.5, color: Color(0xFF8388DE)),
                                          elevation: 5),
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.only(top: 20, bottom: 20),
                                        child: Text(
                                          "Iniciar sesión",
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
              );
            },
          ),
        ),
      ),
    );
  }
}
