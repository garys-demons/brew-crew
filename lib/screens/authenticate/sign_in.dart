import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';


class SignIn extends StatefulWidget {

  // ignore: prefer_typing_uninitialized_variables
  final toggleView;
  // ignore: use_super_parameters
  const SignIn({Key?key, required this.toggleView}):super(key:key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email ='';
  String password = '';
  String error = '';


  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 95, 66, 55),
        elevation: 0.0,
        title: const Text(
          'Sign in to Brew Crew',
          style: TextStyle(
            fontFamily: 'Quicksand'
          ),),
        actions: [
          TextButton.icon(
            onPressed: () {
              widget.toggleView();
            }, 
            label: const Text(
              'Register',
              style: TextStyle(
                color: Colors.black
              ),),
            icon: const Icon(Icons.person, color: Colors.black,),)
        ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/coffee_wallpaper.jpeg'),
              fit: BoxFit.cover
              )
          ),
          padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 20.0),
          child: Form(
            key:  _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val!.isEmpty ? "Enter an email" : null,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                const SizedBox(height: 20.0,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  validator: (val) => val!.length < 8 ? "Enter a password 8+ chars long" : null,
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                const SizedBox(height: 20.0,),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()){
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.SignInWithEmailAndPasswd(email, password);
                      if (result==null){
                        setState(() {
                          error = 'Could not sign in with those credentials';
                          loading = false;
                        });
                      }
                    }
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(color: Colors.brown),
                  ),
                  ),
                  const SizedBox(height: 12.0,),
                  Text(
                    error,
                    style:const TextStyle(
                      color: Colors.red,
                      fontSize: 14.0
                    )
                  )
              ],
            )
            )
        ),
    );
}
}