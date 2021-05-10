import 'package:flutter_icons/flutter_icons.dart';
import 'package:haraj/config/ps_colors.dart';
import 'package:haraj/constant/ps_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haraj/constant/ps_dimens.dart';
import 'package:haraj/ui/common/ps_hero.dart';
import 'package:haraj/ui/common/ps_ui_widget.dart';
import 'package:haraj/utils/utils.dart';
import 'package:haraj/viewobject/product.dart';
import 'package:provider/provider.dart';
import 'package:haraj/provider/blog/blog_provider.dart';
import 'package:haraj/repository/blog_repository.dart';

class ProductHorizontalListItem extends StatefulWidget {
  const ProductHorizontalListItem({
    Key key,
    @required this.product,
    @required this.coreTagKey,
    @required this.productId,
    this.onTap,
  }) : super(key: key);

  final Product product;
  final Function onTap;
  final String coreTagKey;
  final String productId;
  @override
  _ProductHorizontalListItemState createState() =>
      _ProductHorizontalListItemState();
}

class _ProductHorizontalListItemState extends State<ProductHorizontalListItem>
    with SingleTickerProviderStateMixin {
  BlogProvider blogProvider;
  BlogRepository repo1;

  @override
  Widget build(BuildContext context) {
    // print('***Tag*** $coreTagKey${PsConst.HERO_TAG__IMAGE}');
    repo1 = Provider.of<BlogRepository>(context);
    blogProvider = BlogProvider(repo: repo1);
    return InkWell(
      onTap: widget.onTap,
      child: Card(
          elevation: 0.0,
          color: PsColors.transparent,
          child: Card(
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: PsDimens.space4, vertical: PsDimens.space8),
              decoration: BoxDecoration(
                color: PsColors.backgroundColor,
                borderRadius:
                    const BorderRadius.all(Radius.circular(PsDimens.space8)),
              ),
              width: MediaQuery.of(context).size.width * .9,
              // child:
              //  ClipPath(
              // child: Container(
              //   // color: Colors.white,
              //   width: PsDimens.space180,
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: PsDimens.space4,
                          top: PsDimens.space4,
                          right: PsDimens.space8,
                          bottom: PsDimens.space4,
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: PsDimens.space80,
                              height: PsDimens.space80,
                              child: PsNetworkCircleImageForUser(
                                photoKey:
                                    '${widget.coreTagKey}${PsConst.HERO_TAG__IMAGE}',
                                imagePath: widget.product.defaultPhoto.imgPath,
                                // width: PsDimens.space40,
                                // height: PsDimens.space40,
                                boxfit: BoxFit.cover,
                                onTap: () {
                                  Utils.psPrint(
                                      widget.product.defaultPhoto.imgParentId);
                                  widget.onTap();
                                },
                              ),
                            ),
                            const SizedBox(width: PsDimens.space8),
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: PsDimens.space8,
                                        top: PsDimens.space8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(widget.product.title,
                                            textAlign: TextAlign.start,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                        Text('${widget.product.description}',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption.copyWith(fontSize: 12))
                                      ],
                                    )))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: PsDimens.space4,
                          top: PsDimens.space4,
                          right: PsDimens.space8,
                          bottom: PsDimens.space4,
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * .20,
                              child: Row(
                                children: [
                                  Icon(
                                    PsColors.location,
                                    color: PsColors.mainColor,
                                    size: 16,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          MediaQuery.of(context).size.width *
                                              .01,
                                          0,
                                          0,
                                          0)),
                                  Text(widget.product.itemLocation.name,style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .20,
                              child: Row(
                                children: [
                                  Icon(PsColors.group__2,
                                      color: PsColors.mainColor, size: 20),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          MediaQuery.of(context).size.width *
                                              .01,
                                          0,
                                          0,
                                          0)),
                                  Text(widget.product.price,style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .35,
                              child: Row(
                                children: [
                                  Icon(FlutterIcons.tag_outline_mco,
                                      color: PsColors.mainColor, size: 20),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          MediaQuery.of(context).size.width *
                                              .01,
                                          0,
                                          0,
                                          0)),
                                  Text(
                                    widget.product.manufacturer.name,
                                    overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12)
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .15,
                              child: Row(
                                children: [
                                  Icon(PsColors.messages_icon,
                                      color: PsColors.mainColor, size: 20),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          MediaQuery.of(context).size.width *
                                              .01,
                                          0,
                                          0,
                                          0)),
                                  ChangeNotifierProvider<BlogProvider>(
                                    lazy: false,
                                    create: (BuildContext context) {
                                      final BlogProvider provider =
                                          BlogProvider(repo: repo1);
                                      provider.loadBlogList(widget.productId);
                                      blogProvider = provider;
                                      return blogProvider;
                                    },
                                    child: Consumer<BlogProvider>(builder:
                                        (BuildContext context,
                                            BlogProvider blogProvider,
                                            Widget child) {
                                      return Text(
                                          "${blogProvider.blogList.data.length}", style: TextStyle(fontSize: 12),);
                                    }),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // ),
              // clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
            ),
          )),
    );
  }
}
