import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:pdfx/pdfx.dart';

class Rules extends StatefulWidget {
  const Rules({super.key});

  @override
  State<Rules> createState() => _RulesState();
}

class _RulesState extends State<Rules> {
  late PdfControllerPinch _pdfControllerPinch;
  bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pdfControllerPinch = PdfControllerPinch(document: PdfDocument.openAsset(rulesPDFFile));
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _pdfControllerPinch.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Stack(
        children: [
          PdfViewPinch(
            controller: _pdfControllerPinch,
            scrollDirection: Axis.vertical,
            padding: 8,
            onDocumentLoaded: (document) {
              setState(() {
                _isLoading = false;
              });
            },
            onDocumentError: (error) => Center(
              child: Text(
                "${"shortError".tr()}: $error",
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 18,
                  fontWeight: FontWeight.normal
                ),
              ),
            ),
          ),
          if (_isLoading) Center(child: CircularProgressIndicator(color: AppColors.yellow))
        ],
      ),
    );
  }
}