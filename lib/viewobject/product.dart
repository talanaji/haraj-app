import 'package:haraj/utils/utils.dart';
import 'package:haraj/viewobject/Item_color.dart';
import 'package:haraj/viewobject/build_type.dart';
import 'package:haraj/viewobject/condition_of_item.dart';
import 'package:haraj/viewobject/fuel_type.dart';
import 'package:haraj/viewobject/item_currency.dart';
import 'package:haraj/viewobject/item_location.dart';
import 'package:haraj/viewobject/item_price_type.dart';
import 'package:haraj/viewobject/item_type.dart';
import 'package:haraj/viewobject/manufacturer.dart';
import 'package:haraj/viewobject/model.dart';
import 'package:haraj/viewobject/seller_type.dart';
import 'package:haraj/viewobject/transmission.dart';
import 'package:haraj/viewobject/user.dart';
import 'package:quiver/core.dart';
import 'package:haraj/viewobject/common/ps_object.dart';
import 'default_photo.dart';

class Product extends PsObject<Product> {
  Product(
      {this.id,
      this.itemPriceTypeId,
      this.itemLocationId,
      this.manufacturerId,
      this.description,
      this.price,
      this.title,
      this.status,
      this.addedDate,
      this.addedUserId,
      this.updatedDate,
      this.updatedUserId,
      this.updatedFlag,
      this.touchCount,
      this.favouriteCount,
      this.dynamicLink,
      this.addedDateStr,
      this.paidStatus,
      this.photoCount,
      this.defaultPhoto,
      this.manufacturer,
      this.model,
      this.itemType,
      this.itemPriceType,
      this.itemLocation,
      this.user,
      this.isFavourited,
      this.isOwner,
      this.isSoldOut});

  String id;
  String itemPriceTypeId;
  String itemLocationId;
  String manufacturerId;
  String description;
  String price;
  String title;
  String status;
  String addedDate;
  String addedUserId;
  String updatedDate;
  String updatedUserId;
  String updatedFlag;
  String touchCount;
  String favouriteCount;
  String isSoldOut;

  String dynamicLink;
  String addedDateStr;
  String paidStatus;
  String photoCount;
  String isFavourited;
  String isOwner;
  DefaultPhoto defaultPhoto;
  Manufacturer manufacturer;
  Model model;
  ItemType itemType;
  ItemPriceType itemPriceType;
/*  ItemCurrency itemCurrency;*/
  ItemLocation itemLocation;
  User user;
  @override
  bool operator ==(dynamic other) => other is Product && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  Product fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Product(
        id: dynamicData['id'],
        itemPriceTypeId: dynamicData['item_price_type_id'],
/*        itemCurrencyId: dynamicData['item_currency_id'],*/
        itemLocationId: dynamicData['item_location_id'],
        manufacturerId: dynamicData['manufacturer_id'],
        description: dynamicData['description'],
        price: dynamicData['price'],
        title: dynamicData['title'],
        status: dynamicData['status'],
        addedDate: dynamicData['added_date'],
        addedUserId: dynamicData['added_user_id'],
        updatedDate: dynamicData['updated_date'],
        updatedUserId: dynamicData['updated_user_id'],
        updatedFlag: dynamicData['updated_flag'],
        touchCount: dynamicData['touch_count'],
        isSoldOut: dynamicData['is_sold_out'],

        favouriteCount: dynamicData['favourite_count'],
        dynamicLink : dynamicData['dynamic_link'],
        addedDateStr: dynamicData['added_date_str'],
        paidStatus: dynamicData['paid_status'],
        photoCount: dynamicData['photo_count'],
        isFavourited: dynamicData['is_favourited'],
        isOwner: dynamicData['is_owner'],
        defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']),
        manufacturer: Manufacturer().fromMap(dynamicData['manufacturer']),
        itemPriceType: ItemPriceType().fromMap(dynamicData['item_price_type']),
        itemLocation: ItemLocation().fromMap(dynamicData['item_location']),
        user: User().fromMap(dynamicData['user']),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['item_price_type_id'] = object.itemPriceTypeId;/*
      data['item_currency_id'] = object.itemCurrencyId;*/
      data['item_location_id'] = object.itemLocationId;
      data['description'] = object.description;
      data['manufacturer_id'] = object.manufacturerId;
      data['price'] = object.price;
      data['title'] = object.title;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['touch_count'] = object.touchCount;
      data['favourite_count'] = object.favouriteCount;
       data['dynamic_link'] = object.dynamicLink;
      data['added_date_str'] = object.addedDateStr;
      data['paid_status'] = object.paidStatus;
      data['photo_count'] = object.photoCount;
      data['is_favourited'] = object.isFavourited;
      data['is_sold_out'] = object.isSoldOut;

      data['is_owner'] = object.isOwner;
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);
      data['manufacturer'] = Manufacturer().toMap(object.manufacturer);
      data['item_type'] = ItemType().toMap(object.itemType);
      data['item_price_type'] = ItemPriceType().toMap(object.itemPriceType);
      data['item_location'] = ItemLocation().toMap(object.itemLocation);
      data['user'] = User().toMap(object.user);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Product> fromMapList(List<dynamic> dynamicDataList) {
    final List<Product> newFeedList = <Product>[];
    if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          newFeedList.add(fromMap(json));
        }
      }
    }
    return newFeedList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];

    if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
    }
    return dynamicList;
  }

  List<Product> checkDuplicate(List<Product> dataList) {
    final Map<String, String> idCache = <String, String>{};
    final List<Product> _tmpList = <Product>[];
    for (int i = 0; i < dataList.length; i++) {
      if (idCache[dataList[i].id] == null) {
        _tmpList.add(dataList[i]);
        idCache[dataList[i].id] = dataList[i].id;
      } else {
        Utils.psPrint('Duplicate');
      }
    }

    return _tmpList;
  }

  bool isSame(List<Product> cache, List<Product> newList) {
    if (cache.length == newList.length) {
      bool status = true;
      for (int i = 0; i < cache.length; i++) {
        if (cache[i].id != newList[i].id) {
          status = false;
          break;
        }
      }

      return status;
    } else {
      return false;
    }
  }
}
