import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/constant/route_paths.dart';
import 'package:haraj/ui/intro/plugin/dots_decorator.dart';
import 'package:haraj/ui/intro/plugin/page_decoration.dart';
import 'package:haraj/ui/intro/plugin/page_view_model.dart';
import 'package:haraj/utils/utils.dart';
import 'package:haraj/ui/intro/plugin/introduction_screen.dart';

class IntroView extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<IntroView> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd() {
    /* Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => HomePage()),
    );*/
    Navigator.pushReplacementNamed(
      context,
      RoutePaths.user_phone_register_container,
    );
  }

  Widget _buildImage(String assetName) {
    return Container(
      height: 300,
      decoration: BoxDecoration(

          image: DecorationImage(
            alignment: Alignment.topCenter,
              image: AssetImage('assets/images/intro/$assetName.png'),
              fit: BoxFit.fitWidth)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle bodyStyle = TextStyle(fontSize: 12, color: Colors.black,fontWeight: FontWeight.normal);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
          color: Color(0xFF117772)),
      bodyTextStyle: bodyStyle,
      //descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Utils.getString(context, 'app_name'),
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF117772)),
              )
            ],
          ),
          body:
              "هنالك العديد من الأنواع المتوفرة لنصوص لوريم إيبسوم، ولكن  الغالبية تم تعديلها بشكل ما عبر إدخال بعض النوادر أو الكلمات العشوائية إلى النص. إن كنت تريد أن تستخدم نص لوريم إيبسوم ما، عليك أن تتحقق أولاً أن ليس هناك أي كلمات أو عبارات محرجة أو غير لائقة مخبأة في هذا النص. بينما تعمل جميع مولّدات نصوص لوريم إيبسوم على الإنترنت على إعادة تكرار مقاطع من نص لوريم  إيبسوم ",
          image: _buildImage('ME'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: Utils.getString(context, 'app_name'),
          body:
              'نفسه عدة مرات بما تتطلبه الحاجة، يقوم مولّدنا هذا  باستخدام كلمات من قاموس يحوي على أكثر من 200 كلمة لا تينية،  مضاف إليها مجموعة من الجمل النموذجية، لتكوين نص لوريم إيبسوم ذو شكل منطقي قريب إلى النص الحقيقي. وبالتالي يكون النص الناتح خالي من التكرار، أو أي كلمات أو عبارات غير لائقة أو ما شابه. وهذا ما يجعله أول مولّد نص لوريم إيبسوم حقيقي على الإنترنت. ',
          image: _buildImage('ME'),
          decoration: pageDecoration,

        ),
      ],
      onDone: () => _onIntroEnd(),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('تخطي'),
      next: const Icon(Icons.arrow_forward),

      done: const Text('موافق', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.grey,
        activeSize: Size(20.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
