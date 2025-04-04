import 'package:flutter/material.dart';

class ProfindButton extends StatefulWidget {
  const ProfindButton({super.key, required this.label});

  final String label;

  @override
  State<ProfindButton> createState() => _ProfindButtonState();
}

class _ProfindButtonState extends State<ProfindButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Container(
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
              color: const Color(0xFFfa7f3b),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
                child: Text(
              widget.label,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ))));
  }
}
