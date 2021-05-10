import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/config/ps_config.dart';
import 'package:haraj/ui/item/list_with_filter/product_list_with_filter_view.dart';
import 'package:haraj/utils/utils.dart';
import 'package:haraj/viewobject/holder/product_parameter_holder.dart';
import 'package:flutter/material.dart';

class ProductListWithFilterContainerView extends StatefulWidget {
  const ProductListWithFilterContainerView(
      {@required this.productParameterHolder, @required this.appBarTitle});
  final ProductParameterHolder productParameterHolder;
  final String appBarTitle;
  @override
  _ProductListWithFilterContainerViewState createState() =>
      _ProductListWithFilterContainerViewState();
}

class _ProductListWithFilterContainerViewState
    extends State<ProductListWithFilterContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  String appBarTitleName;
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
  final ScrollController scrollController = ScrollController();
  void changeAppBarTitle(String categoryName) {
    appBarTitleName = categoryName;
  }

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
    print('insideeeee ${widget.productParameterHolder.getParamKey()}');
    return WillPopScope(
     // onWillPop: () async => false, //_onWillPop,

      child: Scaffold(
        appBar: AppBar(
          brightness: Utils.getBrightnessForAppBar(context),
          backgroundColor:
              Utils.isLightMode(context) ? PsColors.mainColor : Colors.black12,
          title: Text(
            appBarTitleName ?? widget.appBarTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: PsColors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 1,
        ),
        body: ProductListWithFilterView(
          scrollController: scrollController,
          animationController: animationController,
          productParameterHolder: widget.productParameterHolder,
          changeAppBarTitle: changeAppBarTitle,
        ),
      ),
    );
  }
}
