import 'dart:async';

import 'package:haraj/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:haraj/api/common/ps_resource.dart';
import 'package:haraj/api/common/ps_status.dart';
import 'package:haraj/provider/common/ps_provider.dart';
import 'package:haraj/repository/product_repository.dart';
import 'package:haraj/viewobject/api_status.dart';
import 'package:haraj/viewobject/common/ps_value_holder.dart';
import 'package:haraj/viewobject/holder/product_parameter_holder.dart';
import 'package:haraj/viewobject/product.dart';

class AddedItemProvider extends PsProvider {
  AddedItemProvider({@required ProductRepository repo, this.psValueHolder, int limit = 0})
      : super(repo,limit) {
    _repo = repo;
    print('AddedItemProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    itemListStream = StreamController<PsResource<List<Product>>>.broadcast();
    subscription =
        itemListStream.stream.listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data.length);

      _itemList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  ProductRepository _repo;
  PsValueHolder psValueHolder;
  ProductParameterHolder addedUserParameterHolder =
      ProductParameterHolder().getLatestParameterHolder();
  PsResource<List<Product>> _itemList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get itemList => _itemList;
  StreamSubscription<PsResource<List<Product>>> subscription;
  StreamController<PsResource<List<Product>>> itemListStream;
  dynamic daoSubscription;

  @override
  void dispose() {
    subscription.cancel();
    if (daoSubscription != null) {
      daoSubscription.cancel();
    }
    isDispose = true;
    print('Added Item Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadItemList(
      String loginUserId, ProductParameterHolder holder) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    daoSubscription = await _repo.getItemListByUserId(
        itemListStream,
        loginUserId,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        holder);
  }

  Future<dynamic> nextItemList(
      String loginUserId, ProductParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo.getNextPageItemListByUserId(
          itemListStream,
          loginUserId,
          isConnectedToInternet,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING,
          holder);
    }
  }

  Future<void> resetItemList(
      String loginUserId, ProductParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    daoSubscription = await _repo.getItemListByUserId(
        itemListStream,
        loginUserId,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        holder);

    isLoading = false;
  }

  PsResource<ApiStatus> _apiStatus =
  PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get apiStatus => _apiStatus;
  Future<dynamic> userDeleteItem(
      Map<dynamic, dynamic> jsonMap,
      ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.userDeleteItem(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }
}
