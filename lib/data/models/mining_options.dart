class MiningOptionResponse {
  bool? status;
  String? message;
  UserMiningOverall? item;
  List<MiningOption>? data;

  MiningOptionResponse({this.status, this.message, this.item, this.data});

  MiningOptionResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    item =
        json['item'] != null ? UserMiningOverall.fromJson(json['item']) : null;
    if (json['data'] != null) {
      data = <MiningOption>[];
      json['data'].forEach((v) {
        data!.add(MiningOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (item != null) {
      data['item'] = item!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserMiningOverall {
  String? fundsInCustody;
  num? expectedEarnings;
  int? cumulativeIncome;
  int? orderInCustody;

  UserMiningOverall(
      {this.fundsInCustody,
      this.expectedEarnings,
      this.cumulativeIncome,
      this.orderInCustody});

  UserMiningOverall.fromJson(Map<String, dynamic> json) {
    fundsInCustody = json['funds_in_custody'];
    expectedEarnings = json['expected_earnings'];
    cumulativeIncome = json['cumulative_income'];
    orderInCustody = json['order_in_custody'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['funds_in_custody'] = fundsInCustody;
    data['expected_earnings'] = expectedEarnings;
    data['cumulative_income'] = cumulativeIncome;
    data['order_in_custody'] = orderInCustody;
    return data;
  }
}

class MiningOption {
  int? id;
  String? name;
  int? singleLimitMin;
  int? singleLimitMax;
  num? dailyRateOfReturnMin;
  num? dailyRateOfReturnMax;
  String? period;
  num? defaultSettlementRatio;

  MiningOption({
    this.id,
    this.name,
    this.singleLimitMin,
    this.singleLimitMax,
    this.dailyRateOfReturnMin,
    this.dailyRateOfReturnMax,
    this.period,
    this.defaultSettlementRatio,
  });

  MiningOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    singleLimitMin = json['single_limit_min'];
    singleLimitMax = json['single_limit_max'];
    dailyRateOfReturnMin = json['daily_rate_of_return_min'];
    dailyRateOfReturnMax = json['daily_rate_of_return_max'];
    period = json['period'];
    defaultSettlementRatio = json['default_settlement_ratio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['single_limit_min'] = singleLimitMin;
    data['single_limit_max'] = singleLimitMax;
    data['daily_rate_of_return_min'] = dailyRateOfReturnMin;
    data['daily_rate_of_return_max'] = dailyRateOfReturnMax;
    data['period'] = period;
    data['default_settlement_ratio'] = defaultSettlementRatio;
    return data;
  }
}
