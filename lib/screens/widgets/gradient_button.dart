import 'package:authentication_app/utils/pallete.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  const GradientButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Pallete.gradient1, Pallete.gradient2, Pallete.gradient3],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight),
          borderRadius: BorderRadius.circular(20)),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              fixedSize: const Size(400, 70), shadowColor: Colors.transparent, backgroundColor: Colors.transparent),
          child: Text(
            buttonText,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          )),
    );
  }
}
