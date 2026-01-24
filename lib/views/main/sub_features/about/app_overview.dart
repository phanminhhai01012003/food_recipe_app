import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:pdfx/pdfx.dart';

class AppOverview extends StatefulWidget {
  const AppOverview({super.key});

  @override
  State<AppOverview> createState() => _AppOverviewState();
}

class _AppOverviewState extends State<AppOverview> {
  late PdfControllerPinch _pdfControllerPinch;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pdfControllerPinch = PdfControllerPinch(document: PdfDocument.openAsset(overviewPDFFile));
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