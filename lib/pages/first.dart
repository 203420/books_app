import 'dart:convert';
import 'package:books_app/pages/explore.dart';
import 'package:books_app/pages/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:books_app/users/google_signin.dart';
import 'package:books_app/users/user_class.dart';
import 'package:books_app/pages/register.dart';

class FirstPage extends StatelessWidget {
  
  const FirstPage({super.key});

  Future <void> googleSignIn(BuildContext context) async {
    final user = await GoogleSignInApi.login();
    if (user != null) {
      try {
        final GoogleSignInAuthentication googleAuth = await user.authentication;
        var url = Uri.https('fa0e-2806-2f0-8160-4e97-f0a3-bd0d-755c-79c5.ngrok-free.app', 'auth/google');
        var response = await http.post(url, body: {'nombre': user.displayName, 'email': user.email});
        if (kDebugMode) {
          print(response.statusCode);
        }
        if (response.statusCode == 200){
          final data = jsonDecode(response.body);
          User user = User(data['nombre'], data['email'], data['token'], 'GOOGLE');
          // ignore: use_build_context_synchronously
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  Explore(user: user)));
        }
      }catch (e){
        if (kDebugMode) {
          print(e);
        }
      }
     
    }
  }


  @override
  Widget build(BuildContext context) {
    const colorText = Color.fromARGB(221, 22, 22, 22);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 125, left: 25, right: 25),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Image.asset(
                    "assets/images/icon_first_bg.png",
                    height: 290,
                  ),
                ),
                const Text(
                  "Explora tus libros favoritos",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: colorText),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 105),
                  child: SizedBox(
                    width: double.infinity,
                    height: 140,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                              onPressed: () => {
                                Navigator.push(context, MaterialPageRoute(builder: ((context) => const Login())))
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
                                padding: EdgeInsets.only(
                                    top: 20, bottom: 20),
                                child: Text(
                                  "Continuar",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Color.fromARGB(255, 241, 241, 241)),
                                ),
                              ),
                            ),
                        ),
                        OutlinedButton(
                          onPressed: () => googleSignIn(context), //async { await GoogleSignInApi.logout(); },
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor:
                                  const Color.fromARGB(255, 249, 249, 249),
                              side: const BorderSide(
                                  width: 1.5,
                                  color: Color.fromARGB(255, 249, 249, 249)),
                              elevation: 5),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 16, bottom: 16, left: 32, right: 45),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'assets/images/google_icon_color.png',
                                  height: 22,
                                  width: 22,
                                ),
                                const Text(
                                  "Ingresar con Google",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Color.fromARGB(255, 84, 84, 84)),
                                ),
                              ],
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
        ),
      ),
    );
  }
}
