import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() async{
    final user = _googleSignIn.signIn();
    return user;
  } 

  static Future logout () async{ 
    _googleSignIn.disconnect();
  }
}