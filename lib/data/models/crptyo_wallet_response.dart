class CryptoWalletResponse {
  bool? status;
  String? message;
  List<CryptoWallet>? data;

  CryptoWalletResponse({this.status, this.message, this.data});

  CryptoWalletResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CryptoWallet>[];
      json['data'].forEach((v) {
        data!.add(CryptoWallet.fromJson(v));
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

class CryptoWallet {
  int? id;
  String? name;
  String? address;
  String? qr;
  String? status;
  String? createdAt;
  String? updatedAt;

  CryptoWallet(
      {this.id,
      this.name,
      this.address,
      this.qr,
      this.status,
      this.createdAt,
      this.updatedAt});

  CryptoWallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    qr = json['qr'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['qr'] = qr;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
