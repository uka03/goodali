class Qpay {
  String? invoiceID;
  String? qPayShortUrls;
  String? qrImage;
  String? qrText;
  List<QpayURLS>? urls;

  Qpay(
      {this.invoiceID,
      this.qPayShortUrls,
      this.qrImage,
      this.qrText,
      this.urls});

  factory Qpay.fromJson(Map<String, dynamic> json) {
    return Qpay(
        invoiceID: json['invoice_id'],
        qPayShortUrls: json['qPay_shortUrl'],
        qrImage: json['qr_image'],
        qrText: json['qr_text'],
        urls: json['urls']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['invoice_id'] = invoiceID;
    data['qPay_shortUrl'] = qPayShortUrls;
    data['qr_image'] = qrImage;
    data['qr_text'] = qrText;
    data['urls'] = urls;

    return data;
  }
}

class QpayURLS {
  String? description;
  String? name;
  String? logo;
  String? link;

  QpayURLS({this.description, this.name, this.logo, this.link});

  factory QpayURLS.fromJson(Map<String, dynamic> json) {
    return QpayURLS(
        description: json['description'],
        name: json['name'],
        logo: json['logo'],
        link: json['link']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["description"] = description;
    data["name"] = name;
    data["logo"] = logo;
    data["link"] = link;

    return data;
  }
}
