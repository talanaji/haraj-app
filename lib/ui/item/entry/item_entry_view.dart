import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:haraj/api/common/ps_resource.dart';
import 'package:haraj/api/common/ps_status.dart';
import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/config/ps_config.dart';
import 'package:haraj/constant/ps_constants.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/constant/route_paths.dart';
import 'package:haraj/provider/entry/item_entry_provider.dart';
import 'package:haraj/provider/gallery/gallery_provider.dart';
import 'package:haraj/repository/gallery_repository.dart';
import 'package:haraj/repository/product_repository.dart';
import 'package:haraj/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:haraj/ui/common/dialog/choose_camera_type_dialog.dart';
import 'package:haraj/ui/common/dialog/error_dialog.dart';
import 'package:haraj/ui/common/dialog/success_dialog.dart';
import 'package:haraj/ui/common/dialog/warning_dialog_view.dart';
import 'package:haraj/ui/common/ps_button_widget.dart';
import 'package:haraj/ui/common/ps_dropdown_base_with_controller_widget.dart';
import 'package:haraj/ui/common/ps_textfield_widget.dart';
import 'package:haraj/ui/common/ps_ui_widget.dart';
import 'package:haraj/utils/ps_progress_dialog.dart';
import 'package:haraj/utils/utils.dart';
import 'package:haraj/viewobject/Item_color.dart';
import 'package:haraj/viewobject/common/ps_value_holder.dart';
import 'package:haraj/viewobject/condition_of_item.dart';
import 'package:haraj/viewobject/default_photo.dart';
import 'package:haraj/viewobject/holder/item_entry_parameter_holder.dart';
import 'package:haraj/viewobject/item_build_type.dart';
import 'package:haraj/viewobject/item_currency.dart';
import 'package:haraj/viewobject/item_fuel_type.dart';
import 'package:haraj/viewobject/item_location.dart';
import 'package:haraj/viewobject/manufacturer.dart';
import 'package:haraj/viewobject/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ItemEntryView extends StatefulWidget {
  const ItemEntryView(
      {Key key, this.flag, this.item, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  final String flag;
  final Product item;

  @override
  State<StatefulWidget> createState() => _ItemEntryViewState();
}

class _ItemEntryViewState extends State<ItemEntryView> {
  ProductRepository repo1;
  GalleryRepository galleryRepository;
  ItemEntryProvider _itemEntryProvider;
  GalleryProvider galleryProvider;
  PsValueHolder valueHolder;

  /// user input info
  ///ads title
  final TextEditingController userInputListingTitle = TextEditingController();

  final TextEditingController userInputTrimName = TextEditingController();
  final TextEditingController userInputPriceUnit = TextEditingController();

   final TextEditingController userInputDescription = TextEditingController();
  final TextEditingController userInputPrice = TextEditingController();

  /// api info
  final TextEditingController manufacturerController = TextEditingController();
/*
  final TextEditingController priceController = TextEditingController();
*/
  final TextEditingController dealOptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final double zoom = 16;
  bool bindDataFirstTime = true;
  // New Images From Image Picker
  List<Asset> images = <Asset>[];
  Asset firstSelectedImageAsset;
  Asset secondSelectedImageAsset;
  Asset thirdSelectedImageAsset;
  Asset fouthSelectedImageAsset;
  Asset fifthSelectedImageAsset;
  String firstCameraImagePath;
  String secondCameraImagePath;
  String thirdCameraImagePath;
  String fouthCameraImagePath;
  String fifthCameraImagePath;

  Asset defaultAssetImage;

  // New Images Checking from Image Picker
  bool isSelectedFirstImagePath = false;
  bool isSelectedSecondImagePath = false;
  bool isSelectedThirdImagePath = false;
  bool isSelectedFouthImagePath = false;
  bool isSelectedFifthImagePath = false;

  String isShopCheckbox = '1';

  // ProgressDialog progressDialog;

  // File file;

  @override
  Widget build(BuildContext context) {
    print(
        '............................Build UI Again ............................');
    valueHolder = Provider.of<PsValueHolder>(context);

    bool _isFirstDone = isSelectedFirstImagePath;
    bool _isSecondDone = isSelectedSecondImagePath;
    bool _isThirdDone = isSelectedThirdImagePath;
    bool _isFouthDone = isSelectedFouthImagePath;
    bool _isFifthDone = isSelectedFifthImagePath;
    Future<dynamic> uploadImage(String itemId) async {

      if (!PsProgressDialog.isShowing()) {
        if (!isSelectedFirstImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
                  Utils.getString(context, 'progressloading_image1_uploading'));
        }
      }

      if (isSelectedFirstImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await galleryProvider.postItemImageUpload(
                itemId,
                _itemEntryProvider.firstImageId,
                firstSelectedImageAsset == null
                    ? await Utils.getImageFileFromCameraImagePath(
                        firstCameraImagePath, PsConfig.uploadImageSize)
                    : await Utils.getImageFileFromAssets(
                        firstSelectedImageAsset, PsConfig.uploadImageSize));
        if (_apiStatus.data != null) {
          isSelectedFirstImagePath = false;
          _isFirstDone = isSelectedFirstImagePath;
          print('1 image uploaded');
          //secondCameraImagePath = "3232323";
          // if (isSelectedSecondImagePath ||
          //     isSelectedThirdImagePath ||
          //     isSelectedFouthImagePath ||
          //     isSelectedFifthImagePath) {
          //   await uploadImage(itemId);
          // }
        }
      }

      PsProgressDialog.dismissDialog();
      if (!PsProgressDialog.isShowing()) {
        if (!isSelectedSecondImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
                  Utils.getString(context, 'progressloading_image2_uploading'));
        }
      }

      if (isSelectedSecondImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await galleryProvider.postItemImageUpload(
                itemId,
                _itemEntryProvider.secondImageId,
                secondSelectedImageAsset == null
                    ? await Utils.getImageFileFromCameraImagePath(
                        secondCameraImagePath, PsConfig.uploadImageSize)
                    : await Utils.getImageFileFromAssets(
                        secondSelectedImageAsset, PsConfig.uploadImageSize));
        if (_apiStatus.data != null) {
          isSelectedSecondImagePath = false;
          _isSecondDone = isSelectedSecondImagePath;
          print('2 image uploaded');
          // if (isSelectedThirdImagePath ||
          //     isSelectedFouthImagePath ||
          //     isSelectedFifthImagePath) {
          //   await uploadImage(itemId);
          // }
        }
      }

      PsProgressDialog.dismissDialog();
      if (!PsProgressDialog.isShowing()) {
        if (!isSelectedThirdImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
                  Utils.getString(context, 'progressloading_image3_uploading'));
        }
      }

      if (isSelectedThirdImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await galleryProvider.postItemImageUpload(
                itemId,
                _itemEntryProvider.thirdImageId,
                thirdSelectedImageAsset == null
                    ? await Utils.getImageFileFromCameraImagePath(
                        thirdCameraImagePath, PsConfig.uploadImageSize)
                    : await Utils.getImageFileFromAssets(
                        thirdSelectedImageAsset, PsConfig.uploadImageSize));
        if (_apiStatus.data != null) {
          isSelectedThirdImagePath = false;
          _isThirdDone = isSelectedThirdImagePath;
          print('3 image uploaded');
          // if (isSelectedFouthImagePath || isSelectedFifthImagePath) {
          //   await uploadImage(itemId);
          // }
        }
      }

      PsProgressDialog.dismissDialog();
      if (!PsProgressDialog.isShowing()) {
        if (!isSelectedFouthImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
                  Utils.getString(context, 'progressloading_image4_uploading'));
        }
      }

      if (isSelectedFouthImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await galleryProvider.postItemImageUpload(
                itemId,
                _itemEntryProvider.fourthImageId,
                fouthSelectedImageAsset == null
                    ? await Utils.getImageFileFromCameraImagePath(
                        fouthCameraImagePath, PsConfig.uploadImageSize)
                    : await Utils.getImageFileFromAssets(
                        fouthSelectedImageAsset, PsConfig.uploadImageSize));
        if (_apiStatus.data != null) {
          isSelectedFouthImagePath = false;
          _isFouthDone = isSelectedFouthImagePath;
          print('4 image uploaded');
          // if (isSelectedFifthImagePath) {
          //   await uploadImage(itemId);
          // }
        }
      }

      PsProgressDialog.dismissDialog();
      if (!PsProgressDialog.isShowing()) {
        if (!isSelectedFifthImagePath) {
          PsProgressDialog.dismissDialog();
        } else {
          await PsProgressDialog.showDialog(context,
              message:
                  Utils.getString(context, 'progressloading_image5_uploading'));
        }
      }

      if (isSelectedFifthImagePath) {
        final PsResource<DefaultPhoto> _apiStatus =
            await galleryProvider.postItemImageUpload(
                itemId,
                _itemEntryProvider.fiveImageId,
                fifthSelectedImageAsset == null
                    ? await Utils.getImageFileFromCameraImagePath(
                        fifthCameraImagePath, PsConfig.uploadImageSize)
                    : await Utils.getImageFileFromAssets(
                        fifthSelectedImageAsset, PsConfig.uploadImageSize));
        if (_apiStatus.data != null) {
          print('5 image uploaded');
          isSelectedFifthImagePath = false;
          _isFifthDone = isSelectedFifthImagePath;
        }
      }

      // Fluttertoast.showToast(
      //     msg: 'Item Uploaded',
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.blueGrey,
      //     textColor: Colors.white);
      // // progressDialog.dismiss();
      PsProgressDialog.dismissDialog();
      // showDialog<dynamic>(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return SuccessDialog(
      //         message: Utils.getString(context, 'Item Uploaded'),
      //         onPressed: () {
      //           Navigator.pop(context);
      //         },
      //       );
      //     });
      if (!(_isFirstDone ||
          _isSecondDone ||
          _isThirdDone ||
          _isFouthDone ||
          _isFifthDone)) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return SuccessDialog(
                message: Utils.getString(context, 'item_entry_item_uploaded'),
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, RoutePaths.home,
                       );
                },
              );
            });
      }
      return;
    }

    dynamic updateImagesFromCustomCamera(String imagePath, int index) {
      if (mounted) {
        setState(() {
          //for single select image
          if (index == 0 && imagePath.isNotEmpty) {
            firstCameraImagePath = imagePath;
            isSelectedFirstImagePath = true;
          }
          if (index == 1 && imagePath.isNotEmpty) {
            secondCameraImagePath = imagePath;
            isSelectedSecondImagePath = true;
          }
          if (index == 2 && imagePath.isNotEmpty) {
            thirdCameraImagePath = imagePath;
            isSelectedThirdImagePath = true;
          }
          if (index == 3 && imagePath.isNotEmpty) {
            fouthCameraImagePath = imagePath;
            isSelectedFouthImagePath = true;
          }
          if (index == 4 && imagePath.isNotEmpty) {
            fifthCameraImagePath = imagePath;
            isSelectedFifthImagePath = true;
          }
          //end single select image
        });
      }
    }

    dynamic updateImages(List<Asset> resultList, int index) {
      if (index == -1) {
        firstSelectedImageAsset = defaultAssetImage;
        secondSelectedImageAsset = defaultAssetImage;
        thirdSelectedImageAsset = defaultAssetImage;
        fouthSelectedImageAsset = defaultAssetImage;
        fifthSelectedImageAsset = defaultAssetImage;
      }
      if (mounted) {
        setState(() {
          images = resultList;
          if (resultList.isEmpty) {
            firstSelectedImageAsset = defaultAssetImage;
            isSelectedFirstImagePath = false;
            secondSelectedImageAsset = defaultAssetImage;
            isSelectedSecondImagePath = false;
            thirdSelectedImageAsset = defaultAssetImage;
            isSelectedThirdImagePath = false;
            fouthSelectedImageAsset = defaultAssetImage;
            isSelectedFouthImagePath = false;
            fifthSelectedImageAsset = defaultAssetImage;
            isSelectedFifthImagePath = false;
          }
          //for single select image
          if (index == 0 && resultList.isNotEmpty) {
            firstSelectedImageAsset = resultList[0];
            isSelectedFirstImagePath = true;
          }
          if (index == 1 && resultList.isNotEmpty) {
            secondSelectedImageAsset = resultList[0];
            isSelectedSecondImagePath = true;
          }
          if (index == 2 && resultList.isNotEmpty) {
            thirdSelectedImageAsset = resultList[0];
            isSelectedThirdImagePath = true;
          }
          if (index == 3 && resultList.isNotEmpty) {
            fouthSelectedImageAsset = resultList[0];
            isSelectedFouthImagePath = true;
          }
          if (index == 4 && resultList.isNotEmpty) {
            fifthSelectedImageAsset = resultList[0];
            isSelectedFifthImagePath = true;
          }
          //end single select image

          //for multi select
          if (index == -1 && resultList.length == 1) {
            firstSelectedImageAsset = resultList[0];
            isSelectedFirstImagePath = true;
          }
          if (index == -1 && resultList.length == 2) {
            firstSelectedImageAsset = resultList[0];
            secondSelectedImageAsset = resultList[1];
            isSelectedFirstImagePath = true;
            isSelectedSecondImagePath = true;
          }
          if (index == -1 && resultList.length == 3) {
            firstSelectedImageAsset = resultList[0];
            secondSelectedImageAsset = resultList[1];
            thirdSelectedImageAsset = resultList[2];
            isSelectedFirstImagePath = true;
            isSelectedSecondImagePath = true;
            isSelectedThirdImagePath = true;
          }
          if (index == -1 && resultList.length == 4) {
            firstSelectedImageAsset = resultList[0];
            secondSelectedImageAsset = resultList[1];
            thirdSelectedImageAsset = resultList[2];
            fouthSelectedImageAsset = resultList[3];
            isSelectedFirstImagePath = true;
            isSelectedSecondImagePath = true;
            isSelectedThirdImagePath = true;
            isSelectedFouthImagePath = true;
          }
          if (index == -1 && resultList.length == 5) {
            firstSelectedImageAsset = resultList[0];
            secondSelectedImageAsset = resultList[1];
            thirdSelectedImageAsset = resultList[2];
            fouthSelectedImageAsset = resultList[3];
            fifthSelectedImageAsset = resultList[4];
            isSelectedFirstImagePath = true;
            isSelectedSecondImagePath = true;
            isSelectedThirdImagePath = true;
            isSelectedFouthImagePath = true;
            isSelectedFifthImagePath = true;
          }
          //end multi select

          // if (index >= 0 && galleryProvider.selectedImageList.length > index) {
          //   galleryProvider.selectedImageList.removeAt(index);
          // }
        });
      }
    }

    repo1 = Provider.of<ProductRepository>(context);
    galleryRepository = Provider.of<GalleryRepository>(context);
    widget.animationController.forward();

    final Widget _uploadItemWidget = Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space16,
            right: PsDimens.space16,
            top: PsDimens.space16,
            bottom: PsDimens.space48),
        width: double.infinity,
        height: PsDimens.space44,
        child: PSButtonWidget(
          hasShadow: true,
          width: double.infinity,
          titleText: Utils.getString(context, 'login__submit'),
          onPressed: () async {
            if (!isSelectedFirstImagePath &&
                !isSelectedSecondImagePath &&
                !isSelectedThirdImagePath &&
                !isSelectedFouthImagePath &&
                !isSelectedFifthImagePath &&
                galleryProvider.galleryList.data.isEmpty) {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message:
                        Utils.getString(context, 'item_entry_need_image'),
                        onPressed: () {});
                  });
            } else if (userInputListingTitle.text == null ||
                userInputListingTitle.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message: Utils.getString(
                            context, 'item_entry__need_listing_title'),
                        onPressed: () {});
                  });
            } else if (manufacturerController.text == null ||
                manufacturerController.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message: Utils.getString(
                            context, 'item_entry__need_manufacturer'),
                        onPressed: () {});
                  });
            }   /*else if (priceController.text == null ||
                priceController.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message: Utils.getString(
                            context, 'item_entry_need_currency_symbol'),
                        onPressed: () {});
                  });
            }*/ else if (userInputPrice.text == null ||
                userInputPrice.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message:
                        Utils.getString(context, 'item_entry_need_price'),
                        onPressed: () {});
                  });
            } else if (userInputDescription.text == null ||
                userInputDescription.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message: Utils.getString(
                            context, 'item_entry_need_description'),
                        onPressed: () {});
                  });
            }   else {
              if (!PsProgressDialog.isShowing()) {
                await PsProgressDialog.showDialog(context,
                    message: Utils.getString(
                        context, 'progressloading_item_uploading'));

              }
              if (widget.flag == PsConst.ADD_NEW_ITEM) {
                //add new
                final ItemEntryParameterHolder itemEntryParameterHolder =
                ItemEntryParameterHolder(
                  manufacturerId: _itemEntryProvider.manufacturerId,
                  itemPriceTypeId: _itemEntryProvider.itemPriceTypeId,
                  itemCurrencyId: _itemEntryProvider.itemCurrencyId,
                  itemLocationId: _itemEntryProvider.itemLocationId,
                  description: userInputDescription.text,
                  price: userInputPrice.text,
                  title: userInputListingTitle.text,
                  // licenceStatus: widget.provider.licenceStatus,
                  id: _itemEntryProvider.itemId,
                  addedUserId: _itemEntryProvider.psValueHolder.loginUserId,
                );

                final PsResource<Product> itemData = await _itemEntryProvider
                    .postItemEntry(itemEntryParameterHolder.toMap());
                PsProgressDialog.dismissDialog();

                if (itemData.status == PsStatus.SUCCESS) {
                  _itemEntryProvider.itemId = itemData.data.id;
                  if (itemData.data != null) {
                    if (isSelectedFirstImagePath ||
                        isSelectedSecondImagePath ||
                        isSelectedThirdImagePath ||
                        isSelectedFouthImagePath ||
                        isSelectedFifthImagePath) {
                      uploadImage(itemData.data.id);
                    }
                  }
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: itemData.message,
                        );
                      });
                }
              } else {
                // edit item

                final ItemEntryParameterHolder itemEntryParameterHolder =
                ItemEntryParameterHolder(
                  manufacturerId: _itemEntryProvider.manufacturerId,
                  itemPriceTypeId:_itemEntryProvider.itemPriceTypeId,
                  itemCurrencyId: _itemEntryProvider.itemCurrencyId,
                  itemLocationId: _itemEntryProvider.itemLocationId,
                  description: userInputDescription.text,
                  price: userInputPrice.text,
                  title: userInputListingTitle.text,
                  // licenceStatus: widget.provider.licenceStatus,
                  id: widget.item.id,
                  addedUserId: _itemEntryProvider.psValueHolder.loginUserId,
                );

                final PsResource<Product> itemData = await _itemEntryProvider
                    .postItemEntry(itemEntryParameterHolder.toMap());
                PsProgressDialog.dismissDialog();
                if (itemData.status == PsStatus.SUCCESS) {
                  if (itemData.data != null) {
                    Fluttertoast.showToast(
                        msg: 'Item Uploaded',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white);

                    if (isSelectedFirstImagePath ||
                        isSelectedSecondImagePath ||
                        isSelectedThirdImagePath ||
                        isSelectedFouthImagePath ||
                        isSelectedFifthImagePath) {
                      uploadImage(itemData.data.id);
                    }
                  }
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: itemData.message,
                        );
                      });
                }
              }
            }
          },
        ));
    return PsWidgetWithMultiProvider(
      child: MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<ItemEntryProvider>(
                lazy: false,
                create: (BuildContext context) {
                  _itemEntryProvider = ItemEntryProvider(
                      repo: repo1, psValueHolder: valueHolder);

                  _itemEntryProvider.item = widget.item;

                  /*latlng = LatLng(
                      double.parse(
                          _itemEntryProvider.psValueHolder.locationLat),
                      double.parse(
                          _itemEntryProvider.psValueHolder.locationLng));*/
                  if (_itemEntryProvider.itemLocationId != null ||
                      _itemEntryProvider.itemLocationId != '')
                    _itemEntryProvider.itemLocationId =
                        _itemEntryProvider.psValueHolder.locationId;

                  _itemEntryProvider.getItemFromDB(widget.item.id);

                  return _itemEntryProvider;
                }),
            ChangeNotifierProvider<GalleryProvider>(
                lazy: false,
                create: (BuildContext context) {
                  galleryProvider = GalleryProvider(repo: galleryRepository);
                  if (widget.flag == PsConst.EDIT_ITEM) {
                    galleryProvider.loadImageList(
                        widget.item.defaultPhoto.imgParentId,
                        PsConst.ITEM_TYPE);
                  }
                  return galleryProvider;
                }),
          ],
          child: SingleChildScrollView(
            child: AnimatedBuilder(
                animation: widget.animationController,
                child: Container(
                  color: PsColors.backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Consumer<ItemEntryProvider>(builder:
                          (BuildContext context, ItemEntryProvider provider,
                          Widget child) {
                        if (provider != null &&
                            provider.item != null &&
                            provider.item.id != null) {
                          if (bindDataFirstTime) {
                            userInputListingTitle.text = provider.item.title;
                            manufacturerController.text =
                                provider.item.manufacturer.name;

                            userInputDescription.text =
                                provider.item.description;
                            // userInputDealOptionText.text =
                            //     provider.item.data.dealOptionRemark;
                            userInputPrice.text = provider.item.price;
                            /*priceController.text =
                                provider.item.itemCurrency.currencySymbol;*/
                            locationController.text =
                                provider.item.itemLocation.name;

                            provider.manufacturerId =
                                provider.item.manufacturer.id;

                            /*provider.itemCurrencyId =
                                provider.item.itemCurrency.id;*/
                            provider.itemLocationId =
                                provider.item.itemLocation.id;
                            provider.itemPriceTypeId =
                                provider.item.itemPriceType.id;
                            bindDataFirstTime = false;

                          }
                        }
                        return AllControllerTextWidget(
                          userInputListingTitle: userInputListingTitle,
                          userInputPriceUnit: userInputPriceUnit,
                          manufacturerController: manufacturerController,
                          //priceController: priceController,
                          userInputDescription: userInputDescription,
                          locationController: locationController,
                          userInputPrice: userInputPrice,
                          zoom: zoom,
                          flag: widget.flag,
                          item: widget.item,
                          provider: provider,
                          galleryProvider: galleryProvider,
                          uploadImage: (String itemId) {
                            // if (firstSelectedImageAsset != null) {
                            //   isSelectedFirstImagePath = true;
                            // }
                            // if (firstSelectedImageAsset != null &&
                            //     secondSelectedImageAsset != null) {
                            //   isSelectedFirstImagePath = true;
                            //   isSelectedSecondImagePath = true;
                            // }
                            // if (firstSelectedImageAsset != null &&
                            //     secondSelectedImageAsset != null &&
                            //     thirdSelectedImageAsset != null) {
                            //   isSelectedFirstImagePath = true;
                            //   isSelectedSecondImagePath = true;
                            //   isSelectedThirdImagePath = true;
                            // }

                            // if (firstSelectedImageAsset != null &&
                            //     secondSelectedImageAsset != null &&
                            //     thirdSelectedImageAsset != null &&
                            //     fouthSelectedImageAsset != null) {
                            //   isSelectedFirstImagePath = true;
                            //   isSelectedSecondImagePath = true;
                            //   isSelectedThirdImagePath = true;
                            //   isSelectedFouthImagePath = true;
                            // }
                            // if (firstSelectedImageAsset != null &&
                            //     secondSelectedImageAsset != null &&
                            //     thirdSelectedImageAsset != null &&
                            //     fouthSelectedImageAsset != null &&
                            //     fifthSelectedImageAsset != null) {
                            //   isSelectedFirstImagePath = true;
                            //   isSelectedSecondImagePath = true;
                            //   isSelectedThirdImagePath = true;
                            //   isSelectedFouthImagePath = true;
                            //   isSelectedFifthImagePath = true;
                            // }
                            if (isSelectedFirstImagePath ||
                                isSelectedSecondImagePath ||
                                isSelectedThirdImagePath ||
                                isSelectedFouthImagePath ||
                                isSelectedFifthImagePath) {
                              uploadImage(itemId);
                            }
                          },
                          isSelectedFirstImagePath: isSelectedFirstImagePath,
                          isSelectedSecondImagePath: isSelectedSecondImagePath,
                          isSelectedThirdImagePath: isSelectedThirdImagePath,
                          isSelectedFouthImagePath: isSelectedFouthImagePath,
                          isSelectedFifthImagePath: isSelectedFifthImagePath,
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: PsDimens.space16,
                            left: PsDimens.space10,
                            right: PsDimens.space10,
                            bottom: PsDimens.space10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                  Utils.getString(context,
                                      'item_entry__choose_photo_showcase'),
                                  style: Theme.of(context).textTheme.bodyText2),
                            ),
                            Text(' *',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: PsColors.mainColor))
                          ],
                        ),
                      ),
                      //  _largeSpacingWidget,
                      Consumer<GalleryProvider>(builder: (BuildContext context,
                          GalleryProvider provider, Widget child) {
                        if (provider != null &&
                            provider.galleryList.data.isNotEmpty) {
                          for (int imageId = 0;
                              imageId < provider.galleryList.data.length;
                              imageId++) {
                            if (imageId == 0) {
                              _itemEntryProvider.firstImageId =
                                  provider.galleryList.data[imageId].imgId;
                            }
                            if (imageId == 1) {
                              _itemEntryProvider.secondImageId =
                                  provider.galleryList.data[imageId].imgId;
                            }
                            if (imageId == 2) {
                              _itemEntryProvider.thirdImageId =
                                  provider.galleryList.data[imageId].imgId;
                            }
                            if (imageId == 3) {
                              _itemEntryProvider.fourthImageId =
                                  provider.galleryList.data[imageId].imgId;
                            }
                            if (imageId == 4) {
                              _itemEntryProvider.fiveImageId =
                                  provider.galleryList.data[imageId].imgId;
                            }
                          }
                        }

                        return ImageUploadHorizontalList(
                          flag: widget.flag,
                          images: images,
                          selectedImageList: galleryProvider.selectedImageList,
                          updateImages: updateImages,
                          updateImagesFromCustomCamera:
                              updateImagesFromCustomCamera,
                          firstImagePath: firstSelectedImageAsset,
                          secondImagePath: secondSelectedImageAsset,
                          thirdImagePath: thirdSelectedImageAsset,
                          fouthImagePath: fouthSelectedImageAsset,
                          fifthImagePath: fifthSelectedImageAsset,
                          firstCameraImagePath: firstCameraImagePath,
                          secondCameraImagePath: secondCameraImagePath,
                          thirdCameraImagePath: thirdCameraImagePath,
                          fouthCameraImagePath: fouthCameraImagePath,
                          fifthCameraImagePath: fifthCameraImagePath,
                        );
                      }),

                      _uploadItemWidget
                    ],
                  ),
                ),
                builder: (BuildContext context, Widget child) {
                  return child;
                }),
          )),
    );

  }

}

