class MiningHistory {
  int? id;
  String? uuid;
  int? userId;
  int? miningOptionId;
  int? investmentAmount;
  String? startTime;
  String? endTime;
  String? timestamp;
  double? dailyReturnPercent;
  double? totalProfit;
  double? penaltyFee;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? name;
  int? singleLimitMin;
  int? singleLimitMax;
  double? dailyRateOfReturnMin;
  double? dailyRateOfReturnMax;
  String? period;
  double? defaultSettlementRatio;

  MiningHistory(
      {this.id,
      this.uuid,
      this.userId,
      this.miningOptionId,
      this.investmentAmount,
      this.startTime,
      this.endTime,
      this.timestamp,
      this.dailyReturnPercent,
      this.totalProfit,
      this.penaltyFee,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.singleLimitMin,
      this.singleLimitMax,
      this.dailyRateOfReturnMin,
      this.dailyRateOfReturnMax,
      this.period,
      this.defaultSettlementRatio});

  MiningHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    userId = json['user_id'];
    miningOptionId = json['mining_option_id'];
    investmentAmount = json['investment_amount'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    timestamp = json['timestamp'];
    dailyReturnPercent = json['daily_return_percent'];
    totalProfit = json['total_profit'];
    penaltyFee = json['penalty_fee'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['uuid'] = uuid;
    data['user_id'] = userId;
    data['mining_option_id'] = miningOptionId;
    data['investment_amount'] = investmentAmount;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['timestamp'] = timestamp;
    data['daily_return_percent'] = dailyReturnPercent;
    data['total_profit'] = totalProfit;
    data['penalty_fee'] = penaltyFee;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
