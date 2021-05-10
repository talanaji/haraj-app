import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/utils/utils.dart';

import 'package:flutter/material.dart';

class PsWidgetWithAppBarAndMultiProvider extends StatefulWidget {
  const PsWidgetWithAppBarAndMultiProvider(
      {Key key,
      this.child,
      @required this.appBarTitle,
      this.actions = const <Widget>[]})
      : super(key: key);

  final Widget child;
  final String appBarTitle;
  final List<Widget> actions;

  @override
  _PsWidgetWithAppBarAndMultiProviderState createState() =>
      _PsWidgetWithAppBarAndMultiProviderState();
}

class _PsWidgetWithAppBarAndMultiProviderState
    extends State<PsWidgetWithAppBarAndMultiProvider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final dynamic data = EasyLocalizationProvider.of(context).data;
    // return EasyLocalizationProvider(
    //     data: data,
    //     child:

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,

          brightness: Utils.getBrightnessForAppBar(context),
          iconTheme: IconThemeData(color: PsColors.mainColorWithWhite),
          title: Text(widget.appBarTitle,
              style: Theme.of(context).textTheme.subtitle1.copyWith(

                  color: PsColors.black),textAlign: TextAlign.center,),
          actions: widget.actions,
          flexibleSpace: Container(
            height: 200,
          ),
          elevation: 0,
        ),
        body: widget.child
        // )
        );
  }
}
