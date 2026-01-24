import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:pdfx/pdfx.dart';

class Rules extends StatefulWidget {
  const Rules({super.key});

  @override
  State<Rules> createState() => _RulesState();
}

class _RulesState extends State<Rules> {
  late PdfControllerPinch _pdfControllerPinch;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pdfControllerPinch = PdfControllerPinch(document: PdfDocument.openAsset(rulesPDFFile));
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