class AllControllerTextWidget extends StatefulWidget {
  const AllControllerTextWidget({
    Key key,
    this.userInputListingTitle,
    this.userInputPriceUnit,
    this.manufacturerController,
    this.priceTypeController,
    this.priceController,
    this.userInputDescription,
    this.locationController,
    this.userInputPrice,
    this.provider,
    this.zoom,
    this.flag,
    this.item,
    this.uploadImage,
    this.galleryProvider,
    this.isSelectedFirstImagePath,
    this.isSelectedSecondImagePath,
    this.isSelectedThirdImagePath,
    this.isSelectedFouthImagePath,
    this.isSelectedFifthImagePath,
  }) : super(key: key);

  final TextEditingController userInputListingTitle;
  final TextEditingController userInputPriceUnit;
  final TextEditingController manufacturerController;
  final TextEditingController priceTypeController;
  final TextEditingController priceController;
  final TextEditingController userInputDescription;
  final TextEditingController locationController;
  final TextEditingController userInputPrice;
  final ItemEntryProvider provider;
  final double zoom;
  final String flag;
  final Product item;
  final Function uploadImage;
  final GalleryProvider galleryProvider;
  final bool isSelectedFirstImagePath;
  final bool isSelectedSecondImagePath;
  final bool isSelectedThirdImagePath;
  final bool isSelectedFouthImagePath;
  final bool isSelectedFifthImagePath;

