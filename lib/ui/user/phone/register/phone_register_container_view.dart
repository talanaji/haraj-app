import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/config/ps_config.dart';
import 'package:haraj/constant/route_paths.dart';
import 'package:haraj/provider/user/user_provider.dart';
import 'package:haraj/repository/user_repository.dart';
import 'package:haraj/ui/user/phone/register/phone_register_view.dart';
import 'package:haraj/ui/user/phone/sign_in/phone_sign_in_view.dart';
import 'package:haraj/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class PhoneRegisterContainerView extends StatefulWidget {
  @override
  _PhoneRegisterContainerViewState createState() =>
      _PhoneRegisterContainerViewState();
}

class _PhoneRegisterContainerViewState extends State<PhoneRegisterContainerView>
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
        onWillPop: () async =>false,//_requestPop,
        child: Scaffold(
          body: Stack(children: <Widget>[
            Container(
              color: PsColors.mainLightColorWithBlack,
              width: double.infinity,
              height: double.maxFinite,
            ),
            CustomScrollView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                slivers: <Widget>[

                  /*_SliverAppbar(
                    title: Utils.getString(context, 'home_phone_signin'),
                    scaffoldKey: scaffoldKey,
                  ),*/
                  PhoneRegisterView(
                    animationController: animationController,
                  ),
                ])
          ]),
        ));
  }
}

class _SliverAppbar extends StatefulWidget {
  const _SliverAppbar(
      {Key key, @required this.title, this.scaffoldKey, this.menuDrawer})
      : super(key: key);
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Drawer menuDrawer;
  @override
  _SliverAppbarState createState() => _SliverAppbarState();
}

class _SliverAppbarState extends State<_SliverAppbar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,

      brightness: Utils.getBrightnessForAppBar(context),
      iconTheme: Theme.of(context)
          .iconTheme
          .copyWith(color: PsColors.mainColorWithWhite),
      title: Text(
        widget.title,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(fontWeight: FontWeight.bold)
            .copyWith(color: PsColors.mainColorWithWhite),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.notifications_none,
              color: Theme.of(context).iconTheme.color),
          onPressed: () {
            Navigator.pushNamed(
              context,
              RoutePaths.notiList,
            );
          },
        ),
      ],
      elevation: 0,
    );
  }
}
