import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/mining_options.dart';
import 'package:tradexpro_flutter/data/models/user_mining_websocket.dart';
import 'package:tradexpro_flutter/data/remote/api_repository.dart';
import 'package:tradexpro_flutter/ui/features/lockup_mining/lockup_order_screen.dart';
import '../../../utils/common_utils.dart';

class LockupController extends GetxController {
  RxBool isDataLoading = false.obs;
  Rx<MiningOptionResponse> miningOptionsResponse = MiningOptionResponse().obs;
  Rx<UserMiningWebsocketResponse> miningHistoryResponse =
      UserMiningWebsocketResponse().obs;
  void getMiningOption() {
    isDataLoading.value = true;
    APIRepository().getMiningOptions().then((response) {
      if (response.success) {
        isDataLoading.value = false;
        debugPrint("Mining Options ==> ${response.data}");
        miningOptionsResponse.value =
            MiningOptionResponse.fromJson(response.data);
      }
    }, onError: (err) => showToast(err.toString()));
  }

  void userDoMining(
      {required int miningOptionID,
      required num investmentAmount,
      required String period,
      required num dailyReturnPercent}) {
    isDataLoading.value = true;
    APIRepository()
        .userDoMining(
            miningOptionID: miningOptionID,
            investmentAmount: investmentAmount,
            period: period,
            dailyReturnPercent: dailyReturnPercent)
        .then((response) {
      isDataLoading.value = false;
      if (response.success) {}
    });
  }

  void userCancelMining({required String uuid}) {
    isDataLoading.value = true;
    APIRepository().userCancelMining(uuid: uuid).then((response) {
      isDataLoading.value = false;
      if (response.success) {
        Get.to(() => const LockupMiningOrderScreen());
      }
    });
  }

  void userMiningHistory() {
    isDataLoading.value = true;
    APIRepository().getUserMiningHistory().then((response) {
      isDataLoading.value = false;
      if (response.success) {
        debugPrint("Mining History ==> ${response.data}");
        miningHistoryResponse.value =
            UserMiningWebsocketResponse.fromJson(response.data);
        // debugPrint(
        //     "Mining History 1 ==> ${miningHistoryResponse.value.data!.length}");
      }
    }, onError: (err) => showToast(err.toString()));
  }
}
