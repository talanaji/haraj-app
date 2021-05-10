import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/config/ps_config.dart';
import 'package:haraj/constant/ps_constants.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/constant/route_paths.dart';
import 'package:haraj/provider/user/user_provider.dart';
import 'package:haraj/repository/user_repository.dart';
import 'package:haraj/ui/common/dialog/error_dialog.dart';
import 'package:haraj/ui/common/dialog/warning_dialog_view.dart';
import 'package:haraj/ui/common/ps_button_widget.dart';
import 'package:haraj/utils/ps_progress_dialog.dart';
import 'package:haraj/utils/utils.dart';
import 'package:haraj/viewobject/common/ps_value_holder.dart';
import 'package:haraj/viewobject/holder/intent_holder/verify_phone_internt_holder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haraj/ui/dashboard/core/dashboard_view.dart';


class PhoneRegisterView extends StatefulWidget {
  const PhoneRegisterView(
      {Key key,
      this.animationController,
      this.goToLoginSelected,
      this.phoneSignInSelected})
      : super(key: key);
  final AnimationController animationController;
  final Function goToLoginSelected;
  final Function phoneSignInSelected;
  @override
  _PhoneRegisterViewState createState() => _PhoneRegisterViewState();
}

class _PhoneRegisterViewState extends State<PhoneRegisterView>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  UserRepository repo1;
  PsValueHolder psValueHolder;
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

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    animationController.forward();
    repo1 = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<UserProvider>(
        lazy: false,
        create: (BuildContext context) {
          final UserProvider provider =
              UserProvider(repo: repo1, psValueHolder: psValueHolder);
          return provider;
        },
        child: Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider provider, Widget child) {
          return Stack(
            children: <Widget>[
              SingleChildScrollView(
                  child: AnimatedBuilder(
                      animation: animationController,
                      child: Stack(
                        //mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Positioned(
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * .4,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF117772),
                                    //borderRadius: BorderRadius.only(bottomRight: Radius.circular(MediaQuery.of(context).size.width*.5),bottomLeft: Radius.circular(MediaQuery.of(context).size.width*.5)  )
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * .2,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF117772),
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .3),
                                          bottomLeft: Radius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .3))),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            child: Column(
                              children: [
                                _HeaderIconAndTextWidget(),
                                Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    margin:   EdgeInsets.only(
                                        left:MediaQuery.of(context).size.width*.1,
                                        right: MediaQuery.of(context).size.width*.1, ),
                                    child: Column(children: <Widget>[
                                        SizedBox(
                                        height:MediaQuery.of(context).size.height*.02,
                                      ),
                                      Text('مرحباً بكم في تطبيق حراج الشمال'),
                                       SizedBox(
                                        height: MediaQuery.of(context).size.height * .02,
                                      ),
                                      _CardWidget(
                                        nameController: nameController,
                                        phoneController: phoneController,
                                      ),

                                       SizedBox(
                                        height: MediaQuery.of(context).size.height * .02,
                                      ),
                                      Container(padding: EdgeInsets.all(10),
                                      child: Text(
                                        Utils.getString(context, 'login__agree_privacy'),
                                      ),),

                                      InkWell(
                                        child: Text(
                                            Utils.getString(context, 'login__agree_privacy2'),
                                            style: TextStyle(color: PsColors.mainColor,     decoration: TextDecoration.underline,)
                                        ),
                                        onTap: () {
                                          Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 1);
                                        },
                                      ),

                                       SizedBox(
                                         height: MediaQuery.of(context).size.height * .032,
                                      ),
                                      _SendButtonWidget(

                                        provider: provider,
                                        nameController: nameController,
                                        phoneController: phoneController,
                                        phoneSignInSelected:
                                            widget.phoneSignInSelected,
                                      ),
                                       SizedBox(
                                        height: MediaQuery.of(context).size.height * .016,
                                      ),
                                      InkWell(
                                        child: Container(
                                          child: Ink(
                                            color: PsColors.backgroundColor,
                                            child: Text(
                                              "لدي حساب",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(color: PsColors.black,     decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () {

                                          Navigator.pushReplacementNamed(
                                            context,
                                            RoutePaths.user_phone_signin_container,
                                          );

                                        },
                                      ),
                                      _TextWidget(
                                          goToLoginSelected:
                                          widget.goToLoginSelected),

                                       SizedBox(
                                        height: MediaQuery.of(context).size.height * .016,
                                      ),
                                    ])),
                              ],
                            ),
                          )
                        ],
                      ),
                      builder: (BuildContext context, Widget child) {
                        return FadeTransition(
                          opacity: animation,
                          child: Transform(
                              transform: Matrix4.translationValues(
                                  0.0, 100 * (1.0 - animation.value), 0.0),
                              child: child),
                        );
                      }))
            ],
          );
        }),
      ),
    );
  }
}



class _TextWidget extends StatefulWidget {
  const _TextWidget({this.goToLoginSelected});
  final Function goToLoginSelected;
  @override
  __TextWidgetState createState() => __TextWidgetState();
}

