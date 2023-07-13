import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final Function()? onTap;
  final String name;

  const GoogleButton({super.key, required this.onTap, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/images/google-logo.png', height: 25,),
              const SizedBox(width: 10,),
              const SizedBox(width: 87,),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        
      ),
    );
  }
}