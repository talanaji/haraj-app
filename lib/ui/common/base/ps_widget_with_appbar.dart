import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/constant/route_paths.dart';
import 'package:haraj/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PsWidgetWithAppBar<T extends ChangeNotifier> extends StatefulWidget {
  const PsWidgetWithAppBar(
      {Key key,
      @required this.builder,
      @required this.initProvider,
      this.child,
      this.onProviderReady,
      @required this.appBarTitle,
      this.actions = const <Widget>[]})
      : super(key: key);

  final Widget Function(BuildContext context, T provider, Widget child) builder;
  final Function initProvider;
  final Widget child;
  final Function(T) onProviderReady;
  final String appBarTitle;
  final List<Widget> actions;

  @override
  _PsWidgetWithAppBarState<T> createState() => _PsWidgetWithAppBarState<T>();
}

class _PsWidgetWithAppBarState<T extends ChangeNotifier>
    extends State<PsWidgetWithAppBar<T>> {
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
          shadowColor: PsColors.black,

          backgroundColor:
              Utils.isLightMode(context) ? PsColors.white : Colors.black12,
          brightness: Utils.getBrightnessForAppBar(context),
          iconTheme: IconThemeData(color: PsColors.mainColor),
          title: /*Text(,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold)
                  .copyWith(color: PsColors.white))*/
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    widget.appBarTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: PsColors.black),
                  )),
              Container(alignment: Alignment.centerLeft,

                width: MediaQuery.of(context).size.width * 0.2,
                child: IconButton(
                  icon: Icon(
                    Icons.notifications_none,
                    color: PsColors.black,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RoutePaths.notiList,
                    );
                  },
                ),
              )
            ],
          ),
          actions: widget.actions,
          flexibleSpace: Container(
            height: 200,
          ),
          elevation: 0,
        ),
        body: ChangeNotifierProvider<T>(
          lazy: false,
          create: (BuildContext context) {
            final T providerObj = widget.initProvider();
            if (widget.onProviderReady != null) {
              widget.onProviderReady(providerObj);
            }

            return providerObj;
          },
          child: Consumer<T>(
            builder: widget.builder,
            child: widget.child,
          ),
        )
        // )
        );
  }
}
