import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haraj/api/common/ps_resource.dart';
import 'package:haraj/api/common/ps_status.dart';
import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/constant/ps_constants.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/provider/entry/comment_entry_provider.dart';
import 'package:haraj/repository/blog_repository.dart';
import 'package:haraj/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:haraj/ui/common/dialog/error_dialog.dart';
import 'package:haraj/ui/common/dialog/success_dialog.dart';
import 'package:haraj/ui/common/dialog/warning_dialog_view.dart';
import 'package:haraj/ui/common/ps_button_widget.dart';
import 'package:haraj/ui/common/ps_textfield_widget.dart';
import 'package:haraj/utils/ps_progress_dialog.dart';
import 'package:haraj/utils/utils.dart';
import 'package:haraj/viewobject/blog.dart';
import 'package:haraj/viewobject/common/ps_value_holder.dart';
import 'package:haraj/viewobject/holder/comment_entry_parameter_holder.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class CommentEntryView extends StatefulWidget {
  const CommentEntryView(
      {Key key, this.flag, this.blog,
      @required this.itemId })
      : super(key: key);
  final String flag;
  final Blog blog;
  final String itemId;

  @override
  State<StatefulWidget> createState() => _CommentEntryViewState();
}

class _CommentEntryViewState extends State<CommentEntryView> {
  BlogRepository repo1;
  CommentEntryProvider _CommentEntryProvider;
   PsValueHolder valueHolder;
   final TextEditingController userInputDescription = TextEditingController();
  final double zoom = 16;
  bool bindDataFirstTime = true;

  String isShopCheckbox = '1';

  // ProgressDialog progressDialog;

  // File file;

  @override
  Widget build(BuildContext context) {
    print(
        '............................Build UI Again ............................');
    valueHolder = Provider.of<PsValueHolder>(context);


    repo1 = Provider.of<BlogRepository>(context);

    final Widget _uploadItemWidget = Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space16,
            right: PsDimens.space16,
            top: PsDimens.space16,
            bottom: PsDimens.space48),
        width: double.infinity,
        height: PsDimens.space44,
        child: PSButtonWidget(
          hasShadow: true,
          width: double.infinity,
          titleText: Utils.getString(context, 'login__submit'),
          onPressed: () async {
            if (userInputDescription.text == null ||
                userInputDescription.text == '') {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return WarningDialog(
                        message: Utils.getString(
                            context, 'item_entry_need_description'),
                        onPressed: () {});
                  });
            }   else {
              if (!PsProgressDialog.isShowing()) {
                await PsProgressDialog.showDialog(context,
                    message: Utils.getString(
                        context, 'progressloading_item_uploading'));

              }
              if (widget.flag == PsConst.ADD_NEW_ITEM) {
                //add new
                final CommentEntryParameterHolder commentEntryParameterHolder =
                CommentEntryParameterHolder(
                  status:"1",
                  itemId: widget.itemId,
                  description: userInputDescription.text,
                  id: _CommentEntryProvider.itemId,
                  addedUserId: _CommentEntryProvider.psValueHolder.loginUserId,
                );

                final PsResource<Blog> commentData = await _CommentEntryProvider
                    .postCommentEntry(commentEntryParameterHolder.toMap());
                PsProgressDialog.dismissDialog();

                if (commentData.status == PsStatus.SUCCESS) {
                  _CommentEntryProvider.itemId = commentData.data.id;
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return SuccessDialog(
                          message: "تم اضافة تعليق جديد ",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        );
                      });
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: commentData.message,
                        );
                      });
                }
              }
              else {
                // edit item

                final CommentEntryParameterHolder commentEntryParameterHolder =
                CommentEntryParameterHolder(
                  itemId: widget.itemId,
                  description: userInputDescription.text,
                  id: _CommentEntryProvider.itemId,
                  addedUserId: _CommentEntryProvider.psValueHolder.loginUserId,
                );

                final PsResource<Blog> commentData = await _CommentEntryProvider
                    .postCommentEntry(commentEntryParameterHolder.toMap());
                PsProgressDialog.dismissDialog();
                if (commentData.status == PsStatus.SUCCESS) {
                  if (commentData.data != null) {
                    Fluttertoast.showToast(
                        msg: 'Item Uploaded',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white);


                  }
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: commentData.message,
                        );
                      });
                }
              }
            }
          },
        ));
    return PsWidgetWithMultiProvider(
      child: MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<CommentEntryProvider>(
                lazy: false,
                create: (BuildContext context) {
                  _CommentEntryProvider = CommentEntryProvider(
                      repo: repo1, psValueHolder: valueHolder);

                  _CommentEntryProvider.blog = widget.blog;

                  return _CommentEntryProvider;
                }),

          ],
          child: SingleChildScrollView(
          child:  Container(
                  color: PsColors.backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Consumer<CommentEntryProvider>(builder:
                          (BuildContext context, CommentEntryProvider provider,
                          Widget child) {
                        if (provider != null &&
                            provider.blog != null &&
                            provider.blog.id != null) {
                          if (bindDataFirstTime) {
                            userInputDescription.text =
                                provider.blog.description; 
                            bindDataFirstTime = false;

                          }
                        }
                        return AllControllerTextWidget(
                          userInputDescription: userInputDescription,
                          zoom: zoom,
                          flag: widget.flag,
                          blog: widget.blog,
                          provider: provider,
                        );
                      }),

                      //  _largeSpacingWidget,
                      _uploadItemWidget
                    ],
                  ),
                ))

          ),
    );

  }

}

class AllControllerTextWidget extends StatefulWidget {
  const AllControllerTextWidget({
    Key key,
    this.userInputDescription,
    this.provider,
    this.zoom,
    this.flag,
    this.blog,
  }) : super(key: key);

  final TextEditingController userInputDescription;
  final CommentEntryProvider provider;
  final double zoom;
  final String flag;
  final Blog blog;

  @override
  _AllControllerTextWidgetState createState() =>
      _AllControllerTextWidgetState();
}

class _AllControllerTextWidgetState extends State<AllControllerTextWidget> {
  PsValueHolder valueHolder;
  CommentEntryProvider commentEntryProvider;

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    commentEntryProvider = Provider.of<CommentEntryProvider>(context, listen: false);



    return Column(children: <Widget>[

      PsTextFieldWidget(
        titleText: Utils.getString(context, 'item_entry__description'),
        height: PsDimens.space80,
        hintText: Utils.getString(context, 'item_entry__description'),
        textAboutMe: true,
        textEditingController: widget.userInputDescription,
        isStar: true,
      ),
    ]);
  }


}

 



