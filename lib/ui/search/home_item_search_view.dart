import 'package:haraj/api/common/ps_admob_banner_widget.dart';
import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/constant/ps_constants.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/constant/route_paths.dart';
import 'package:haraj/provider/entry/item_entry_provider.dart';
import 'package:haraj/provider/item_location/item_location_provider.dart';
import 'package:haraj/provider/product/search_product_provider.dart';
import 'package:haraj/repository/product_repository.dart';
import 'package:haraj/ui/common/ps_button_widget.dart';
import 'package:haraj/ui/common/ps_dropdown_base_widget.dart';
import 'package:haraj/ui/common/dialog/error_dialog.dart';
import 'package:haraj/ui/common/ps_dropdown_base_with_controller_widget.dart';
import 'package:haraj/ui/common/ps_special_check_text_widget.dart';
import 'package:haraj/utils/utils.dart';
import 'package:haraj/viewobject/Item_color.dart';
import 'package:haraj/viewobject/common/ps_value_holder.dart';
import 'package:haraj/viewobject/condition_of_item.dart';
import 'package:haraj/viewobject/holder/intent_holder/model_intent_holder.dart';
import 'package:haraj/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:haraj/viewobject/holder/product_parameter_holder.dart';
import 'package:haraj/viewobject/item_build_type.dart';
import 'package:haraj/viewobject/item_fuel_type.dart';
import 'package:haraj/viewobject/item_location.dart';
import 'package:haraj/viewobject/item_price_type.dart';
import 'package:haraj/viewobject/item_seller_type.dart';
import 'package:haraj/viewobject/item_type.dart';
import 'package:haraj/viewobject/manufacturer.dart';
import 'package:haraj/viewobject/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:haraj/viewobject/transmission.dart';
import 'package:provider/provider.dart';
import 'package:haraj/ui/common/ps_textfield_widget.dart';

class HomeItemSearchView extends StatefulWidget {
  const HomeItemSearchView({
    @required this.productParameterHolder,
    @required this.animation,
    @required this.animationController,
  });

  final ProductParameterHolder productParameterHolder;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  _ItemSearchViewState createState() => _ItemSearchViewState();
}

class _ItemSearchViewState extends State<HomeItemSearchView> {
  ProductRepository repo1;
  PsValueHolder valueHolder;
  SearchProductProvider _searchProductProvider;
/*
  final TextEditingController userInputItemNameTextEditingController =
      TextEditingController();
  final TextEditingController userInputMaximunPriceEditingController =
      TextEditingController();
  final TextEditingController userInputMinimumPriceEditingController =
      TextEditingController();*/

