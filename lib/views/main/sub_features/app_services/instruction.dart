import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:pdfx/pdfx.dart';

class Instruction extends StatefulWidget {
  const Instruction({super.key});

  @override
  State<Instruction> createState() => _InstructionState();
}

class _InstructionState extends State<Instruction> {
  late PdfControllerPinch _pdfControllerPinch;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pdfControllerPinch = PdfControllerPinch(document: PdfDocument.openAsset(privacypolicyPDFFile));
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PdfViewPinch(
        controller: _pdfControllerPinch,
        scrollDirection: Axis.vertical,
        padding: 8,
      ),
    );
  }
}