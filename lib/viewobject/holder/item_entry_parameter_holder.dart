import 'package:haraj/viewobject/common/ps_holder.dart'
    show PsHolder;

class ItemEntryParameterHolder extends PsHolder<ItemEntryParameterHolder> {
  ItemEntryParameterHolder({
    this.manufacturerId,
    this.itemPriceTypeId,
    this.itemCurrencyId,
    this.itemLocationId,
    // this.dealOptionRemark,
     this.description,
     this.price,
    // this.dealOptionId,
    // this.brand,
     this.title,
      this.id,
    this.addedUserId,
  });

  final String manufacturerId;
  final String itemPriceTypeId;
  final String itemCurrencyId;
  final String itemLocationId;
  final String description;
  final String price;
  // final String dealOptionId;
  // final String brand;
  final String title;
   final String id;
  final String addedUserId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['manufacturer_id'] = manufacturerId;
    map['item_price_type_id'] = itemPriceTypeId;
    map['item_currency_id'] = itemCurrencyId;
    map['item_location_id'] = itemLocationId;
    // map['deal_option_remark'] = dealOptionRemark;
    map['description'] = description;
    map['price'] = price;
    // map['deal_option_id'] = dealOptionId;
    // map['brand'] = brand;
    map['title'] = title;
    map['id'] = id;
    map['added_user_id'] = addedUserId;

    return map;
  }

  @override
  ItemEntryParameterHolder fromMap(dynamic dynamicData) {
    return ItemEntryParameterHolder(
      manufacturerId: dynamicData['manufacturer_id'],
      itemPriceTypeId: dynamicData['item_price_type_id'],
      itemCurrencyId: dynamicData['item_currency_id'],
      itemLocationId: dynamicData['item_location_id'],
       description: dynamicData['description'],
       price: dynamicData['price'],
       title: dynamicData['title'],
       id: dynamicData['id'],
      addedUserId: dynamicData['added_user_id'],
    );
  }

  @override
  String getParamKey() {
    String key = '';
    if (manufacturerId != '') {
      key += manufacturerId;
    }
    if (itemPriceTypeId != '') {
      key += itemPriceTypeId;
    }
    if (itemCurrencyId != '') {
      key += itemCurrencyId;
    }
    if (itemLocationId != '') {
      key += itemLocationId;
    }
    if (description != '') {
      key += description;
    }

    if (price != '') {
      key += price;
    }
    // if (dealOptionId != '') {
    //   key += dealOptionId;
    // }
    // if (brand != '') {
    //   key += brand;
    // }
    if (title != '') {
      key += title;
    }
    if (id != '') {
      key += id;
    }
    if (addedUserId != '') {
      key += addedUserId;
    }
    return key;
  }
}
