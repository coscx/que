
getConnectLevel(info) {
  try {
    return connectLevel[info];
  } catch (e) {
    return "未知";
  }
}
getEduLevel(info) {
  try {
    return EduLevel[info];
  } catch (e) {
    return "未知";
  }
}

getWorkType(info) {
  try {
    return WorkTypeLevel[info];
  } catch (e) {
    return "未知";
  }
}

getWorkOverTime(info) {
  try {
    return WorkOverTimeLevel[info];
  } catch (e) {
    return "未知";
  }
}

getIncome(info) {
  try {
    return IncomeLevel[info];
  } catch (e) {
    return "未知";
  }
}

getHasHouse(info) {
  try {
    return hasHouseLevel[info];
  } catch (e) {
    return "未知";
  }
}

getHouseFuture(info) {
  try {
    return houseFutureLevel[info];
  } catch (e) {
    return "未知";
  }
}

getHasCar(info) {
  try {
    return hasCarLevel[info];
  } catch (e) {
    return "未知";
  }
}

getCarLevel(info) {
  try {
    return carLevelLevel[info];
  } catch (e) {
    return "未知";
  }
}

getMarriageLevel(info) {
  try {
    return marriageLevel[info];
  } catch (e) {
    return "未知";
  }
}

getChildLevel(info) {
  try {
    return childLevel[info];
  } catch (e) {
    return "未知";
  }
}

getOnlyChildLevel(info) {
  try {
    return onlyChildLevel[info];
  } catch (e) {
    return "未知";
  }
}

getParentLevel(info) {
  try {
    return parentLevel[info];
  } catch (e) {
    return "未知";
  }
}

getParentProtectLevel(info) {
  try {
    return parentProtectLevel[info];
  } catch (e) {
    return "未知";
  }
}

getFaithLevel(info) {
  try {
    return faithLevel[info];
  } catch (e) {
    return "未知";
  }
}

getSmokeLevel(info) {
  try {
    return smokeLevel[info];
  } catch (e) {
    return "未知";
  }
}

getDrinkLevel(info) {
  try {
    return drinkLevel[info];
  } catch (e) {
    return "未知";
  }
}

getLifeLevel(info) {
  try {
    return lifeLevel[info];
  } catch (e) {
    return "未知";
  }
}

getCreatLevel(info) {
  try {
    return creatLevel[info];
  } catch (e) {
    return "未知";
  }
}

getMarriageDateLevel(info) {
  try {
    return marriageDateLevel[info];
  } catch (e) {
    return "未知";
  }
}

getFloodLevel(info) {
  try {
    return floodLevel[info];
  } catch (e) {
    return "未知";
  }
}

getSexLevel(info) {
  try {
    return sexLevel[info];
  } catch (e) {
    return "未知";
  }
}

getNationLevel(info) {
  try {
    return nationLevel[info];
  } catch (e) {
    return "未知";
  }
}

getCompanyLevel(info) {
  try {
    return companyTypeLevel[info];
  } catch (e) {
    return "未知";
  }
}

getAgeDemand(String age) {
  try {

    return age.replaceAll(",", "-")+"岁";
  } catch (e) {
    return age;
  }
}
getHeightDemand(String age) {
  try {

    return age.replaceAll(",", "-")+"cm";
  } catch (e) {
    return age;
  }
}
getWeightDemand(String age) {
  try {

    return age+"kg";
  } catch (e) {
    return age;
  }
}
int getIndexOfList(List<String> orc, String input) {
  var index = orc.indexOf(input);
  return index;
}

List<String> getAgeList() {
  List<String> age = [];
  for (var i = 14; i < 99; i++) {
    age.add(i.toString() + " 岁");
  }
  return age;
}

List<String> getWeightList() {
  List<String> weight = [];
  for (var i = 30; i < 200; i++) {
    weight.add(i.toString());
  }
  return weight;
}

List<String> getHeightList() {
  List<String> height = [];
  for (var i = 100; i < 200; i++) {
    height.add(i.toString());
  }
  return height;
}

