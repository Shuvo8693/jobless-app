import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:get/get.dart';
import 'package:jobless/revenue_const.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatController extends GetxController {

  final RxList<Package> packages = <Package>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isSubscribed = false.obs;


  /// Initialize RevenueCat
  Future<void> initRevenueCat() async {
    try {
      await Purchases.setLogLevel(LogLevel.debug); // Enable debug logs for testing
      PurchasesConfiguration? configuration;
      if (Platform.isIOS) {
        configuration = PurchasesConfiguration("appl_fQwaEjNmQQFTRfBmSTgiGBklyxV")
          ..appUserID = null
          ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
        print(configuration);
      } else {
        // Add Android configuration if needed
        configuration = PurchasesConfiguration(''); // Placeholder for Android
      }
      await Purchases.configure(configuration);
      await checkSubscriptionStatus();
    } catch (e) {
      debugPrint('Error initializing RevenueCat: $e');
    }
  }

  /// Fetch available subscription packages
  Future<void> fetchOfferings() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final offerings = await Purchases.getOfferings();
      Offering? current = offerings.current;
      if (current != null && current.availablePackages.isNotEmpty) {
        packages.assignAll(current.availablePackages);
      } else {
        errorMessage.value = 'No subscription packages available';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching offerings: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Check if user has active subscription
  Future<void> checkSubscriptionStatus() async {
    try {
      final purchaserInfo = await Purchases.getCustomerInfo();
      print(purchaserInfo);
      RevenueCatConstants.entitlementId;
      isSubscribed.value = purchaserInfo.entitlements.all["premium"]?.isActive ?? false;
    } catch (e) {
      debugPrint('Error checking subscription status: $e');
    }
  }

  /// Handle purchase
  Future<void> purchasePackage(Package package) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final purchaserInfo = await Purchases.purchasePackage(package);
      RevenueCatConstants.entitlementId;
      final subscribed = purchaserInfo.entitlements.all[RevenueCatConstants.entitlementId]?.isActive ?? false;

      isSubscribed.value = subscribed;

      if (subscribed) {
        Get.snackbar('Success', 'Purchase successful! Premium access unlocked.',
            snackPosition: SnackPosition.TOP);
      }
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        errorMessage.value = 'Purchase error: ${e.message}';
      }
    } finally {
      isLoading.value = false;
    }
  }
}