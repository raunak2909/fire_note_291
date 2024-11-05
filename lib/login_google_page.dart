import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginGooglePage extends StatelessWidget {
  const LoginGooglePage({super.key});

  @override
  Widget build(BuildContext context) {

    final GoogleSignIn googleSignIn = GoogleSignIn(
      // The OAuth client id of your app. This is required.
      clientId: '904753818452-rmapdf8da3qkbfc1ols1ihclj21bep7e.apps.googleusercontent.com',
      // If you need to authenticate to a backend server, specify its OAuth client. This is optional.
      serverClientId: 'Your Server ID',
      scopes: ['profile','email', 'https://www.googleapis.com/auth/contacts.readonly',]
    );

    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () async{
            ///google sign in
            var googleAcc = await googleSignIn.signIn();
            print("googleAcc : ${googleAcc!.email}");

            final GoogleSignInAuthentication? googleAuth = await googleAcc.authentication;

            // Create a new credential
            final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth?.accessToken,
              idToken: googleAuth?.idToken,
            );

            // Once signed in, return the UserCredential
            var cred = await FirebaseAuth.instance.signInWithCredential(credential);
            print("userId: ${cred.user!.uid}");

          },
            child: FaIcon(FontAwesomeIcons.google, size: 100)),
      ),
    );
  }
}
