
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
    lang: const String.fromEnvironment('order', defaultValue: 'en-US'),
    httpClientFactory: kIsWeb ? () => getClient() : null,
  );

  final String collectionName = 'location';

  List<Location> allOrders = []; // جایگزین RxList با لیست معمولی

  late bool isLoading; // استفاده از bool معمولی برای بارگذاری
  void insializ() async {
    isLoading = true;
    update(['hi']);
   // await fetchAllOrders();
    await fetchAllProducts();
    await fetchSelectedGarrantyItems();
    isLoading = false;
    update(['hi']);
  }

  late Timer _timer; // تایمر برای به روز رسانی هر 10 ثانیه

  @override
  void onInit() {
    super.onInit();
    insializ();
    startAutoRefresh(); // شروع به به روز رسانی خودکار در زمان شروع
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel(); // لغو تایمر در زمان بستن کنترلر
  }

  void startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 20), (timer) {
      print('start' + DateTime.now().toString());
     // _fetchAndUpdate(); // صدا زدن متد fetchAllOrders هر 10 ثانیه
    });
  }


  String currentFilter = '';
  String currentSearch = '';
  String currentSort = '';
  String currentPrivate = '';

  Future<List<Location>> _fetchOrders() async {
    // String filterQuery = 'type = "18zn54v3u6vfaqd"';

    String filterQuery = '';
    if (currentPrivate.isNotEmpty) {
      filterQuery += 'type = "$currentPrivate"';
    }
    if (currentSearch.isNotEmpty) {
      filterQuery +=
          (filterQuery.isNotEmpty ? ' && ' : '') + 'title ~ "$currentSearch"';
    }
    if (currentFilter.isNotEmpty) {
      filterQuery += (filterQuery.isNotEmpty ? ' && ' : '') + currentFilter;
    }

    int page = 1;
    List<Location> orders = [];

    try {
      while (true) {
        final resultList = await _pb.collection(collectionName).getList(
          page: page,
          perPage: 50,
          filter: filterQuery.isNotEmpty ? filterQuery : null,
          sort: currentSort.isNotEmpty ? currentSort : null,
          expand: 'listproducta,listproductb',
        );

        if (resultList.items.isEmpty) {
          break;
        }

        for (var orderJson in resultList.items) {
          Map<String, dynamic> orderData = orderJson.toJson();
          List<ProductA> listProductA =
              (orderData['expand']?['listproducta'] as List<dynamic>?)
                  ?.map((product) =>
                  ProductA.fromJson(Map<String, dynamic>.from(product)))
                  .toList() ??
                  [];
          List<ProductB> listProductB =
              (orderData['expand']?['listproductb'] as List<dynamic>?)
                  ?.map((product) =>
                  ProductB.fromJson(Map<String, dynamic>.from(product)))
                  .toList() ??
                  [];
          Location order = Location.fromJson(
              Map<String, dynamic>.from(orderData), listProductA, listProductB);
          orders.add(order);
        }

        page++;
      }
    } catch (error) {
      print('Error fetching orders: $error');
    }

    return orders;
  }


  //////////////
  List<Product> selectedProductItems = [];

  Future<List<Product>> fetchAllProducts() async {
    List<Product> allProducts = [];
    int page = 1;
    int perPage = 50; // تعداد محصولات در هر صفحه

    while (true) {
      final resultList = await _pb.collection('product').getList(
        page: page,
        perPage: perPage,
      );

      List<Product> pageItems = resultList.items
          .map((item) => Product.fromJson(item.toJson()))
          .toList();
      if (pageItems.isEmpty) {
        break; // اگر صفحه خالی باشد، خارج می‌شویم
      }
      selectedProductItems.addAll(pageItems);
      page++;
    }
    print('object');
    update(['product']);
    return allProducts;
  }

  /////////////
  List<Garranty> selectedGarrantyItems = [];

  Future<void> fetchSelectedGarrantyItems() async {
    try {
      final resultList = await _pb.collection('garrantya').getList();
      print('dddd' + resultList.items.toString());
      List<Garranty> garrantyItems = [];
      print(garrantyItems.length);
      for (var item in resultList.items) {
        final data = item.toJson();
        if (data.containsKey('Garrantyname')) {
          print(item.collectionName.toString());
          garrantyItems.add(Garranty.fromJson(data));
        }
      }
      selectedGarrantyItems = garrantyItems;
      update(['garrantya']);
    } catch (error) {
      print('Error fetching selected garranty items: $error');
    }
  }


  Future<void> updateLocation(Location location) async {
    try {
      final body = <String, dynamic>{
        "latitude": location.latitude,
        "longitude": location.longitude,
      };

      final record =
      await _pb.collection(collectionName).update(location.id, body: body);
      if (record != null) {
      //  _fetchAndUpdate();

        // Get.snackbar(
        //     'اطلاعات سفارش برنده' ,  ' با موفقیت وارد شد',backgroundColor: Colors.green,);
        Get.snackbar(
          'اطلاعات سفارش برنده',
          'با موفقیت وارد شد',
          backgroundColor: Colors.green,
          messageText: Text(
            'با موفقیت وارد شد',
            textDirection: TextDirection.rtl,
          ),
          titleText: Text(
            'اطلاعات سفارش برنده',
            textDirection: TextDirection.rtl,
          ),
        );


        // add(FetchOrders());
        // emit(OrderSuccess('Order updated successfully'));
      } else {
        // emit(OrderError('Failed to update order.'));
        Get.snackbar(
          'اطلاعات سفارش برنده',
          'با خطا مواجه شد',
          backgroundColor: Colors.red,
          messageText: Text(
            'با خطا مواجه شد',
            textDirection: TextDirection.rtl,
          ),
          titleText: Text(
            'اطلاعات سفارش برنده',
            textDirection: TextDirection.rtl,
          ),
        );

      }
    } catch (e) {
      // emit(OrderError(e.toString()));
      Get.snackbar(
        'اطلاعات سفارش برنده',
        'با خطا مواجه شد',
        backgroundColor: Colors.red,
        messageText: Text(
          'با خطا مواجه شد',
          textDirection: TextDirection.rtl,
        ),
        titleText: Text(
          'اطلاعات سفارش برنده',
          textDirection: TextDirection.rtl,
        ),
      );

    }
  }


}

