import 'package:haraj/viewobject/common/ps_holder.dart'
    show PsHolder;

class CommentEntryParameterHolder extends PsHolder<CommentEntryParameterHolder> {
  CommentEntryParameterHolder({
    this.itemId,
    this.description,
      this.id,
    this.addedUserId,
    this.status
  });

  final String itemId;
  final String description;
   final String id;
  final String addedUserId;
  final String status;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['item_id'] = itemId;
    map['description'] = description;
    map['id'] = id;
    map['added_user_id'] = addedUserId;
    map['status'] = status;

    return map;
  }

  @override
  CommentEntryParameterHolder fromMap(dynamic dynamicData) {
    return CommentEntryParameterHolder(
      itemId: dynamicData['item_id'],
       description: dynamicData['description'],
       id: dynamicData['id'],
      addedUserId: dynamicData['added_user_id'],
      status: dynamicData['status'],
    );
  }

  @override
  String getParamKey() {
    String key = '';
    if (itemId != '') {
      key += itemId;
    }
    if (description != '') {
      key += description;
    }

    if (id != '') {
      key += id;
    }
    if (addedUserId != '') {
      key += addedUserId;
    }
    if (status != '') {
      key += status;
    }
    return key;
  }
}
