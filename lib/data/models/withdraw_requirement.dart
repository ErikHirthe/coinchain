import 'package:tradexpro_flutter/data/models/available_balance.dart';

class WithdrawRequirementResponse {
  bool? status;
  String? message;
  WithdrawHandlingFee? withdrawHandlingFee;
  AvailableBalance? availableBalance;

  WithdrawRequirementResponse({
    this.status,
    this.message,
    this.withdrawHandlingFee,
    this.availableBalance,
  });

  WithdrawRequirementResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    withdrawHandlingFee = json['withdraw_handling_fee'] != null
        ? WithdrawHandlingFee.fromJson(json['withdraw_handling_fee'])
        : null;
    availableBalance = json['available_balance'] != null
        ? AvailableBalance.fromJson(json['available_balance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;

    if (withdrawHandlingFee != null) {
      data['withdraw_handling_fee'] = withdrawHandlingFee!.toJson();
    }
    if (availableBalance != null) {
      data['available_balance'] = availableBalance!.toJson();
    }
    return data;
  }
}

class WithdrawHandlingFee {
  int? id;
  num? handlingFee;
  String? createdAt;
  String? updatedAt;

  WithdrawHandlingFee(
      {this.id, this.handlingFee, this.createdAt, this.updatedAt});

  WithdrawHandlingFee.fromJson(Map<String, dynamic> json) {
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
