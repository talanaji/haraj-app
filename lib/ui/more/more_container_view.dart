import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/config/ps_config.dart';
import 'package:haraj/utils/utils.dart';
import 'package:flutter/material.dart';
import 'more_view.dart';

class MoreContainerView extends StatefulWidget {
   const MoreContainerView( );

  @override
  _MoreContainerViewState createState() => _MoreContainerViewState();
}

class _MoreContainerViewState extends State<MoreContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Function callLogoutCallBack;

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    dynamic closeMoreContainerView(){
      Navigator.of(context).pop(true);
    }

    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
      onWillPop: () async => false, //_onWillPop,

      child: Scaffold(

        body: Container(
          color: PsColors.coreBackgroundColor,
          height: double.infinity,
          child: MoreView(
            animationController: animationController,
            closeMoreContainerView: closeMoreContainerView
          ),
        ),
      ),
    );
  }
}
