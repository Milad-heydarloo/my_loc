
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

import 'package:http/http.dart';

import 'package:get/get.dart';

Client getClient() {
  return Client();
}

class OrderController extends GetxController {
  final PocketBase _pb = PocketBase(
    const String.fromEnvironment('order',
        defaultValue: 'https://saater.liara.run'),
    lang: const String.fromEnvironment('listproductb', defaultValue: 'en-US'),
    httpClientFactory: kIsWeb ? () => getClient() : null,
  );

  final String collectionName = 'location';


  Future<void> updateLocation(Location location) async {
    try {
      final body = <String, dynamic>{
        "latitude": location.latitude,
        "longitude": location.longitude,
      };

      final record =
      await _pb.collection(collectionName).update(location.id, body: body);
      if (record != null) {

        // Get.snackbar(
        //   'اطلاعات سفارش برنده',
        //   'با موفقیت وارد شد',
        //   backgroundColor: Colors.green,
        //   messageText: Text(
        //     'با موفقیت وارد شد',
        //     textDirection: TextDirection.rtl,
        //   ),
        //   titleText: Text(
        //     'اطلاعات سفارش برنده',
        //     textDirection: TextDirection.rtl,
        //   ),
        // );


        // add(FetchOrders());
        // emit(OrderSuccess('Order updated successfully'));
      } else {
        // emit(OrderError('Failed to update order.'));
        // Get.snackbar(
        //   'اطلاعات سفارش برنده',
        //   'با خطا مواجه شد',
        //   backgroundColor: Colors.red,
        //   messageText: Text(
        //     'با خطا مواجه شد',
        //     textDirection: TextDirection.rtl,
        //   ),
        //   titleText: Text(
        //     'اطلاعات سفارش برنده',
        //     textDirection: TextDirection.rtl,
        //   ),
        // );

      }
    } catch (e) {
      // emit(OrderError(e.toString()));
      Get.snackbar(
        'لطفا اینترنت',
        'تلفن همراه خود را چک کنید',
        backgroundColor: Colors.red,
        messageText: Text(
         'تلفن همراه خود را چک کنید',
          textDirection: TextDirection.rtl,
        ),
        titleText: Text(
     'لطفا اینترنت',
          textDirection: TextDirection.rtl,
        ),
      );

    }
  }


}

/////////////////////////////////////////////////

class Location {
  final String id;
  final String user;
  final String latitude;
  final String longitude;

  Location({
    required this.id,
    required this.user,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json, List<Location> productsA,
      List<ProductB> productsB) {
    return Location(
      id: json['id'].toString(),
      user: json['user'].toString(),
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
    );
  }
}

class ProductB {
  final String id;
  final String title;
  final String purchaseprice;
  final String supplier;
  final String days;
  final String datecreated;
  final String dataclearing;
  final String number;
  final String description;
  final String datead;
  final bool okbuy;
  final bool hurry;
  final bool official;

  ProductB(
      {required this.title,
        required this.purchaseprice,
        required this.id,
        required this.supplier,
        required this.days,
        required this.datecreated,
        required this.dataclearing,
        required this.number,
        required this.description,
        required this.datead,
        required this.okbuy,
        required this.hurry,
        required this.official});

  factory ProductB.fromJson(Map<String, dynamic> json) {
    return ProductB(
      title: json['title'].toString(),
      purchaseprice: json['purchaseprice'].toString(),
      id: json['id'].toString(),
      supplier: json['supplier'].toString(),
      days: json['days'].toString(),
      datecreated: json['datecreated'].toString(),
      dataclearing: json['dataclearing'].toString(),
      number: json['number'].toString(),
      description: json['description'].toString(),
      datead: json['datead'].toString(),
      okbuy: json['okbuy'],
      hurry: json['hurry'],
      official: json['official'],
    );
  }
}

