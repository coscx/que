import 'dart:convert';
import 'dart:developer';

void tryCatch(Function f) {
  try {
    f?.call();
  } catch (e, stack) {
    log('$e');
    log('$stack');
  }
}

class FFConvert {
  FFConvert._();

  static T Function<T>(dynamic value) convert = <T>(dynamic value) {
    if (value == null) {
      return null;
    }
    return json.decode(value.toString()) as T;
  };
}

T asT<T>(dynamic value, [T defaultValue]) {
  if (value is T) {
    return value;
  }
  try {
    if (value != null) {
      final String valueS = value.toString();
      if ('' is T) {
        return valueS as T;
      } else if (0 is T) {
        return int.parse(valueS) as T;
      } else if (0.0 is T) {
        return double.parse(valueS) as T;
      } else if (false is T) {
        if (valueS == '0' || valueS == '1') {
          return (valueS == '1') as T;
        }
        return (valueS == 'true') as T;
      } else {
        return FFConvert.convert<T>(value);
      }
    }
  } catch (e, stackTrace) {
    log('asT<$T>', error: e, stackTrace: stackTrace);
    return defaultValue;
  }

  return defaultValue;
}

class LoginModel {
  LoginModel({
    this.status,
    this.code,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => json == null
      ? null
      : LoginModel(
    status: asT<String>(json['status']),
    code: asT<int>(json['code']),
    data: Data.fromJson(asT<Map<String, dynamic>>(json['data'])),
  );

  String status;
  int code;
  Data data;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'status': status,
    'code': code,
    'data': data,
  };
}

class Data {
  Data({
    this.user,
    this.token,
    this.imToken,
    this.tokenType,
    this.expiresIn,
    this.accessToken,
    this.refreshToken,
    this.avatar,
  });

  factory Data.fromJson(Map<String, dynamic> json) => json == null
      ? null
      : Data(
    user: User.fromJson(asT<Map<String, dynamic>>(json['user'])),
    token: Token.fromJson(asT<Map<String, dynamic>>(json['token'])),
    imToken: asT<String>(json['im_token']),
    tokenType: asT<String>(json['token_type']),
    expiresIn: asT<int>(json['expires_in']),
    accessToken: asT<String>(json['access_token']),
    refreshToken: asT<String>(json['refresh_token']),
    avatar: asT<String>(json['avatar']),
  );

  User user;
  Token token;
  String imToken;
  String tokenType;
  int expiresIn;
  String accessToken;
  String refreshToken;
  String avatar;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'user': user,
    'token': token,
    'im_token': imToken,
    'token_type': tokenType,
    'expires_in': expiresIn,
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'avatar': avatar,
  };
}

