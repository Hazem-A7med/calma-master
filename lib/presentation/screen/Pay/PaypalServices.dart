import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http_auth/http_auth.dart';

class PaypalServices {
  String domain = "api.sandbox.paypal.com"; // for sandbox mode
//  String domain = "https://api.paypal.com"; // for production mode

  // change clientId and secret with your own, provided by paypal
  String clientId =
      'AX8vLFI0q90hc8H85SZ5vu3Gdfop-HZnDdVDAyjrYPep3WXfMBm3HK6nFQFW665wzzKD4VSnFuCrfDfl';
  String secret =
      'EB3nyN8nOtC68VyKc2bct4kXFdLKhwK4tIhzQxS6n62RvYpF1B5yZh-INOS39WZT0lEAUyAdq-7zf2QF';

  // for getting the access token from Paypal
  Future<String?> getAccessToken() async {
    try {
      var client = BasicAuthClient(clientId, secret);
      var response = await client.post(Uri.https(domain, '/v1/oauth2/token'),
          headers: {'Accept': 'application/json', 'Accept-Language': 'en_US'},
          body: {'grant_type': 'client_credentials'});
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        print('ggggggg  ${body["access_token"]}');
        return body["access_token"];
      } else {
        print('ggggggg  ${response.statusCode}');
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  // for creating the payment request with Paypal
  Future<Map<String, String>?> createPaypalPayment(
      transactions, accessToken) async {
    try {
      var response = await http.post(Uri.https(domain, "/v1/payments/payment"),
          body: convert.jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }

        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  // for executing the payment transaction
  Future<String?> executePayment(url, payerId, accessToken) async {
    try {
      var response = await http.post(url,
          body: convert.jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return body["id"];
      }
      return null;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  static void payout({
    required BuildContext context,
    required String price,
    required List<Map> items,
    required VoidCallback onSuccess,
    required VoidCallback onError,
    Map<String, dynamic>? shippingAddress,
  }) async {
    bool result = false;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
            sandboxMode: true,
            clientId:
                "AW9Kf4GxFAks5Vknry2SaJdVrZCmt-hajEqATPJdPMMcRbBvgzAibcZJT1O2SWOT4H_iKX5v7vBsKhsC",
            secretKey:
                "ECv13gxLDtNARq-O708_4kf41B9YqNYwUkjH_QvfyAxLyMb8y_xqM9FRpMTrIbDg1rr5-CfnMIMkqGkO",
            returnURL: "https://example.com/return",
            cancelURL: "https://example.com/cancel",
            transactions: [
              {
                "amount": {
                  "total": price,
                  "currency": "USD",
                  "details": {
                    "subtotal": price,
                    "shipping": '0',
                    "shipping_discount": 0
                  }
                },
                "description": "The payment transaction description.",
                "item_list": {
                  "items": items,
                  "shipping_address": shippingAddress ??
                      {
                        "recipient_name": "NA",
                        "line1": "NA",
                        "line2": "",
                        "city": "NA",
                        "country_code": "NA",
                        "postal_code": "NA",
                        // "phone": "NA",
                        "state": "NA"
                      },
                }
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) {
              onSuccess();
            },
            onError: (error) {
              onError();
            },
            onCancel: (params) {
              onError();
            }),
      ),
    );
  }
}