  @override
  _AllControllerTextWidgetState createState() =>
      _AllControllerTextWidgetState();
}

class _AllControllerTextWidgetState extends State<AllControllerTextWidget> {
  PsValueHolder valueHolder;
  ItemEntryProvider itemEntryProvider;

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    itemEntryProvider = Provider.of<ItemEntryProvider>(context, listen: false);
    ((widget.flag == PsConst.ADD_NEW_ITEM &&
                widget.locationController.text ==
                    itemEntryProvider.psValueHolder.locactionName) ||
            (widget.flag == PsConst.ADD_NEW_ITEM &&
                widget.locationController.text.isEmpty))
        ? widget.locationController.text =
            itemEntryProvider.psValueHolder.locactionName
        : Container();


    return Column(children: <Widget>[
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__listing_title'),
        textAboutMe: false,
        hintText: Utils.getString(context, 'item_entry__entry_title'),
        textEditingController: widget.userInputListingTitle,
        isStar: true,
      ),
      PsDropdownBaseWithControllerWidget(
        title: Utils.getString(context, 'item_entry__manufacture'),
        textEditingController: widget.manufacturerController,
        isStar: true,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          final ItemEntryProvider provider =
              Provider.of<ItemEntryProvider>(context, listen: false);

          final dynamic categoryResult = await Navigator.pushNamed(
              context, RoutePaths.manufacturer,
              arguments: widget.manufacturerController.text);

          if (categoryResult != null && categoryResult is Manufacturer) {
            provider.manufacturerId = categoryResult.id;
            widget.manufacturerController.text = categoryResult.name;
            if (mounted) {
              setState(() {
                widget.manufacturerController.text = categoryResult.name;
               });
            }
          } else if (categoryResult) {
            widget.manufacturerController.text = '';
          }
        },
      ),

