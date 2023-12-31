import 'package:tradexpro_flutter/data/models/report/withdraw_history.dart';

class WithdrawHistoryResponse {
  bool? status;
  String? message;
  List<WithdrawHistory>? data;

  WithdrawHistoryResponse({this.status, this.message, this.data});

  WithdrawHistoryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WithdrawHistory>[];
      json['data'].forEach((v) {
        data!.add(WithdrawHistory.fromJson(v));
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
