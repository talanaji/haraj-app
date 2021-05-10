import 'package:haraj/viewobject/common/ps_object.dart';
import 'package:haraj/viewobject/user.dart';
import 'package:quiver/core.dart';
import 'default_photo.dart';

class Blog extends PsObject<Blog> {
  Blog({
    this.id,
    this.item_id,
    this.description,
    this.status,
    this.addedDate,
    this.addedUserId,
    this.updatedDate,
    this.updatedUserId,
    this.addedDateStr,
    this.defaultPhoto,
    this.addedUser
  });
  String id;
  String item_id;
  String description;
  String status;
  String addedDate;
  String addedUserId;
  String updatedDate;
  String updatedUserId;
  String addedDateStr;
  DefaultPhoto defaultPhoto;
  User addedUser;

  @override
  bool operator ==(dynamic other) => other is Blog && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id;
  }

  @override
  Blog fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Blog(
        id: dynamicData['id'],
        item_id: dynamicData['item_id'],
        description: dynamicData['description'],
        status: dynamicData['status'],
        addedDate: dynamicData['added_date'],
        addedUserId: dynamicData['added_user_id'],
        updatedDate: dynamicData['updated_date'],
        updatedUserId: dynamicData['updated_user_id'],
        addedDateStr: dynamicData['added_date_str'],
        defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']),
        addedUser: User().fromMap(dynamicData['user']),

      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> toMap(Blog object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['item_id'] = object.item_id;
      data['description'] = object.description;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_user_id'] = object.updatedUserId;
      data['added_date_str'] = object.addedDateStr;
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);
      data['user'] = User().toMap(object.addedUser);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Blog> fromMapList(List<dynamic> dynamicDataList) {
    final List<Blog> blogList = <Blog>[];

    if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          blogList.add(fromMap(dynamicData));
        }
      }
    }
    return blogList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Blog> objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (Blog data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
    }
    return mapList;
  }
}