      PsDropdownBaseWithControllerWidget(
          title: Utils.getString(context, 'item_entry__location'),
          // selectedText: provider.selectedItemLocation == ''
          //     ? provider.psValueHolder.locactionName
          //     : provider.selectedItemLocation,

          textEditingController:
          // locationController.text == ''
          // ?
          // provider.psValueHolder.locactionName
          // :
          widget.locationController,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final ItemEntryProvider provider =
            Provider.of<ItemEntryProvider>(context, listen: false);

            final dynamic itemLocationResult = await Navigator.pushNamed(
                context, RoutePaths.itemLocation,
                arguments: widget.locationController.text);

            if (itemLocationResult != null &&
                itemLocationResult is ItemLocation) {
              provider.itemLocationId = itemLocationResult.id;
              if (mounted) {
                setState(() {
                  widget.locationController.text = itemLocationResult.name;


                  // tappedPoints = <LatLng>[];
                  // tappedPoints.add(latlng);
                });
              }
            }
          }),
      PriceDropDownControllerWidget(
          currencySymbolController: widget.priceController,
          userInputPriceController: widget.userInputPrice),
      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__description'),
        height: PsDimens.space80,
        hintText: Utils.getString(context, 'item_entry__description'),
        textAboutMe: true,
        textEditingController: widget.userInputDescription,
        isStar: true,
      ),
      // Column(
      //   children: <Widget>[
      //     PsDropdownBaseWithControllerWidget(
      //         title: Utils.getString(context, 'item_entry__deal_option'),
      //         textEditingController: widget.dealOptionController,
      //         isStar: true,
      //         onTap: () async {
      //           FocusScope.of(context).requestFocus(FocusNode());
      //           final ItemEntryProvider provider =
      //               Provider.of<ItemEntryProvider>(context, listen: false);

      //           final dynamic itemDealOptionResult = await Navigator.pushNamed(
      //               context, RoutePaths.itemDealOption);

      //           if (itemDealOptionResult != null &&
      //               itemDealOptionResult is DealOption) {
      //             provider.itemDealOptionId = itemDealOptionResult.id;

      //             setState(() {
      //               widget.dealOptionController.text =
      //                   itemDealOptionResult.name;
      //             });
      //           }
      //         }),
      //     Container(
      //       width: double.infinity,
      //       height: PsDimens.space44,
      //       margin: const EdgeInsets.only(
      //           left: PsDimens.space8,
      //           right: PsDimens.space8,
      //           bottom: PsDimens.space8),
      //       decoration: BoxDecoration(
      //         color:
      //             Utils.isLightMode(context) ? Colors.white60 : Colors.black54,
      //         borderRadius: BorderRadius.circular(PsDimens.space4),
      //         border: Border.all(
      //             color: Utils.isLightMode(context)
      //                 ? Colors.grey[200]
      //                 : Colors.black87),
      //       ),
      //       child: TextField(
      //         keyboardType: TextInputType.text,
      //         maxLines: null,
      //         controller: widget.userInputDealOptionText,
      //         style: Theme.of(context).textTheme.bodyText1,
      //         decoration: InputDecoration(
      //           contentPadding: const EdgeInsets.only(
      //             left: PsDimens.space8,
      //             bottom: PsDimens.space8,
      //           ),
      //           border: InputBorder.none,
      //           hintText: Utils.getString(context, 'item_entry__remark'),
      //           hintStyle: Theme.of(context)
      //               .textTheme
      //               .bodyText1
      //               .copyWith(color: PsColors.textPrimaryLightColor),
      //         ),
      //       ),
      //     )
      //   ],
      // ),
    ]);
  }


}

