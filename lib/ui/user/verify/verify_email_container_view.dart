import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/config/ps_config.dart';
import 'package:haraj/provider/user/user_provider.dart';
import 'package:haraj/repository/user_repository.dart';
import 'package:haraj/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'verify_email_view.dart';

class VerifyEmailContainerView extends StatefulWidget {
  const VerifyEmailContainerView({@required this.userId});
  final String userId;
  @override
  _CityVerifyEmailContainerViewState createState() =>
      _CityVerifyEmailContainerViewState();
}

class _CityVerifyEmailContainerViewState extends State<VerifyEmailContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
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
  UserProvider userProvider;
  UserRepository userRepo;

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    print(
        '............................Build UI Again ............................');
    userRepo = Provider.of<UserRepository>(context);

    return WillPopScope(
        onWillPop: () async => false, //_onWillPop,

        child: Scaffold(
            appBar: AppBar(
              backgroundColor:
                  Utils.getBrightnessForAppBar(context) == Brightness.dark
                      ? PsColors.black
                      : PsColors.mainColor,
              brightness: Utils.getBrightnessForAppBar(context),
              iconTheme:
                  Theme.of(context).iconTheme.copyWith(color: PsColors.white),
              title: Text(
                Utils.getString(context, 'email_verify__title'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold, color: PsColors.white),
              ),
              elevation: 0,
            ),
            body: VerifyEmailView(
              animationController: animationController,
              userId: widget.userId,
            )));
  }
}
