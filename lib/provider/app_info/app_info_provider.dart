import 'package:haraj/utils/utils.dart';
import 'package:haraj/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:haraj/api/common/ps_resource.dart';
import 'package:haraj/api/common/ps_status.dart';
import 'package:haraj/provider/common/ps_provider.dart';
import 'package:haraj/repository/app_info_repository.dart';
import 'package:haraj/viewobject/holder/app_info_parameter_holder.dart';
import 'package:haraj/viewobject/ps_app_info.dart';
import 'package:intl/intl.dart';

class AppInfoProvider extends PsProvider {
  AppInfoProvider({@required AppInfoRepository repo, this.psValueHolder,int limit = 0 })
      : super(repo,limit) {
    _repo = repo;
    print('App Info Provider: $hashCode');
    isDispose = false;
  }

  AppInfoRepository _repo;
  PsValueHolder psValueHolder;

  PsResource<PSAppInfo> _psAppInfo =
      PsResource<PSAppInfo>(PsStatus.NOACTION, '', null);

  PsResource<PSAppInfo> get appInfo => _psAppInfo;
  String realStartDate = '0';
  String realEndDate = '0';

  @override
  void dispose() {
    isDispose = true;
    print('App Info Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadDeleteHistory(Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;

    final PsResource<PSAppInfo> psAppInfo =
        await _repo.postDeleteHistory(jsonMap);

    return psAppInfo;
  }

  Future<void> loadDeleteHistorywithNotifier() async {
    isLoading = true;

    if (psValueHolder == null || psValueHolder.startDate == null) {
      realStartDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
    } else {
      realStartDate = psValueHolder.endDate;
    
    realEndDate =
        DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
    final AppInfoParameterHolder appInfoParameterHolder =
        AppInfoParameterHolder(
          startDate: realStartDate,
          endDate: realEndDate,
          userId: Utils.checkUserLoginId(
                psValueHolder));

    final PsResource<PSAppInfo> psAppInfo =
        await _repo.postDeleteHistory(appInfoParameterHolder.toMap());
    _psAppInfo = psAppInfo;

    if (!isDispose) {
        notifyListeners();
      }  
    }
  }
}
