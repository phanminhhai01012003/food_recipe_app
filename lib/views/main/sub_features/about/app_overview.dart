import 'package:flutter/material.dart';
import 'package:food_recipe_app/common/extension/string_extension.dart';
import 'package:food_recipe_app/common/style/app_assets.dart';
import 'package:food_recipe_app/common/style/app_colors.dart';
import 'package:pdfx/pdfx.dart';

class AppOverview extends StatefulWidget {
  const AppOverview({super.key});

  @override
  State<AppOverview> createState() => _AppOverviewState();
}

class _AppOverviewState extends State<AppOverview> {
  late PdfControllerPinch _pdfControllerPinch;
  bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pdfControllerPinch = PdfControllerPinch(document: PdfDocument.openAsset(overviewPDFFile));
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pdfControllerPinch.dispose();
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