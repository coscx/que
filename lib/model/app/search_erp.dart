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

class SearchErp {
  SearchErp({
    this.status,
    this.code,
    this.data,
  });

  factory SearchErp.fromJson(Map<String, dynamic> json) => json == null
      ? null
      : SearchErp(
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
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    final List<Data1> data = json['data'] is List ? <Data1>[] : null;
    if (data != null) {
      for (final dynamic item in json['data']) {
        if (item != null) {
          tryCatch(() {
            data.add(Data1.fromJson(asT<Map<String, dynamic>>(item)));
          });
        }
      }
    }
    return Data(
      currentPage: asT<int>(json['current_page']),
      data: data,
      firstPageUrl: asT<String>(json['first_page_url']),
      from: asT<int>(json['from']),
      lastPage: asT<int>(json['last_page']),
      lastPageUrl: asT<String>(json['last_page_url']),
      nextPageUrl: asT<String>(json['next_page_url']),
      path: asT<String>(json['path']),
      perPage: asT<int>(json['per_page']),
      prevPageUrl: asT<String>(json['prev_page_url']),
      to: asT<int>(json['to']),
      total: asT<int>(json['total']),
    );
  }

  int currentPage;
  List<Data1> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  String prevPageUrl;
  int to;
  int total;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'current_page': currentPage,
    'data': data,
    'first_page_url': firstPageUrl,
    'from': from,
    'last_page': lastPage,
    'last_page_url': lastPageUrl,
    'next_page_url': nextPageUrl,
    'path': path,
    'per_page': perPage,
    'prev_page_url': prevPageUrl,
    'to': to,
    'total': total,
  };
}

class Data1 {
  Data1({
    this.id,
    this.uuid,
    this.code,
    this.createId,
    this.createName,
    this.storeId,
    this.storeName,
    this.createUserType,
    this.birthday,
    this.headImg,
    this.isPassive,
    this.name,
    this.mobile,
    this.saleName,
    this.gender,
    this.age,
    this.height,
    this.weight,
    this.education,
    this.income,
    this.hasHouse,
    this.hasCar,
    this.marriage,
    this.npProvinceName,
    this.lastConnectTime,
    this.createdAt,
    this.npCityName,
    this.connectCount,
    this.appointmentCount,
    this.channel,
    this.status,
    this.userType,
    this.spreadId,
    this.applyTypes,
    this.spreadName,
  });

  factory Data1.fromJson(Map<String, dynamic> json) => json == null
      ? null
      : Data1(
    id: asT<int>(json['id']),
    uuid: asT<String>(json['uuid']),
    code: asT<String>(json['code']),
    createId: asT<int>(json['create_id']),
    createName: asT<String>(json['create_name']),
    storeId: asT<int>(json['store_id']),
    storeName: asT<String>(json['store_name']),
    createUserType: asT<int>(json['create_user_type']),
    birthday: asT<String>(json['birthday']),
    headImg: asT<String>(json['head_img']),
    isPassive: asT<int>(json['is_passive']),
    name: asT<String>(json['name']),
    mobile: asT<String>(json['mobile']),
    saleName: asT<String>(json['sale_name']),
    gender: asT<int>(json['gender']),
    age: asT<int>(json['age']),
    height: asT<int>(json['height']),
    weight: asT<int>(json['weight']),
    education: asT<int>(json['education']),
    income: asT<int>(json['income']),
    hasHouse: asT<int>(json['has_house']),
    hasCar: asT<int>(json['has_car']),
    marriage: asT<int>(json['marriage']),
    npProvinceName: asT<String>(json['np_province_name']),
    lastConnectTime: asT<String>(json['last_connect_time']),
    createdAt: asT<String>(json['created_at']),
    npCityName: asT<String>(json['np_city_name']),
    connectCount: asT<int>(json['connect_count']),
    appointmentCount: asT<int>(json['appointment_count']),
    channel: asT<int>(json['channel']),
    status: asT<int>(json['status']),
    userType: asT<int>(json['user_type']),
    spreadId: asT<int>(json['spread_id']),
    applyTypes: asT<int>(json['apply_types']),
    spreadName: asT<String>(json['spread_name']),
  );

  int id;
  String uuid;
  String code;
  int createId;
  String createName;
  int storeId;
  String storeName;
  int createUserType;
  String birthday;
  String headImg;
  int isPassive;
  String name;
  String mobile;
  String saleName;
  int gender;
  int age;
  int height;
  int weight;
  int education;
  int income;
  int hasHouse;
  int hasCar;
  int marriage;
  String npProvinceName;
  String lastConnectTime;
  String createdAt;
  String npCityName;
  int connectCount;
  int appointmentCount;
  int channel;
  int status;
  int userType;
  int spreadId;
  int applyTypes;
  String spreadName;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'uuid': uuid,
    'code': code,
    'create_id': createId,
    'create_name': createName,
    'store_id': storeId,
    'store_name': storeName,
    'create_user_type': createUserType,
    'birthday': birthday,
    'head_img': headImg,
    'is_passive': isPassive,
    'name': name,
    'mobile': mobile,
    'sale_name': saleName,
    'gender': gender,
    'age': age,
    'height': height,
    'weight': weight,
    'education': education,
    'income': income,
    'has_house': hasHouse,
    'has_car': hasCar,
    'marriage': marriage,
    'np_province_name': npProvinceName,
    'last_connect_time': lastConnectTime,
    'created_at': createdAt,
    'np_city_name': npCityName,
    'connect_count': connectCount,
    'appointment_count': appointmentCount,
    'channel': channel,
    'status': status,
    'user_type': userType,
    'spread_id': spreadId,
    'apply_types': applyTypes,
    'spread_name': spreadName,
  };
}
