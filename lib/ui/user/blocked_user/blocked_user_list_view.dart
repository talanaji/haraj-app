import 'package:haraj/api/common/ps_resource.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/provider/user/blocked_user_provider.dart';
import 'package:haraj/provider/user/user_provider.dart';
import 'package:haraj/repository/blocked_user_repository.dart';
import 'package:haraj/repository/user_repository.dart';
import 'package:haraj/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:haraj/utils/ps_progress_dialog.dart';
import 'package:haraj/viewobject/api_status.dart';
import 'package:haraj/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:haraj/viewobject/holder/intent_holder/user_intent_holder.dart';
import 'package:haraj/viewobject/holder/unblock_user_holder.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:haraj/constant/route_paths.dart';
import 'package:haraj/ui/common/ps_ui_widget.dart';
import 'package:provider/single_child_widget.dart';

import 'blocked_user_vertical_list_item.dart';

class BlockedUserListView extends StatefulWidget {
  const BlockedUserListView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _BlockedUserListViewState createState() {
    return _BlockedUserListViewState();
  }
}

class _BlockedUserListViewState extends State<BlockedUserListView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  BlockedUserProvider _userListProvider;


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _userListProvider
            .nextBlockedUserList(_userListProvider.valueHolder.loginUserId);
      }
    });
  }

  BlockedUserRepository repo1;
  PsValueHolder psValueHolder;
  UserProvider userProvider;
  UserRepository userRepo;
  @override
  Widget build(BuildContext context) {
    
    timeDilation = 1.0;
    repo1 = Provider.of<BlockedUserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    userRepo = Provider.of<UserRepository>(context);

    return PsWidgetWithMultiProvider(
      child: MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<UserProvider>(
            lazy: false,
            create: (BuildContext context) {
              userProvider =
                  UserProvider(repo: userRepo, psValueHolder: psValueHolder);
              return userProvider;
            },
          ),
          ChangeNotifierProvider<BlockedUserProvider>(
            lazy: false,
            create: (BuildContext context) {
              final BlockedUserProvider provider =
                  BlockedUserProvider(repo: repo1, valueHolder: psValueHolder);
              provider.loadBlockedUserList(provider.valueHolder.loginUserId);
              return provider;
          })],
      child: Consumer<BlockedUserProvider>(
          builder:
              (BuildContext context, BlockedUserProvider provider, Widget child) {
            return Stack(children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(
                      top: PsDimens.space8, bottom: PsDimens.space8),
                  child: RefreshIndicator(
                    child: CustomScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                if (provider.blockedUserList.data != null ||
                                    provider.blockedUserList.data.isNotEmpty) {
                                  final int count =
                                      provider.blockedUserList.data.length;
                                  return BlockedUserVerticalListItem(
                                    animationController: widget.animationController,
                                    animation:
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(
                                      CurvedAnimation(
                                        parent: widget.animationController,
                                        curve: Interval(
                                            (1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn),
                                      ),
                                    ),
                                    blockedUser: provider.blockedUserList.data[index],
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, RoutePaths.userDetail,
                                          arguments: UserIntentHolder(
                                              userId: provider
                                                  .blockedUserList.data[index].userId,
                                              userName: provider.blockedUserList
                                                  .data[index].userName));
                                    },
                                    onUnblockTap :() async{
                                      await PsProgressDialog.showDialog(context);

                                      final UnblockUserHolder userBlockItemParameterHolder =
                                      UnblockUserHolder(
                                      fromBlockUserId: userProvider.psValueHolder.loginUserId,
                                       toBlockUserId: provider.blockedUserList.data[index].userId);

                                      final PsResource<ApiStatus> _apiStatus = await userProvider
                                      .postUnBlockUser(userBlockItemParameterHolder.toMap());   

                                       if(_apiStatus != null &&_apiStatus.status != null){
                                         PsProgressDialog.dismissDialog();
                                         provider.deleteUserFromDB(provider.blockedUserList.data[index].userId);
                                       }
                                    }
                                  );
                                } else {
                                  return null;
                                }
                              },
                              childCount: provider.blockedUserList.data.length,
                            ),
                          ),
                        ]),
                    onRefresh: () async {
                      return _userListProvider
                          .resetBlockedUserList(provider.valueHolder.loginUserId);
                    },
                  )),
              PSProgressIndicator(provider.blockedUserList.status)
            ]);
          }),
    ));
  }
}