class ImageUploadHorizontalList extends StatefulWidget {
  const ImageUploadHorizontalList(
      {@required this.flag,
      @required this.images,
      @required this.selectedImageList,
      @required this.updateImages,
      @required this.updateImagesFromCustomCamera,
      @required this.firstImagePath,
      @required this.secondImagePath,
      @required this.thirdImagePath,
      @required this.fouthImagePath,
      @required this.fifthImagePath,
      @required this.firstCameraImagePath,
      @required this.secondCameraImagePath,
      @required this.thirdCameraImagePath,
      @required this.fouthCameraImagePath,
      @required this.fifthCameraImagePath});
  final String flag;
  final List<Asset> images;
  final List<DefaultPhoto> selectedImageList;
  final Function updateImages;
  final Function updateImagesFromCustomCamera;
  final Asset firstImagePath;
  final Asset secondImagePath;
  final Asset thirdImagePath;
  final Asset fouthImagePath;
  final Asset fifthImagePath;
  final String firstCameraImagePath;
  final String secondCameraImagePath;
  final String thirdCameraImagePath;
  final String fouthCameraImagePath;
  final String fifthCameraImagePath;
  @override
  State<StatefulWidget> createState() {
    return ImageUploadHorizontalListState();
  }
}

class ImageUploadHorizontalListState extends State<ImageUploadHorizontalList> {
  ItemEntryProvider provider;
  Future<void> loadPickMultiImage() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        // selectedAssets: null, //widget.images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: 'chat'),
        materialOptions: MaterialOptions(
          actionBarColor: Utils.convertColorToString(PsColors.black),
          actionBarTitleColor: Utils.convertColorToString(PsColors.white),
          statusBarColor: Utils.convertColorToString(PsColors.black),
          lightStatusBar: false,
          actionBarTitle: '',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor:
              Utils.convertColorToString(PsColors.mainColor),
        ),
      );
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    for (int i = 0; i < resultList.length; i++) {
      if (resultList[i].name.contains('.webp')) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__webp_image'),
              );
            });
        return;
      }
    }
    widget.updateImages(resultList, -1);
  }

  Future<void> loadSingleImage(int index) async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: widget.images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: 'chat'),
        materialOptions: MaterialOptions(
          actionBarColor: Utils.convertColorToString(PsColors.black),
          actionBarTitleColor: Utils.convertColorToString(PsColors.white),
          statusBarColor: Utils.convertColorToString(PsColors.black),
          lightStatusBar: false,
          actionBarTitle: '',
          allViewTitle: 'All Photos',
          useDetailsView: false,
          selectCircleStrokeColor:
              Utils.convertColorToString(PsColors.mainColor),
        ),
      );
    } on Exception catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }
    for (int i = 0; i < resultList.length; i++) {
      if (resultList[i].name.contains('.webp')) {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__webp_image'),
              );
            });
        return;
      } else {
        widget.updateImages(resultList, index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Asset defaultAssetImage;
    DefaultPhoto defaultUrlImage;
    provider = Provider.of<ItemEntryProvider>(context, listen: false);

    return Container(
      height: PsDimens.space80,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: <Widget>[
                ItemEntryImageWidget(
                  index: 0,
                  images: (widget.firstImagePath != null)
                      ? widget.firstImagePath
                      : defaultAssetImage,
                  cameraImagePath: (widget.firstCameraImagePath != null)
                      ? widget.firstCameraImagePath
                      : defaultAssetImage,
                  selectedImage: (widget.selectedImageList.isNotEmpty &&
                          widget.firstImagePath == null &&
                          widget.firstCameraImagePath == null)
                      ? widget.selectedImageList[0]
                      : null,
                  // (widget.firstImagePath != null) ? null : defaultUrlImage,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (provider.psValueHolder.isCustomCamera ?? true) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ChooseCameraTypeDialog(
                              onCameraTap: () async {
                                final dynamic returnData =
                                    await Navigator.pushNamed(
                                        context, RoutePaths.cameraView);
                                if (returnData is String) {
                                  widget.updateImagesFromCustomCamera(
                                      returnData, 0);
                                }
                              },
                              onGalleryTap: () {
                                if (widget.flag == PsConst.ADD_NEW_ITEM) {
                                  loadPickMultiImage();
                                } else {
                                  loadSingleImage(0);
                                }
                              },
                            );
                          });
                    } else {
                      if (widget.flag == PsConst.ADD_NEW_ITEM) {
                        loadPickMultiImage();
                      } else {
                        loadSingleImage(0);
                      }
                    }
                  },
                ),
                ItemEntryImageWidget(
                  index: 1,
                  images: (widget.secondImagePath != null)
                      ? widget.secondImagePath
                      : defaultAssetImage,
                  cameraImagePath: (widget.secondCameraImagePath != null)
                      ? widget.secondCameraImagePath
                      : defaultAssetImage,
                  selectedImage:
                      // (widget.secondImagePath != null) ? null : defaultUrlImage,
                      (widget.selectedImageList.length > 1 &&
                              widget.secondImagePath == null &&
                              widget.secondCameraImagePath == null)
                          ? widget.selectedImageList[1]
                          : null,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (provider.psValueHolder.isCustomCamera ?? true) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ChooseCameraTypeDialog(
                              onCameraTap: () async {
                                final dynamic returnData =
                                    await Navigator.pushNamed(
                                        context, RoutePaths.cameraView);
                                if (returnData is String) {
                                  widget.updateImagesFromCustomCamera(
                                      returnData, 1);
                                }
                              },
                              onGalleryTap: () {
                                if (widget.flag == PsConst.ADD_NEW_ITEM) {
                                  loadPickMultiImage();
                                } else {
                                  loadSingleImage(1);
                                }
                              },
                            );
                          });
                    } else {
                      if (widget.flag == PsConst.ADD_NEW_ITEM) {
                        loadPickMultiImage();
                      } else {
                        loadSingleImage(1);
                      }
                    }
                  },
                ),
                ItemEntryImageWidget(
                  index: 2,
                  images: (widget.thirdImagePath != null)
                      ? widget.thirdImagePath
                      : defaultAssetImage,
                  cameraImagePath: (widget.thirdCameraImagePath != null)
                      ? widget.thirdCameraImagePath
                      : defaultAssetImage,
                  selectedImage:
                      // (widget.thirdImagePath != null) ? null : defaultUrlImage,
                      (widget.selectedImageList.length > 2 &&
                              widget.thirdImagePath == null &&
                              widget.thirdCameraImagePath == null)
                          ? widget.selectedImageList[2]
                          : defaultUrlImage,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (provider.psValueHolder.isCustomCamera ?? true) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ChooseCameraTypeDialog(
                              onCameraTap: () async {
                                final dynamic returnData =
                                    await Navigator.pushNamed(
                                        context, RoutePaths.cameraView);
                                if (returnData is String) {
                                  widget.updateImagesFromCustomCamera(
                                      returnData, 2);
                                }
                              },
                              onGalleryTap: () {
                                if (widget.flag == PsConst.ADD_NEW_ITEM) {
                                  loadPickMultiImage();
                                } else {
                                  loadSingleImage(2);
                                }
                              },
                            );
                          });
                    } else {
                      if (widget.flag == PsConst.ADD_NEW_ITEM) {
                        loadPickMultiImage();
                      } else {
                        loadSingleImage(2);
                      }
                    }
                  },
                ),
                ItemEntryImageWidget(
                  index: 3,
                  images: (widget.fouthImagePath != null)
                      ? widget.fouthImagePath
                      : defaultAssetImage,
                  cameraImagePath: (widget.fouthCameraImagePath != null)
                      ? widget.fouthCameraImagePath
                      : defaultAssetImage,
                  selectedImage:
                      // (widget.fouthImagePath != null) ? null : defaultUrlImage,
                      (widget.selectedImageList.length > 3 &&
                              widget.fouthImagePath == null &&
                              widget.fouthCameraImagePath == null)
                          ? widget.selectedImageList[3]
                          : defaultUrlImage,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (provider.psValueHolder.isCustomCamera ?? true) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ChooseCameraTypeDialog(
                              onCameraTap: () async {
                                final dynamic returnData =
                                    await Navigator.pushNamed(
                                        context, RoutePaths.cameraView);
                                if (returnData is String) {
                                  widget.updateImagesFromCustomCamera(
                                      returnData, 3);
                                }
                              },
                              onGalleryTap: () {
                                if (widget.flag == PsConst.ADD_NEW_ITEM) {
                                  loadPickMultiImage();
                                } else {
                                  loadSingleImage(3);
                                }
                              },
                            );
                          });
                    } else {
                      if (widget.flag == PsConst.ADD_NEW_ITEM) {
                        loadPickMultiImage();
                      } else {
                        loadSingleImage(3);
                      }
                    }
                  },
                ),
                ItemEntryImageWidget(
                  index: 4,
                  images: (widget.fifthImagePath != null)
                      ? widget.fifthImagePath
                      : defaultAssetImage,
                  cameraImagePath: (widget.fifthCameraImagePath != null)
                      ? widget.fifthCameraImagePath
                      : defaultAssetImage,
                  selectedImage: //widget.fifthImagePath != null ||
                      //     widget.selectedImageList.length - 1 >= 4)
                      // ? widget.selectedImageList[4]
                      // : defaultUrlImage,
                      (widget.selectedImageList.length > 4 &&
                              widget.fifthImagePath == null &&
                              widget.fifthCameraImagePath == null)
                          ? widget.selectedImageList[4]
                          : null,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (provider.psValueHolder.isCustomCamera ?? true) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ChooseCameraTypeDialog(
                              onCameraTap: () async {
                                final dynamic returnData =
                                    await Navigator.pushNamed(
                                        context, RoutePaths.cameraView);
                                if (returnData is String) {
                                  widget.updateImagesFromCustomCamera(
                                      returnData, 4);
                                }
                              },
                              onGalleryTap: () {
                                if (widget.flag == PsConst.ADD_NEW_ITEM) {
                                  loadPickMultiImage();
                                } else {
                                  loadSingleImage(4);
                                }
                              },
                            );
                          });
                    } else {
                      if (widget.flag == PsConst.ADD_NEW_ITEM) {
                        loadPickMultiImage();
                      } else {
                        loadSingleImage(4);
                      }
                    }
                  },
                ),
              ],
            );
          }),
    );
  }
}

