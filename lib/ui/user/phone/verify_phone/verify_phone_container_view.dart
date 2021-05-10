import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/config/ps_config.dart';
import 'package:haraj/provider/user/user_provider.dart';
import 'package:haraj/repository/user_repository.dart';
import 'package:haraj/ui/user/phone/verify_phone/verify_phone_view.dart';
import 'package:haraj/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyPhoneContainerView extends StatefulWidget {
  const VerifyPhoneContainerView({
    Key key,
    @required this.userName,
    @required this.phoneNumber,
    @required this.phoneId,
  }) : super(key: key);
  final String userName;
  final String phoneNumber;
  final String phoneId;
  @override
  _CityVerifyPhoneContainerViewState createState() =>
      _CityVerifyPhoneContainerViewState();
}

class _CityVerifyPhoneContainerViewState extends State<VerifyPhoneContainerView>
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
              automaticallyImplyLeading: false,

              backgroundColor: PsColors.mainColor,
              brightness: Utils.getBrightnessForAppBar(context),
              iconTheme:
                  Theme.of(context).iconTheme.copyWith(color: PsColors.white),
              title: Text(
                Utils.getString(context, 'home_verify_phone'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold, color: PsColors.white),
              ),
              elevation: 0,
            ),
            body: VerifyPhoneView(
              userName: widget.userName,
              phoneNumber: widget.phoneNumber,
              phoneId: widget.phoneId,
              animationController: animationController,
            )));
  }
}
