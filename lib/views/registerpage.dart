import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bluelantern/components/googlebutton.dart';
import 'package:bluelantern/components/buttons.dart';
import 'package:bluelantern/components/textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserUp() async{
    showDialog(
      context: context,
      builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
        );
      },
    );


    try{
      if(passwordController.text == confirmPasswordController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text
        );
      }else{
        Navigator.pop(context);
        showErrorMessage("Passwords don't match!");
      }
      
    } on FirebaseAuthException catch (e){
      Navigator.pop(context);
      showErrorMessage(e.code);
    }

    // ignore: use_build_context_synchronously
   
  }

   void showErrorMessage(String message) {
      showDialog(context: context,
       builder: (context){
          return AlertDialog(
            title: Text(message,textAlign: TextAlign.center, style: const TextStyle(color: Colors.red),),
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
              const SizedBox(height: 15,),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
               const SizedBox(height: 15,),
              MyTextField(
                controller: confirmPasswordController,
                hintText: 'confirm Password',
                obscureText: true,
              ),
              //login button
              const SizedBox(height: 25,),
                MyButton(
                  onTap: signUserUp,
                  name: 'Sign up',
                ),
              //text
              const SizedBox(height: 40),
        
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
        
              const SizedBox(height: 40),
        
              GoogleButton(onTap: signUserUp,
               name: 'Google'),
              
              const SizedBox(height: 25),
               Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login',
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