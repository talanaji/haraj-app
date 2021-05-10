import 'dart:async';
import 'package:haraj/api/ps_url.dart';
import 'package:haraj/constant/ps_constants.dart';
import 'package:haraj/db/blog_dao.dart';
import 'package:haraj/viewobject/blog.dart';
import 'package:flutter/material.dart';
import 'package:haraj/api/common/ps_resource.dart';
import 'package:haraj/api/common/ps_status.dart';
import 'package:haraj/api/ps_api_service.dart';

import 'Common/ps_repository.dart';

class BlogRepository extends PsRepository {
  BlogRepository(
      {@required PsApiService psApiService, @required BlogDao blogDao}) {
    _psApiService = psApiService;
    _blogDao = blogDao;
  }

  String primaryKey = 'id';
  PsApiService _psApiService;
  BlogDao _blogDao;

  Future<dynamic> insert(Blog blog) async {
    return _blogDao.insert(primaryKey, blog);
  }

  Future<dynamic> update(Blog blog) async {
    return _blogDao.update(blog);
  }

  Future<dynamic> delete(Blog blog) async {
    return _blogDao.delete(blog);
  }

  Future<dynamic> getAllBlogList(
      StreamController<PsResource<List<Blog>>> blogListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,String itemId,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    blogListStream.sink.add(await _blogDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Blog>> _resource =
      await _psApiService.getBlogList(limit, offset,itemId);

      if (_resource.status == PsStatus.SUCCESS) {
        await _blogDao.deleteAll();
        await _blogDao.insertAll(primaryKey, _resource.data);
      }else{
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _blogDao.deleteAll();
        }
      }
      blogListStream.sink.add(await _blogDao.getAll());
    }
  }

  Future<dynamic> getNextPageBlogList(
      StreamController<PsResource<List<Blog>>> blogListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      String itemId,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    blogListStream.sink.add(await _blogDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Blog>> _resource =
          await _psApiService.getBlogList(limit, offset,itemId);

      if (_resource.status == PsStatus.SUCCESS) {
        await _blogDao.insertAll(primaryKey, _resource.data);
      }
      blogListStream.sink.add(await _blogDao.getAll());
    }
  }
  Future<PsResource<Blog>> postCommentEntry(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<Blog> _resource =
    await _psApiService.postCommentEntry(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      await insert(_resource.data);
      return _resource;
    } else {
      final Completer<PsResource<Blog>> completer =
      Completer<PsResource<Blog>>();
      completer.complete(_resource);
      return completer.future;
    }
  }


}
