class UserShortDataModel {
    String? name;
    String? countryCode;
    String? phone;
    String? qrCode;

    UserShortDataModel({this.name, this.countryCode, this.phone, this.qrCode});

    UserShortDataModel.fromJson(Map<String, dynamic> json) {
        name = json['name'];
        countryCode = json['country_code'];
        phone = json['phone'];
        qrCode = json['qr_code'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, String?> data = <String, String?>{};
        data['name'] = name;
        data['country_code'] = countryCode;
        data['phone'] = phone;
        data['qr_code'] = qrCode;
        return data;
    }
}
