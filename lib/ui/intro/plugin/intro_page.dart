import 'package:flutter/material.dart';
import 'package:haraj/ui/intro/plugin/intro_content.dart';
import 'package:haraj/ui/intro/plugin/page_view_model.dart';

class IntroPage extends StatelessWidget {
  final PageViewModel page;

  const IntroPage({Key key, @required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: page.decoration.pageColor,
      decoration: page.decoration.boxDecoration,
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            if (page.image != null)
              Padding(
                  padding: page.decoration.imagePadding,
                  child: page.image,
                ),

             Padding(
                padding: const EdgeInsets.only(bottom: 70.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: IntroContent(page: page),
                ),
              ),

          ],
        ),
      ),
    );
  }
}