class __TextWidgetState extends State<_TextWidget> {
  @override
  Widget build(BuildContext context) {
    return

        InkWell(
          child: Container(
            child: Ink(
              color: PsColors.backgroundColor,
              child: Text(
                "المتابعة كزائر",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: PsColors.mainColor,     decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          onTap: () {
            if (widget.goToLoginSelected != null) {
              widget.goToLoginSelected();
            } else {
              /* Navigator.pushReplacementNamed(
                context,
                RoutePaths.home,
              ); */
              Navigator.push<MaterialPageRoute>(context, MaterialPageRoute(builder: (BuildContext context) => DashboardView()));

            }
          },
        )
      ;
  }
}

class _HeaderIconAndTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _textWidget = Text(
      Utils.getString(context, 'app_name'),
      style: Theme.of(context).textTheme.subtitle1.copyWith(
            color: PsColors.mainColor,
          ),
    );

    final Widget _imageWidget = Container(
      width: 150,
      height: 150,
      child: Image.asset(
        'assets/images/logo2.png',
      ),
    );
    return Column(
      children: <Widget>[
          SizedBox(
          height:MediaQuery.of(context).size.height*.03,
        ),
        Text(
          "تسجيل حساب جديد ",
          style: Theme.of(context)
              .textTheme
              .title
              .copyWith(color: PsColors.white, fontSize:MediaQuery.of(context).size.width*.061,
    ),
        ),
         SizedBox(
          height: MediaQuery.of(context).size.height * .018,
        ),
        _imageWidget,
         SizedBox(
          height: MediaQuery.of(context).size.height * .018,
        ),
      ],
    );
  }
}

class _CardWidget extends StatelessWidget {
  const _CardWidget(
      {@required this.nameController, @required this.phoneController});

  final TextEditingController nameController;
  final TextEditingController phoneController;
  @override
  Widget build(BuildContext context) {
    const EdgeInsets _marginEdgeInsetsforCard = EdgeInsets.only(
        left: PsDimens.space16,
        right: PsDimens.space16,
        top: PsDimens.space4,
        bottom: PsDimens.space4);
    return  Column(
        children: <Widget>[
          Container(
            margin: _marginEdgeInsetsforCard,
            padding:EdgeInsets.fromLTRB(15,0,15,0) ,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFE8E8E8), width: 2),
              borderRadius: BorderRadius.all(Radius.circular(30))

            ),
            child: TextField(
              controller: nameController,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "الإسم ثلاثي",
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: PsColors.black),
                  icon: Icon(PsColors.user_3,
                      color: Theme.of(context).iconTheme.color)),
            ),
          ),
          const Divider(
            height: PsDimens.space1,
          ),
          Container(
            margin: _marginEdgeInsetsforCard,
            padding:EdgeInsets.fromLTRB(15,0,15,0) ,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFE8E8E8), width: 2),
                borderRadius: BorderRadius.all(Radius.circular(30))

            ),
            child: Directionality(
              textDirection: Directionality.of(context) == TextDirection.ltr
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: TextField(
                controller: phoneController,
                textDirection: TextDirection.ltr,
                textAlign: Directionality.of(context) == TextDirection.ltr
                    ? TextAlign.left
                    : TextAlign.left,
                maxLength: 9,

                style: Theme.of(context).textTheme.button.copyWith(),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    counterText:"" ,

                    border: InputBorder.none,
                    suffixText: '966+',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: PsColors.black),
                    icon: Icon(PsColors.icons8_touchscreen,
                        color: Theme.of(context).iconTheme.color)),
                // keyboardType: TextInputType.number,
              ),
            ),
          ),
        ],
      );
  }
}

class _SendButtonWidget extends StatefulWidget {
  const _SendButtonWidget(
      {@required this.provider,
      @required this.nameController,
      @required this.phoneController,
      @required this.phoneSignInSelected});
  final UserProvider provider;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final Function phoneSignInSelected;

  @override
  __SendButtonWidgetState createState() => __SendButtonWidgetState();
}

dynamic callWarningDialog(BuildContext context, String text) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(
            message: Utils.getString(context, text), onPressed: () {});
      });
}

class __SendButtonWidgetState extends State<_SendButtonWidget> {
  Future<String> verifyPhone() async {
    print('g');
    String verificationId;
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      verificationId = verId;
      PsProgressDialog.dismissDialog();
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      print('h');
      verificationId = verId;
      print('code has been send');
      PsProgressDialog.dismissDialog();

      if (widget.phoneSignInSelected != null) {
        widget.phoneSignInSelected(widget.nameController.text,
            "+966"+widget.phoneController.text, verificationId);
      } else {
        Navigator.pushReplacementNamed(
            context, RoutePaths.user_phone_verify_container,
            arguments: VerifyPhoneIntentHolder(
                userName: widget.nameController.text,
                phoneNumber: "+966"+widget.phoneController.text,
                phoneId: verificationId));
      }
    };
    final PhoneVerificationCompleted verifySuccess = (AuthCredential user) {
      print('verify');
      PsProgressDialog.dismissDialog();
    };
    final PhoneVerificationFailed verifyFail =
        (FirebaseAuthException exception) {
      print('${exception.message}');
      PsProgressDialog.dismissDialog();
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: '${exception.message}',
            );
          });
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+966"+widget.phoneController.text,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(minutes: 2),
        verificationCompleted: verifySuccess,
        verificationFailed: verifyFail);
    return verificationId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:   EdgeInsets.only(
          left: MediaQuery.of(context).size.width*.21, right: MediaQuery.of(context).size.width*.21, ),
      child: PSButtonWidget(
          hasShadow: false,
          width: double.infinity,
          titleText: "متابعة",
          onPressed: () async {
            if (widget.nameController.text.isEmpty) {
              callWarningDialog(context,
                  Utils.getString(context, 'warning_dialog__input_name'));
            } else if (widget.phoneController.text.isEmpty) {
              callWarningDialog(context,
                  Utils.getString(context, 'warning_dialog__input_phone'));
            } else {
              await PsProgressDialog.showDialog(context);
              await verifyPhone();
            }
          }),
    );
  }
}
