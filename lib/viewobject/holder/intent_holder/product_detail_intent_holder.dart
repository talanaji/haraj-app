import 'package:flutter/material.dart';

class ProductDetailIntentHolder {
  const ProductDetailIntentHolder({
    this.id,
    @required this.productId,
    this.heroTagImage,
    this.heroTagTitle,
  @required this.productTitle
  });

  final String id;
  final String productId;
  final String heroTagImage;
  final String productTitle;
  final String heroTagTitle;
}
