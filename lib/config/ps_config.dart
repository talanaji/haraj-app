// Copyright (c) 2019, the Panacea-Soft.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// Panacea-Soft license that can be found in the LICENSE file.

import 'package:haraj/viewobject/common/language.dart';

class PsConfig {
  PsConfig._();

  ///
  /// App Version
  /// For your app, you need to change according based on your app version
  ///
  static const String app_version = '1.5';

  ///
  /// API Key
  /// If you change here, you need to update in server.
  ///
  static const String ps_api_key = 'harajalshamal';

  ///
  /// API URL
  /// Change your backend url
  ///
  static const String ps_core_url = 'http://haraj-alshamal.info';

  static const String ps_app_url =
      ps_core_url + '/index.php/';

  static const String ps_app_image_url =
      ps_core_url + '/uploads/';

  static const String ps_app_image_thumbs_url =
      ps_core_url + '/uploads/thumbnail/';

  ///
  /// Chat Setting
  ///


  static const String iosGoogleAppId = '0:000000000000:ios:0000000000000000000000';
  static const String iosGcmSenderId = '000000000000';
  static const String iosProjectId = 'flutter-admotors';
  static const String iosDatabaseUrl = 'https://harajalshamal-default-rtdb.firebaseio.com';
  static const String iosApiKey = 'AIz000000000000000000000000000000000000';

  static const String androidGoogleAppId = '1:32459940800:android:0dc8f065d6a4b26cd11e25';
  static const String androidGcmSenderId = '32459940800';
  static const String androidProjectId = 'harajalshamal';
  static const String androidApiKey = 'AIzaSyB5U3vs87OrgD50loe85GBtzJmRhPjK9Wc';
  static const String androidDatabaseUrl = 'https://harajalshamal-default-rtdb.firebaseio.com';

  /// Facebook Key
  ///
  static const String fbKey = '000000000000000';

  ///
  ///Admob Setting
  ///
  static bool showAdMob = true;
  static String androidAdMobAdsIdKey = 'ca-app-pub-0000000000000000~0000000000';
  static String androidAdMobUnitIdApiKey = 'ca-app-pub-0000000000000000/0000000000';
  static String iosAdMobAdsIdKey = 'ca-app-pub-0000000000000000~0000000000';
  static String iosAdMobUnitIdApiKey = 'ca-app-pub-0000000000000000/0000000000';



  ///
  /// Animation Duration
  ///
  static const Duration animation_duration = Duration(milliseconds: 500);

  ///
  /// Fonts Family Config
  /// Before you declare you here,
  /// 1) You need to add font under assets/fonts/
  /// 2) Declare at pubspec.yaml
  /// 3) Update your font family name at below
  ///
  static const String ps_default_font_family = 'kufi';


  static const String ps_app_db_name = 'ps_db.db';

  static final Language defaultLanguage =
  Language(languageCode: 'ar', countryCode: 'DZ', name: 'Arabic');
  static final List<Language> psSupportedLanguageList = <Language>[
    Language(languageCode: 'ar', countryCode: 'DZ', name: 'Arabic'),
  ];

  ///
  /// Price Format
  /// Need to change according to your format that you need
  /// E.g.
  /// ",##0.00"   => 2,555.00
  /// "##0.00"    => 2555.00
  /// ".00"       => 2555.00
  /// ",##0"      => 2555
  /// ",##0.0"    => 2555.0
  ///
  static const String priceFormat = ',###.00';

  ///
  /// Date Time Format
  ///
  static const String dateFormat = 'dd-MM-yyyy hh:mm:ss';

  ///
  /// iOS App No
  ///
  static const String iOSAppStoreId = '000000000';

  ///
  /// Tmp Image Folder Name
  ///
  static const String tmpImageFolderName = 'HarajAlshamal';

  ///
  /// Image Loading
  ///
  /// - If you set "true", it will load thumbnail image first and later it will
  ///   load full image
  /// - If you set "false", it will load full image directly and for the
  ///   placeholder image it will use default placeholder Image.
  ///
  static const bool USE_THUMBNAIL_AS_PLACEHOLDER = false;

  ///
  /// Token Id
  ///"true" = it will show token id under setting
  static const bool isShowTokenId = false;

  ///
  /// ShowSubCategory
  ///
  static const bool isShowModel = false;

  ///
  /// Promote Item
  ///
  static const String PROMOTE_FIRST_CHOICE_DAY_OR_DEFAULT_DAY = '7 ';
  static const String PROMOTE_SECOND_CHOICE_DAY = '14 ';
  static const String PROMOTE_THIRD_CHOICE_DAY = '30 ';
  static const String PROMOTE_FOURTH_CHOICE_DAY = '60 ';

  ///
  /// Image Size
  ///
  static const int uploadImageSize = 1024;
  static const int profileImageSize = 512;
  static const int chatImageSize = 650;

  ///
  /// Default Limit
  ///
  static const int DEFAULT_LOADING_LIMIT = 30;
  static const int CATEGORY_LOADING_LIMIT = 10;
  static const int RECENT_ITEM_LOADING_LIMIT = 10;
  static const int POPULAR_ITEM_LOADING_LIMIT = 10;
  static const int FEATURE_ITEM_LOADING_LIMIT = 10;
  static const int BLOCK_SLIDER_LOADING_LIMIT = 10;
  static const int BUNNER_SLIDER_LOADING_LIMIT = 10;
  static const int FOLLOWER_ITEM_LOADING_LIMIT = 10;

  ///
  ///Login Setting
  ///
  static bool showFacebookLogin = false;
  static bool showGoogleLogin = false;
  static bool showPhoneLogin = true;

  ///
  /// Map Filter Setting
  ///
  static bool noFilterWithLocationOnMap = false;

  ///
  /// Razor Currency
  ///
  static bool isRazorSupportMultiCurrency = false;
  static String defaultRazorCurrency = 'INR'; // Don't change
}