  @override
  Widget build(BuildContext context) {
    print(
        '............................Build UI Again ............................');

    final Widget _searchButtonWidget = PSButtonWidget(
      hasShadow: true,
      width: double.infinity,
      titleText: Utils.getString(context, 'home_search__search'),
      onPressed: () async {
        if (_searchProductProvider.manufacturerId != null) {
          _searchProductProvider.productParameterHolder.manufacturerId =
              _searchProductProvider.manufacturerId;
        }

        if (_searchProductProvider.itemLocationId != null) {
          _searchProductProvider.productParameterHolder.itemLocationId =
              _searchProductProvider.itemLocationId;
          print("ffff ${ _searchProductProvider.productParameterHolder.itemLocationId}");
        }/*
        if (_searchProductProvider.itemPriceTypeId != null) {
          _searchProductProvider.productParameterHolder.itemPriceTypeId =
              _searchProductProvider.itemPriceTypeId;
        }*/

        //print('userInputText' + userInputItemNameTextEditingController.text);
        print('rrrr ${_searchProductProvider.productParameterHolder.getParamKey()}');
         dynamic result =
            await Navigator.pushNamed(context, RoutePaths.filterProductList,
                arguments: ProductListIntentHolder(
                  appBarTitle:
                      Utils.getString(context, 'home_search__app_bar_title'),
                  productParameterHolder:
                      _searchProductProvider.productParameterHolder,
                ));

        if (result != null && result is ProductParameterHolder) {
          _searchProductProvider.productParameterHolder = result;
        }
      },
    );

    repo1 = Provider.of<ProductRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<SearchProductProvider>(
            lazy: false,
            create: (BuildContext content) {
              _searchProductProvider = SearchProductProvider(
                  repo: repo1, psValueHolder: valueHolder);
              _searchProductProvider.productParameterHolder =
                  widget.productParameterHolder;
              final String loginUserId =
                       Utils.checkUserLoginId(valueHolder);    
              _searchProductProvider.loadProductListByKey(
                  loginUserId,
                  _searchProductProvider.productParameterHolder);
              return _searchProductProvider;
            },
            child: Consumer<SearchProductProvider>(
              builder: (BuildContext context, SearchProductProvider provider,
                  Widget child) {
                if (_searchProductProvider.productList != null &&
                    _searchProductProvider.productList.data != null) {
                  widget.animationController.forward();
                  return SingleChildScrollView(
                    child: AnimatedBuilder(
                        animation: widget.animationController,
                        child: Container(
                          color: PsColors.baseColor,
                          child: Column(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                              Text("فلتر البحث", style: TextStyle(fontSize: 26),),
                              /*const PsAdMobBannerWidget(),
                              _ProductNameWidget(
                                userInputItemNameTextEditingController:
                                    userInputItemNameTextEditingController,
                              ),-*/
                              /*_PriceWidget(
                                userInputMinimumPriceEditingController:
                                    userInputMinimumPriceEditingController,
                                userInputMaximunPriceEditingController:
                                    userInputMaximunPriceEditingController,
                              ),*/
                              PsDropdownBaseWidget(
                                  title: Utils.getString(
                                      context, 'search__manufacturer'),
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedManufacturerName,
                                  onTap: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);

                                    final dynamic manufacturerResult =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.manufacturer,
                                            arguments: provider
                                                .selectedManufacturerName);

                                    if (manufacturerResult != null &&
                                        manufacturerResult is Manufacturer) {
                                      provider.manufacturerId =
                                          manufacturerResult.id;
                                      if (mounted) {
                                        setState(() {
                                          provider.selectedManufacturerName =
                                              manufacturerResult.name;
                                        });
                                      }
                                    }
                                    /*if (manufacturerResult) {
                                      provider.selectedManufacturerName = '';
                                    }*/
                                  }),
                              PsDropdownBaseWidget(
                                  title: "المدنية",
                                  selectedText:
                                      Provider.of<SearchProductProvider>(
                                              context,
                                              listen: false)
                                          .selectedLocationName,
                                  onTap: () async {



                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    final SearchProductProvider provider =
                                        Provider.of<SearchProductProvider>(
                                            context,
                                            listen: false);

                                    final dynamic locationResult =
                                        await Navigator.pushNamed(
                                            context, RoutePaths.itemLocation,
                                            arguments: provider
                                                .selectedLocationName);

                                    if (locationResult != null &&
                                        locationResult is ItemLocation) {
                                      provider.itemLocationId =
                                          locationResult.id;
                                      if (mounted) {
                                        setState(() {
                                          provider.selectedLocationName =
                                              locationResult.name;
                                          print("klkl${provider.itemLocationId}");
                                        });
                                      }
                                    }
                                    /*if (locationResult) {
                                      provider.selectedLocationName = '';
                                    }*/
                                  }),
                              Container(
                                  margin: const EdgeInsets.only(
                                      left: PsDimens.space16,
                                      top: PsDimens.space16,
                                      right: PsDimens.space16,
                                      bottom: PsDimens.space40),
                                  child: _searchButtonWidget),
                            ],
                          ),
                        ),
                        builder: (BuildContext context, Widget child) {
                          return FadeTransition(
                              opacity: widget.animation,
                              child: Transform(
                                  transform: Matrix4.translationValues(
                                      0.0,
                                      100 * (1.0 - widget.animation.value),
                                      0.0),
                                  child: child));
                        }),
                  );
                } else {
                  return Container();
                }
              },
            )));
  }
}
