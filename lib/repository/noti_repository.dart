import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haraj/api/common/ps_resource.dart';
import 'package:haraj/api/common/ps_status.dart';
import 'package:haraj/api/ps_api_service.dart';
import 'package:haraj/db/noti_dao.dart';
import 'package:haraj/repository/Common/ps_repository.dart';
import 'package:haraj/viewobject/noti.dart';

class NotiRepository extends PsRepository {
  NotiRepository(
      {@required PsApiService psApiService, @required NotiDao notiDao}) {
    _psApiService = psApiService;
    _notiDao = notiDao;
  }

  PsApiService _psApiService;
  NotiDao _notiDao;
  final String _primaryKey = 'id';

  Future<dynamic> insert(Noti noti) async {
    return _notiDao.insert(_primaryKey, noti);
  }

  Future<dynamic> update(Noti noti) async {
    return _notiDao.update(noti);
  }

  Future<dynamic> delete(Noti noti) async {
    return _notiDao.delete(noti);
  }

  Future<dynamic> getNotiList(
      StreamController<PsResource<List<Noti>>> notiListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      Map<dynamic, dynamic> paramMap,
      {bool isLoadFromServer = true}) async {
    notiListStream.sink
        .add(await _notiDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Noti>> _resource =
          await _psApiService.getNotificationList(paramMap, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _notiDao.deleteAll();
        await _notiDao.insertAll(_primaryKey, _resource.data);
      }else{
        await _notiDao.deleteAll();
      }
      notiListStream.sink.add(await _notiDao.getAll());
    }
  }

  Future<dynamic> getNextPageNotiList(
      StreamController<PsResource<List<Noti>>> notiListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      Map<dynamic, dynamic> paramMap,
      {bool isLoadFromServer = true}) async {
    notiListStream.sink
        .add(await _notiDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Noti>> _resource =
          await _psApiService.getNotificationList(paramMap, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        _notiDao
            .insertAll(_primaryKey, _resource.data)
            .then((dynamic data) async {
          notiListStream.sink.add(await _notiDao.getAll());
        });
      } else {
        notiListStream.sink.add(await _notiDao.getAll());
      }
    }
  }

  Future<PsResource<Noti>> postNoti(
      StreamController<PsResource<List<Noti>>> ratingListStream,
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      {bool isLoadFromServer = true}) async {
    final PsResource<Noti> _resource = await _psApiService.postNoti(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      ratingListStream.sink
          .add(await _notiDao.getAll(status: PsStatus.SUCCESS));
      return _resource;
    } else {
      final Completer<PsResource<Noti>> completer =
          Completer<PsResource<Noti>>();
      completer.complete(_resource);
      ratingListStream.sink
          .add(await _notiDao.getAll(status: PsStatus.SUCCESS));
      return completer.future;
    }
  }
}
