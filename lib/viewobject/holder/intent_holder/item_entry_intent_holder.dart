import 'package:flutter/cupertino.dart';
import 'package:haraj/viewobject/product.dart';

class ItemEntryIntentHolder {
  const ItemEntryIntentHolder({
    @required this.flag,
    @required this.item,
  });
  final String flag;
  final Product item;
}
