import 'package:haraj/constant/ps_constants.dart';
import 'package:haraj/viewobject/common/ps_holder.dart';

class ProductParameterHolder extends PsHolder<dynamic> {
  ProductParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    itemPriceTypeId = '';
    itemPriceTypeName = '';
    itemCurrencyId = '';
    itemLocationId = '';
    maxPrice = '';
    minPrice = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    status = '1';
  }

  String searchTerm;
  String manufacturerId;

  String itemPriceTypeId;
  String itemPriceTypeName;
  String itemCurrencyId;
  String itemLocationId;
  String maxPrice;
  String minPrice;
  String orderBy;
  String orderType;
  String addedUserId;
  String isPaid;
  String status;

  bool isFiltered() {
    return !(
        // isAvailable == '' &&
        //   (isDiscount == '0' || isDiscount == '') &&
        //   (isFeatured == '0' || isFeatured == '') &&
        orderBy == '' &&
            orderType == '' &&
            minPrice == '' &&
            maxPrice == '' &&
            itemPriceTypeId == '' &&
            searchTerm == '');
  }

  bool isCatAndSubCatFiltered() {
    return !(manufacturerId == ''  );
  }

  ProductParameterHolder getRecentParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    maxPrice = '';
    minPrice = '';
    addedUserId = '';
    isPaid = PsConst.PAID_ITEM_FIRST;
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';

    return this;
  }

  ProductParameterHolder getPaidItemParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    maxPrice = '';
    minPrice = '';
    addedUserId = '';
    isPaid = PsConst.ONLY_PAID_ITEM;
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';

    return this;
  }

  ProductParameterHolder getPendingItemParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    maxPrice = '';
    minPrice = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '0';

    return this;
  }

  ProductParameterHolder getRejectedItemParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    maxPrice = '';
    minPrice = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '3';

    return this;
  }

  ProductParameterHolder getDisabledProductParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    maxPrice = '';
    minPrice = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '2';

    return this;
  }

  ProductParameterHolder getItemByManufacturerIdParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    maxPrice = '';
    minPrice = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';

    return this;
  }

  ProductParameterHolder getPopularParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    maxPrice = '';
    minPrice = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING_TRENDING;
    orderType = PsConst.FILTERING__DESC;
    status = '1';

    return this;
  }

  ProductParameterHolder getLatestParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    maxPrice = '';
    minPrice = '';
    addedUserId = '';
    isPaid = PsConst.PAID_ITEM_FIRST;
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';

    return this;
  }

  ProductParameterHolder resetParameterHolder() {
    searchTerm = '';
    manufacturerId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    maxPrice = '';
    minPrice = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['searchterm'] = searchTerm;
    map['manufacturer_id'] = manufacturerId;
    map['item_price_type_id'] = itemPriceTypeId;
    map['item_currency_id'] = itemCurrencyId;
    map['item_location_id'] = itemLocationId;
    map['max_price'] = maxPrice;
    map['min_price'] = minPrice;
    map['added_user_id'] = addedUserId;
    map['is_paid'] = isPaid;
    map['order_by'] = orderBy;
    map['order_type'] = orderType;
    map['status'] = status;
    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    searchTerm = '';
    manufacturerId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    maxPrice = '';
    minPrice = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '';

    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (searchTerm != '') {
      result += searchTerm + ':';
    }
    if (manufacturerId != '') {
      result += manufacturerId + ':';
    }
    if (itemPriceTypeId != '') {
      result += itemPriceTypeId + ':';
    }
    if (itemCurrencyId != '') {
      result += itemCurrencyId + ':';
    }
    if (itemLocationId != '') {
      result += itemLocationId + ':';
    }
    if (maxPrice != '') {
      result += maxPrice + ':';
    }
    if (minPrice != '') {
      result += minPrice + ':';
    }
    if (addedUserId != '') {
      result += addedUserId + ':';
    }
    if (isPaid != '') {
      result += isPaid + ':';
    }
    if (status != '') {
      result += status + ':';
    }
    if (orderBy != '') {
      result += orderBy + ':';
    }
    if (orderType != '') {
      result += orderType;
    }

    return result;
  }
}
