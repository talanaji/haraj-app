import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/config/ps_config.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/ui/app_info/app_info_view.dart';
import 'package:haraj/ui/common/ps_ui_widget.dart';
import 'package:haraj/viewobject/blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haraj/constant/route_paths.dart';
import 'package:haraj/viewobject/holder/intent_holder/user_intent_holder.dart';

class BlogListItem extends StatelessWidget {
  const BlogListItem(
      {Key key,
      @required this.blog,
      this.onTap,
      this.animationController,
      this.itemId,
      this.animation})
      : super(key: key);

  final Blog blog;
  final Function onTap;
  final String itemId;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        child: GestureDetector(
            onTap: onTap,
            child: Container(
                margin: const EdgeInsets.all(PsDimens.space8),
                child: BlogListItemWidget(blog: blog))),
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: animation,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: child));
        });
  }
}

class BlogListItemWidget extends StatelessWidget {
  const BlogListItemWidget({
    Key key,
    @required this.blog,
  }) : super(key: key);

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * .15,
                            height: MediaQuery.of(context).size.width * .15,
                            decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: PsColors.mainShadowColor,
                                      offset: const Offset(0, 2),
                                      blurRadius: 4.0,
                                      spreadRadius: 1.5),
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "${PsConfig.ps_app_image_thumbs_url}${blog.addedUser.userProfilePhoto}"),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1000))),
                          ),
                          const SizedBox(
                            height: PsDimens.space16,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RoutePaths.userDetail,
                            // arguments: data.addedUserId
                            arguments: UserIntentHolder(
                                userId: blog.addedUser.userId, userName:  blog.addedUser.userName));
                      },
                      child: Text(
                        blog.addedUser.userName,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.clip,
                      ),
                    ),

                      Container(
                        width: MediaQuery.of(context).size.width * .65,
                        child: Text(
                          blog.description,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.justify,
                        ),
                      )
                    ],)

                  ],
                ))),


      ],
    );
  }
}
