import 'dart:async';

import 'package:haraj/api/common/ps_resource.dart';
import 'package:haraj/api/common/ps_status.dart';
import 'package:haraj/db/about_us_dao.dart';
import 'package:haraj/db/blog_dao.dart';
import 'package:haraj/db/cateogry_dao.dart';
import 'package:haraj/db/chat_history_dao.dart';
import 'package:haraj/db/chat_history_map_dao.dart';
import 'package:haraj/db/manufacturer_map_dao.dart';
import 'package:haraj/db/model_dao.dart';
import 'package:haraj/db/product_dao.dart';
import 'package:haraj/db/product_map_dao.dart';
import 'package:haraj/db/rating_dao.dart';
import 'package:haraj/db/related_product_dao.dart';
import 'package:haraj/db/user_unread_message_dao.dart';
import 'package:haraj/repository/Common/ps_repository.dart';
import 'package:haraj/viewobject/product.dart';

class ClearAllDataRepository extends PsRepository {
  Future<dynamic> clearAllData(
      StreamController<PsResource<List<Product>>> allListStream) async {
    final ProductDao _productDao = ProductDao.instance;
    final CategoryDao _categoryDao = CategoryDao();
    final ManufacturerMapDao _categoryMapDao = ManufacturerMapDao.instance;
    final ProductMapDao _productMapDao = ProductMapDao.instance;
    final RatingDao _ratingDao = RatingDao.instance;
    final ModelDao _modelDao = ModelDao();
    final BlogDao _blogDao = BlogDao.instance;
    final ChatHistoryDao _chatHistoryDao = ChatHistoryDao.instance;
    final ChatHistoryMapDao _chatHistoryMapDao = ChatHistoryMapDao.instance;
    final UserUnreadMessageDao _userUnreadMessageDao =
        UserUnreadMessageDao.instance;
    final RelatedProductDao _relatedProductDao = RelatedProductDao.instance;
    final AboutUsDao _aboutUsDao = AboutUsDao.instance;
    await _productDao.deleteAll();
    await _blogDao.deleteAll();
    await _categoryDao.deleteAll();
    await _categoryMapDao.deleteAll();
    await _productMapDao.deleteAll();
    await _ratingDao.deleteAll();
    await _modelDao.deleteAll();
    await _chatHistoryDao.deleteAll();
    await _chatHistoryMapDao.deleteAll();
    await _userUnreadMessageDao.deleteAll();
    await _relatedProductDao.deleteAll();
    await _aboutUsDao.deleteAll();

    allListStream.sink.add(await _productDao.getAll(status: PsStatus.SUCCESS));
  }
}