/////////////////////////////////////////////////
class ProductA {
  final String id;
  final String title;
  final List<String> garranty;
  late final String saleprice;
  final String number;
  final String purchaseprice;
  final String description;
  late final bool unavailable;
  late final String percent;

  ProductA({
    required this.id,
    required this.title,
    required this.garranty,
    required this.saleprice,
    required this.number,
    required this.purchaseprice,
    required this.description,
    required this.unavailable,
    required this.percent,
  });

  factory ProductA.fromJson(Map<String, dynamic> json) {
    return ProductA(
      id: json['id'] as String,
      title: json['title'] as String,
      garranty:
      (json['garranty'] as List<dynamic>).map((e) => e as String).toList(),
      saleprice: json['saleprice'] as String,
      // تبدیل مقدار به String
      number: json['number'] as String,
      purchaseprice: json['purchaseprice'] as String,
      description: json['description'] as String,

      unavailable: json['unavailable'],
      percent: json['percent'] as String,
    );
  }
}

//0
// class Order {
//   final String id;
//   final String title;
//   final String callnumber;
//   final List<ProductA> listProductA;
//   final List<ProductB> listProductB;
//   final String datenow;
//   final String datead;
//   final String address;
//   final String niyaz;
//   final String phonenumberit;
//   final String buy;
//   final String winner;
//   final String created;
//
//   Order({
//     required this.id,
//     required this.title,
//     required this.callnumber,
//     required this.listProductA,
//     required this.listProductB,
//     required this.datenow,
//     required this.datead,
//     required this.address,
//     required this.niyaz,
//     required this.phonenumberit,
//     required this.buy,
//     required this.winner,
//     required this.created,
//   });
//
//   factory Order.fromJson(Map<String, dynamic> json, List<ProductA> productsA,
//       List<ProductB> productsB) {
//     return Order(
//       id: json['id'].toString(),
//       title: json['title'].toString(),
//       callnumber: json['callnumber'].toString(),
//       listProductA: productsA,
//       listProductB: productsB,
//       phonenumberit: json['phonenumberit'].toString(),
//       datenow: json['datenow'].toString(),
//       datead: json['datead'].toString(),
//       address: json['address'].toString(),
//       niyaz: json['niyaz'].toString(),
//       buy: json['buy'].toString(),
//       winner: json['winner'].toString(),
//       created: json['created'].toString(),
//     );
//   }
// }
//1
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

  factory Location.fromJson(Map<String, dynamic> json, List<ProductA> productsA,
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

class Garranty {
  final String garranty;

  Garranty({required this.garranty});

  factory Garranty.fromJson(Map<String, dynamic> json) {
    return Garranty(garranty: json['Garrantyname'].toString());
  }
}

class Product {
  final String nameproduct;

  Product({required this.nameproduct});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(nameproduct: json['nameproduct'].toString());
  }
}