class User {
  User({
    this.id,
    this.uuid,
    this.departmentId,
    this.mobile,
    this.mobileVerified,
    this.notificationCount,
    this.messageCount,
    this.avatar,
    this.nickname,
    this.openid,
    this.unionid,
    this.relname,
    this.idcard,
    this.idcardVerified,
    this.lastLoginAt,
    this.lastLoginIp,
    this.isFirst,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.secret,
    this.userType,
    this.dataScope,
    this.dataType,
    this.commonType,
    this.ccId,
    this.qiyu,
    this.store,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    final List<Store> store = json['store'] is List ? <Store>[] : null;
    if (store != null) {
      for (final dynamic item in json['store']) {
        if (item != null) {
          tryCatch(() {
            store.add(Store.fromJson(asT<Map<String, dynamic>>(item)));
          });
        }
      }
    }
    return User(
      id: asT<int>(json['id']),
      uuid: asT<String>(json['uuid']),
      departmentId: asT<int>(json['department_id']),
      mobile: asT<String>(json['mobile']),
      mobileVerified: asT<int>(json['mobile_verified']),
      notificationCount: asT<int>(json['notification_count']),
      messageCount: asT<int>(json['message_count']),
      avatar: asT<String>(json['avatar']),
      nickname: asT<String>(json['nickname']),
      openid: asT<String>(json['openid']),
      unionid: asT<String>(json['unionid']),
      relname: asT<String>(json['relname']),
      idcard: asT<String>(json['idcard']),
      idcardVerified: asT<int>(json['idcard_verified']),
      lastLoginAt: asT<String>(json['last_login_at']),
      lastLoginIp: asT<String>(json['last_login_ip']),
      isFirst: asT<int>(json['is_first']),
      status: asT<int>(json['status']),
      createdAt: asT<String>(json['created_at']),
      updatedAt: asT<String>(json['updated_at']),
      secret: asT<String>(json['secret']),
      userType: asT<int>(json['user_type']),
      dataScope: asT<int>(json['data_scope']),
      dataType: asT<int>(json['data_type']),
      commonType: asT<int>(json['common_type']),
      ccId: asT<int>(json['cc_id']),
      qiyu: asT<String>(json['qiyu']),
      store: store,
    );
  }

  int id;
  String uuid;
  int departmentId;
  String mobile;
  int mobileVerified;
  int notificationCount;
  int messageCount;
  String avatar;
  String nickname;
  String openid;
  String unionid;
  String relname;
  String idcard;
  int idcardVerified;
  String lastLoginAt;
  String lastLoginIp;
  int isFirst;
  int status;
  String createdAt;
  String updatedAt;
  String secret;
  int userType;
  int dataScope;
  int dataType;
  int commonType;
  int ccId;
  String qiyu;
  List<Store> store;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'uuid': uuid,
    'department_id': departmentId,
    'mobile': mobile,
    'mobile_verified': mobileVerified,
    'notification_count': notificationCount,
    'message_count': messageCount,
    'avatar': avatar,
    'nickname': nickname,
    'openid': openid,
    'unionid': unionid,
    'relname': relname,
    'idcard': idcard,
    'idcard_verified': idcardVerified,
    'last_login_at': lastLoginAt,
    'last_login_ip': lastLoginIp,
    'is_first': isFirst,
    'status': status,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'secret': secret,
    'user_type': userType,
    'data_scope': dataScope,
    'data_type': dataType,
    'common_type': commonType,
    'cc_id': ccId,
    'qiyu': qiyu,
    'store': store,
  };
}

class Store {
  Store({
    this.storeId,
    this.storeName,
    this.expireTime,
    this.pivot,
  });

  factory Store.fromJson(Map<String, dynamic> json) => json == null
      ? null
      : Store(
    storeId: asT<int>(json['store_id']),
    storeName: asT<String>(json['store_name']),
    expireTime: asT<String>(json['expire_time']),
    pivot: Pivot.fromJson(asT<Map<String, dynamic>>(json['pivot'])),
  );

  int storeId;
  String storeName;
  String expireTime;
  Pivot pivot;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'store_id': storeId,
    'store_name': storeName,
    'expire_time': expireTime,
    'pivot': pivot,
  };
}

class Pivot {
  Pivot({
    this.userId,
    this.storeId,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => json == null
      ? null
      : Pivot(
    userId: asT<int>(json['user_id']),
    storeId: asT<int>(json['store_id']),
  );

  int userId;
  int storeId;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'user_id': userId,
    'store_id': storeId,
  };
}

class Token {
  Token({
    this.tokenType,
    this.expiresIn,
    this.accessToken,
    this.refreshToken,
  });

  factory Token.fromJson(Map<String, dynamic> json) => json == null
      ? null
      : Token(
    tokenType: asT<String>(json['token_type']),
    expiresIn: asT<int>(json['expires_in']),
    accessToken: asT<String>(json['access_token']),
    refreshToken: asT<String>(json['refresh_token']),
  );

  String tokenType;
  int expiresIn;
  String accessToken;
  String refreshToken;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'token_type': tokenType,
    'expires_in': expiresIn,
    'access_token': accessToken,
    'refresh_token': refreshToken,
  };
}
