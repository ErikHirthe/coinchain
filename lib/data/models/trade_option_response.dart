import 'package:tradexpro_flutter/data/models/available_balance.dart';

class TradeOptionResponse {
  bool? status;
  String? message;
  List<TradeOptions>? tradeOptions;
  TradeHandlingFee? tradeHandlingFee;
  AvailableBalance? availableBalance;

  TradeOptionResponse({
    this.status,
    this.message,
    this.tradeOptions,
    this.tradeHandlingFee,
    this.availableBalance,
  });

  TradeOptionResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['trade_options'] != null) {
      tradeOptions = <TradeOptions>[];
      json['trade_options'].forEach((v) {
        tradeOptions!.add(TradeOptions.fromJson(v));
      });
    }
    tradeHandlingFee = json['trade_handling_fee'] != null
        ? TradeHandlingFee.fromJson(json['trade_handling_fee'])
        : null;
    availableBalance = json['available_balance'] != null
        ? AvailableBalance.fromJson(json['available_balance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (tradeOptions != null) {
      data['trade_options'] = tradeOptions!.map((v) => v.toJson()).toList();
    }
    if (tradeHandlingFee != null) {
      data['trade_handling_fee'] = tradeHandlingFee!.toJson();
    }
    if (availableBalance != null) {
      data['available_balance'] = availableBalance!.toJson();
    }
    return data;
  }
}

class TradeOptions {
  int? id;
  String? durationTimeForshow;
  String? durationTime;
  int? percent;
  int? minimumAmount;
  int? maximumAmount;
  String? createdAt;
  String? updatedAt;

  TradeOptions(
      {this.id,
      this.durationTimeForshow,
      this.durationTime,
      this.percent,
      this.minimumAmount,
      this.maximumAmount,
      this.createdAt,
      this.updatedAt});

  TradeOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    durationTimeForshow = json['duration_time_forshow'];
    durationTime = json['duration_time'];
    percent = json['percent'];
    minimumAmount = json['minimum_amount'];
    maximumAmount = json['maximum_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['duration_time_forshow'] = durationTimeForshow;
    data['duration_time'] = durationTime;
    data['percent'] = percent;
    data['minimum_amount'] = minimumAmount;
    data['maximum_amount'] = maximumAmount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class TradeHandlingFee {
  int? id;
  double? handlingFee;
  String? createdAt;
  String? updatedAt;

  TradeHandlingFee({this.id, this.handlingFee, this.createdAt, this.updatedAt});

  TradeHandlingFee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    handlingFee = json['handling_fee'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['handling_fee'] = handlingFee;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
