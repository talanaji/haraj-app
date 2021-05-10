import 'dart:async';
import 'package:haraj/repository/blog_repository.dart';
 import 'package:haraj/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:haraj/api/common/ps_resource.dart';
import 'package:haraj/api/common/ps_status.dart';
import 'package:haraj/provider/common/ps_provider.dart';
import 'package:haraj/viewobject/blog.dart';
import 'package:haraj/viewobject/common/ps_value_holder.dart';

class CommentEntryProvider extends PsProvider {
  CommentEntryProvider(
      {@required BlogRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    isDispose = false;
    print('Item Entry Provider: $hashCode');

    commentListStream = StreamController<PsResource<Blog>>.broadcast();
    subscription = commentListStream.stream.listen((PsResource<Blog> resource) {
      if (resource != null && resource.data != null) {
        _commentResource = resource;
        blog = resource.data;
      }

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  BlogRepository _repo;
  PsValueHolder psValueHolder;
  PsResource<Blog> _commentResource =
      PsResource<Blog>(PsStatus.NOACTION, '', null);
  PsResource<Blog> get commentResource => _commentResource;

  StreamSubscription<PsResource<Blog>> subscription;
  StreamController<PsResource<Blog>> commentListStream;

  Blog blog;

  String itemId = '';

  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('Item Entry Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postCommentEntry(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _commentResource = await _repo.postCommentEntry(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _commentResource;
    // return null;
  }
/*
  Future<dynamic> getItemFromDB(String itemId) async {
    isLoading = true;

    await _repo.getItemFromDB(
        itemId, itemListStream, PsStatus.PROGRESS_LOADING);
  }*/
}