class ItemEntryImageWidget extends StatefulWidget {
  const ItemEntryImageWidget({
    Key key,
    @required this.index,
    @required this.images,
    @required this.cameraImagePath,
    @required this.selectedImage,
    this.onTap,
  }) : super(key: key);

  final Function onTap;
  final int index;
  final Asset images;
  final String cameraImagePath;
  final DefaultPhoto selectedImage;
  @override
  State<StatefulWidget> createState() {
    return ItemEntryImageWidgetState();
  }
}

class ItemEntryImageWidgetState extends State<ItemEntryImageWidget> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.selectedImage != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 4, left: 4),
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            width: 100,
            height: 100,
            child: PsNetworkImageWithUrl(
              photoKey: '',
              // width: 100,
              // height: 100,
              imagePath: widget.selectedImage.imgPath,
            ),
          ),
        ),
      );
    } else {
      if (widget.images != null) {
        final Asset asset = widget.images;
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: InkWell(
            onTap: widget.onTap,
            child: AssetThumb(
              asset: asset,
              width: 100,
              height: 100,
            ),
          ),
        );
      } else if (widget.cameraImagePath != null) {
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: InkWell(
              onTap: widget.onTap,
              child: Image(
                  width: 100,
                  height: 100,
                  image: FileImage(File(widget.cameraImagePath)))),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: InkWell(
            onTap: widget.onTap,
            child: Image.asset(
              'assets/images/default_image.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    }
  }
}

class PriceDropDownControllerWidget extends StatelessWidget {
  const PriceDropDownControllerWidget(
      {Key key,
      // @required this.onTap,
      this.currencySymbolController,
      this.userInputPriceController})
      : super(key: key);

  final TextEditingController currencySymbolController;
  final TextEditingController userInputPriceController;
  // final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              top: PsDimens.space4,
              right: PsDimens.space8,
              left: PsDimens.space8),
          child: Row(
            children: <Widget>[
              Text(
                Utils.getString(context, 'item_entry__price'),
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(' *',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: PsColors.mainColor))
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
/*            InkWell(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final ItemEntryProvider provider =
                    Provider.of<ItemEntryProvider>(context, listen: false);

                final dynamic itemCurrencySymbolResult =
                    await Navigator.pushNamed(
                        context, RoutePaths.itemCurrencySymbol,
                        arguments: currencySymbolController.text);

                if (itemCurrencySymbolResult != null &&
                    itemCurrencySymbolResult is ItemCurrency) {
                  provider.itemCurrencyId = itemCurrencySymbolResult.id;

                  currencySymbolController.text =
                      itemCurrencySymbolResult.currencySymbol;
                } else if (itemCurrencySymbolResult) {
                  currencySymbolController.text = '';
                }
              },
              child: Container(
               // width: PsDimens.space140,
                height: PsDimens.space44,
                margin: const EdgeInsets.all(PsDimens.space8),
                decoration: BoxDecoration(
                  color: Utils.isLightMode(context)
                      ? Colors.white60
                      : Colors.black54,
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  border: Border.all(
                      color: Utils.isLightMode(context)
                          ? Colors.grey[200]
                          : Colors.black87),
                ),
                child: Container(
                  margin: const EdgeInsets.all(PsDimens.space8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Ink(
                          color: PsColors.backgroundColor,
                          child: Text(
                            currencySymbolController.text == ''
                                ? Utils.getString(
                                    context, 'home_search__not_set')
                                : currencySymbolController.text,
                            style: currencySymbolController.text == ''
                                ? Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.grey[600])
                                : Theme.of(context).textTheme.bodyText1,
                      
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                      ),
                    ],
                  ),
                ),
              ),
            ),*/
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: PsDimens.space44,
                // margin: const EdgeInsets.only(
                //     top: 24),
                decoration: BoxDecoration(
                  color: Utils.isLightMode(context)
                      ? Colors.white60
                      : Colors.black54,
                  borderRadius: BorderRadius.circular(PsDimens.space4),
                  border: Border.all(
                      color: Utils.isLightMode(context)
                          ? Colors.grey[200]
                          : Colors.black87),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLines: null,
                  controller: userInputPriceController,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: PsDimens.space8, bottom: PsDimens.space4),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: PsDimens.space8),
          ],
        ),
      ],
    );
  }
}




