import 'package:tradexpro_flutter/data/models/mining_options.dart';

class UserMiningWebsocketResponse {
  bool? status;
  String? message;
  List<UserMiningWebSocket>? data;

  UserMiningWebsocketResponse({this.status, this.message, this.data});

  UserMiningWebsocketResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UserMiningWebSocket>[];
      json['data'].forEach((v) {
        data!.add(UserMiningWebSocket.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserMiningWebSocket {
  String? uuid;
  MiningOption? miningOption;
  int? investmentAmount;
  String? startTime;
  String? endTime;
  double? dailyReturnPercent;
  double? totalProfit;
  String? status;

  UserMiningWebSocket(
      {this.uuid,
      this.miningOption,
      this.investmentAmount,
      this.startTime,
      this.endTime,
      this.dailyReturnPercent,
      this.totalProfit,
      this.status});

  UserMiningWebSocket.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    miningOption = json['mining_option'] != null
        ? MiningOption.fromJson(json['mining_option'])
        : null;
    investmentAmount = json['investment_amount'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    dailyReturnPercent = json['daily_return_percent'];
    totalProfit = json['total_profit'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    if (miningOption != null) {
      data['mining_option'] = miningOption!.toJson();
    }
    data['investment_amount'] = investmentAmount;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['daily_return_percent'] = dailyReturnPercent;
    data['total_profit'] = totalProfit;
    data['status'] = status;
    return data;
  }
}

// class MiningOption {
//   int? id;
//   String? name;
//   int? singleLimitMin;
//   int? singleLimitMax;
//   double? dailyRateOfReturnMin;
//   double? dailyRateOfReturnMax;
//   String? period;
//   double? defaultSettlementRatio;
//   String? createdAt;
//   String? updatedAt;

//   MiningOption(
//       {this.id,
//       this.name,
//       this.singleLimitMin,
//       this.singleLimitMax,
//       this.dailyRateOfReturnMin,
//       this.dailyRateOfReturnMax,
//       this.period,
//       this.defaultSettlementRatio,
//       this.createdAt,
//       this.updatedAt});

//   MiningOption.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     singleLimitMin = json['single_limit_min'];
//     singleLimitMax = json['single_limit_max'];
//     dailyRateOfReturnMin = json['daily_rate_of_return_min'];
//     dailyRateOfReturnMax = json['daily_rate_of_return_max'];
//     period = json['period'];
//     defaultSettlementRatio = json['default_settlement_ratio'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['single_limit_min'] = this.singleLimitMin;
//     data['single_limit_max'] = this.singleLimitMax;
//     data['daily_rate_of_return_min'] = this.dailyRateOfReturnMin;
//     data['daily_rate_of_return_max'] = this.dailyRateOfReturnMax;
//     data['period'] = this.period;
//     data['default_settlement_ratio'] = this.defaultSettlementRatio;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