List<String> nationLevel = [
  "未知","汉族","蒙古族","回族","藏族","维吾尔族","苗族","彝族","壮族","布依族","朝鲜族","满族","侗族","瑶族","白族","土家族",
  "哈尼族","哈萨克族","傣族","黎族","傈僳族","佤族","畲族","高山族","拉祜族","水族","东乡族","纳西族","景颇族","柯尔克孜族",
  "土族","达斡尔族","仫佬族","羌族","布朗族","撒拉族","毛南族","仡佬族","锡伯族","阿昌族","普米族","塔吉克族","怒族", "乌孜别克族",
  "俄罗斯族","鄂温克族","德昂族","保安族","裕固族","京族","塔塔尔族","独龙族","鄂伦春族","赫哲族","门巴族","珞巴族","基诺族"
];
List<String> sexLevel = [
  "未知",
  "男生",
  "女生",
];
List<String> floodLevel = [
  "未知",
  "A型",
  "B型",
  "O型",
  "AB型",


];
List<String> EduLevel = [
  "未知",
  "高中及以下",
  "大专",
  "本科",
  "硕士",
  "博士及以上",
  "国外留学",
  "其他",

];
List<String> WorkTypeLevel = [
  "未知",
  "企事业单位公务员",
  "教育医疗",
  "民营企业",
  "私营业主",
  "其他",

];
List<String> companyTypeLevel = [
  "未知",
  "国企",
  "外商独资",
  "合资",
  "民营",
  "股份制企业",
  "上市公司",
  "国家机关",
  "事业单位",
  "银行",
  "医院",
  "学校",
  "律师事务所",
  "社会团体",
  "港澳台公司",
  "其他",
];
List<String> WorkOverTimeLevel = [
  "未知",
  "不加班",
  "偶尔加班",
  "经常加班",

];
List<String> IncomeLevel = [
  "未知",
  "5万及以下",
  "5-10万",
  "10-15万",
  "15-20万",
  "20-30万",
  "30-50万",
  "50-70万",
  "70-100万",
  "100万以上",
];
List<String> hasHouseLevel = [
  "未知",
  "无房",
  "1套房",
  "2套房",
  "3套房及以上",
  "其他",
];
List<String> houseFutureLevel = [
  "未知",
  "无房贷",
  "已还清",
  "在还贷",

];
List<String> hasCarLevel = [
  "未知",
  "有车",
  "无车",
];
List<String> carLevelLevel = [
  "未知",
  "无车产",
  "5-10万车",
  "10-20万车",
  "20-30万车",
  "30-50万车",
  "50万以上车",
];
List<String> marriageLevel = [
  "请选择",
  "未婚",
  "离异带孩",
  "离异单身",
  "离异未育",
  "丧偶",
];
List<String> childLevel = [
  "未知",
  "有",
  "无",
];
List<String> onlyChildLevel = [
  "未知",
  "是",
  "否",
];
List<String> parentLevel = [
  "未知",
  "父母同在",
  "父歿母在",
  "父在母歿",
  "父母同歿",
];
List<String> parentProtectLevel = [
  "未知",
  "父亲有医保",
  "母亲有医保",
  "父母均有医保",
];
List<String> faithLevel = [
  "未知",
  "无信仰",
  "基督教",
  "天主教",
  "佛教",
  "道教",
  "伊斯兰教",
  "其他宗教",

];
List<String> smokeLevel = [
  "未知",
  "不吸烟",
  "偶尔吸烟",
  "经常吸烟",
  "有戒烟计划",
];
List<String> drinkLevel = [
  "未知",
  "不喝酒",
  "偶尔喝",
  "应酬喝",
  "经常喝",
  "有戒酒计划",
];
List<String> lifeLevel = [
  "未知",
  "很规律",
  "经常熬夜",
];
List<String> creatLevel = [
  "未知",
  "想要孩子",
  "可以考虑",
  "想要孩子",
];
List<String> marriageDateLevel = [
  "未知",
  "半年内",
  "一年内",
  "2年内",
  "还没想好",
];


List<String>  fromLevel = [
  "请选择",
  "个人自带",
  "线下活动",
  "罗沈民提供名单",
  "大家亲CRM系统",
  "大家亲同城相亲圈",
];
List<String>  connectLevel = [
  "新分未联系",
  "号码无效",
  "号码未接通",
  "可继续沟通",
  "有意向面谈",
  "确定到店时间",
  "已到店，意愿需跟进",
  "已到店，考虑7天付款",
  "高级会员，支付预付款",
  "高级会员，费用已结清",
  "毁单",
  "放弃并放入公海",
  "放弃并放入D级",
];

