import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haraj/viewobject/common/ps_value_holder.dart';

class PsTextFieldWidgetWithIcon extends StatelessWidget {
  const PsTextFieldWidgetWithIcon(
      {this.textEditingController,
      this.hintText,
      this.height = PsDimens.space44,
      this.keyboardType = TextInputType.text,
      this.psValueHolder,
      this.clickEnterFunction,
      this.clickSearchButton});

  final TextEditingController textEditingController;
  final String hintText;
  final double height;
  final TextInputType keyboardType;
  final PsValueHolder psValueHolder;
   final Function clickEnterFunction;
  final Function clickSearchButton;

  @override
  Widget build(BuildContext context) {
    final Widget _productTextFieldWidget =
    TextField(
      keyboardType: TextInputType.text,
      maxLines: null,
      controller: textEditingController,
      style: Theme.of(context).textTheme.bodyText1,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          left: PsDimens.space8,
          bottom: PsDimens.space8,
          top: PsDimens.space10,
        ),
        border: InputBorder.none,
        hintText: hintText,

        suffixIcon: InkWell(
            child:Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(color: PsColors.mainColor, borderRadius: const BorderRadius.all(Radius.circular(100))),
              child:  Icon(
              Icons.search,
              color: PsColors.white,
            ),),
            onTap: () {
              clickSearchButton();
              // productParameterHolder.searchTerm = textEditingController.text;
              // Utils.psPrint(productParameterHolder.searchTerm);
              // Navigator.pushNamed(context, RoutePaths.filterProductList,
              //     arguments: ProductListIntentHolder(
              //         appBarTitle: Utils.getString(
              //             context, 'home_search__app_bar_title'),
              //         productParameterHolder: productParameterHolder));
            }),
      ),
      onSubmitted: (String value) {
        clickEnterFunction();
        // productParameterHolder.searchTerm = textEditingController.text;
        // Navigator.pushNamed(context, RoutePaths.filterProductList,
        //     arguments: ProductListIntentHolder(
        //         appBarTitle:
        //             Utils.getString(context, 'home_search__app_bar_title'),
        //         productParameterHolder: productParameterHolder));
      },
    );

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: height,
          margin: const EdgeInsets.all(PsDimens.space8),
          decoration: BoxDecoration(
            color: Utils.isLightMode(context) ? Colors.white60 : Colors.black54,
            borderRadius: BorderRadius.circular(PsDimens.space4),
            border: Border.all(
                color: Utils.isLightMode(context)
                    ? Colors.grey[200]
                    : Colors.black87),
          ),
          child: _productTextFieldWidget,
        ),
      ],
    );
  }
}
