import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bluelantern/components/googlebutton.dart';
import 'package:bluelantern/components/buttons.dart';
import 'package:bluelantern/components/textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async{
    showDialog(
      context: context,
      builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
        );
      },
    );


    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e){
      Navigator.pop(context);
      if(e.code == 'user-not-found'){
        wrongEmailMessage();
      }else if(e.code == 'wrong-password'){
        wrongPassword();
      }
    }

    // ignore: use_build_context_synchronously
   
  }

   void wrongEmailMessage() {
      showDialog(context: context,
       builder: (context){
          return const AlertDialog(
            title: Text('No user found',textAlign: TextAlign.center,style: TextStyle(color: Colors.red),),
          );
       });
   }
   void wrongPassword() {
      showDialog(context: context,
       builder: (context){
          return const AlertDialog(
            title: Text('Wrong Password',textAlign: TextAlign.center, style: TextStyle(color: Colors.red),),
          );
       });
   }

   


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const SizedBox(height: 60,),
              Image.asset('lib/images/login.png',height: 200,),
              //email
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              //password
              const SizedBox(height: 20,),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              //login button
              const SizedBox(height: 20,),
                MyButton(
                  onTap: signUserIn,
                  name: 'Login',
                ),
              //text
              const SizedBox(height: 50),
        
                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
        
              const SizedBox(height: 50),
        
              GoogleButton(onTap: signUserIn,
               name: 'Google'),
              
              const SizedBox(height: 25),
               Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
            ]
            ),
          ),
        ),
      ),
    );
  }
  
 
}