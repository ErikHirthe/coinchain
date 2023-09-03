import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/user.dart';
import 'package:tradexpro_flutter/data/models/user_mining_websocket.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/helper/main_bg_view.dart';
import 'package:tradexpro_flutter/ui/features/lockup_mining/lockup_controller.dart';
import 'package:tradexpro_flutter/utils/appbar_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LockupMiningOrderScreen extends StatefulWidget {
  const LockupMiningOrderScreen({super.key});

  @override
  State<LockupMiningOrderScreen> createState() =>
      _LockupMiningOrderScreenState();
}

class _LockupMiningOrderScreenState extends State<LockupMiningOrderScreen> {
  final WebSocketChannel _socketChannel = WebSocketChannel.connect(
    Uri.parse("ws://staging.coins-chain.com:8090"),
  );
  //User user = gUserRx.value;
  //final _controller = Get.put(LockupController());
  final _controller = Get.find<LockupController>();

  @override
  void initState() {
    sendSubscribe();
    super.initState();
  }

  @override
  void dispose() {
    sendUnsubscribe();
    super.dispose();
  }

  sendSubscribe() {
    _socketChannel.sink.add(jsonEncode({
      "command": "miningHistory",
      "user_id": gUserRx.value.id,
    }));
  }

  sendUnsubscribe() {
    _socketChannel.sink.add(jsonEncode({"command": "unsubscribe"}));
    _socketChannel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BGViewMain(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: Dimens.paddingMainViewTop),
              child: Obx(
                () {
                  return gUserRx.value.id == 0
                      ? Column(children: [
                          appBarBackWithActions(
                              title: "Lock-up Mining Orders".tr),
                          signInNeedView()
                        ])
                      : Column(
                          children: [
                            appBarBackWithActions(
                              title: "Lock-up Mining Orders".tr,
                            ),
                            // _controller.isDataLoading.value == true
                            //     ? const Center(
                            //         child: CircularProgressIndicator(),
                            //       )
                            //     : Column(
                            //         children: _controller
                            //             .miningHistoryResponse.value!.data!
                            //             .map((e) => _buildLockUpMiningItem(e))
                            //             .toList(),
                            //       ),
                            // Obx(
                            //   () => _controller.isDataLoading.value
                            //       ? const Center(
                            //           child: CircularProgressIndicator(),
                            //         )
                            //       : Column(
                            //           children: _controller
                            //               .miningHistoryResponse.value!.data!
                            //               .map((e) => _buildLockUpMiningItem(e))
                            //               .toList(),
                            //         ),
                            // )
                            StreamBuilder(
                              stream: _socketChannel.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final response =
                                      UserMiningWebsocketResponse.fromJson(
                                    jsonDecode(
                                      snapshot.data.toString(),
                                    ),
                                  );
                                  debugPrint(response.data!.length.toString());
                                  return Column(
                                    children: response.data!
                                        .map((e) => _buildLockUpMiningItem(
                                              context,
                                              e,
                                              _controller,
                                            ))
                                        .toList(),
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            )
                          ],
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildLockUpMiningItem(BuildContext context, UserMiningWebSocket data,
    LockupController controller) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
    child: Material(
      color: Colors.white,
      elevation: 5,
      shadowColor: Colors.grey.shade50,
      child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${data.miningOption!.name}",
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    const SizedBox(height: 5),
                    DecoratedBox(
                      decoration: BoxDecoration(
                          color: data.status == 'Processing'
                              ? Colors.orange.withOpacity(.2)
                              : data.status == 'Cancel'
                                  ? Colors.red.withOpacity(.2)
                                  : Colors.green.withOpacity(.2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 3, bottom: 3),
                        child: Text(
                          "${data.status}",
                          style: TextStyle(
                              color: data.status == 'Processing'
                                  ? Colors.orange
                                  : data.status == 'Cancel'
                                      ? Colors.red
                                      : Colors.green),
                        ),
                      ),
                    ),
                  ],
                ),
                data.status == 'Processing'
                    ? TextButton(
                        onPressed: () {
                          showAlertDialog(context, controller, data.uuid!);
                        },
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor: Colors.red.withOpacity(.2)),
                        child: const Icon(
                          BootstrapIcons.x,
                          color: Colors.red,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "single limit",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "${data.miningOption!.singleLimitMin}~${data.miningOption!.singleLimitMax}",
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "daily rate of return",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "${data.miningOption!.dailyRateOfReturnMin}~${data.miningOption!.dailyRateOfReturnMax}%",
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "period",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "${data.miningOption!.period}(Day)",
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ],
                )
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "start date",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "${data.startTime}",
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "end date",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "${data.endTime}",
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "advance\nredeem falsify",
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${data.miningOption!.defaultSettlementRatio}%",
                      style: const TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ],
                )
              ],
            ),
          ])),
    ),
  );
}

showAlertDialog(
    BuildContext context, LockupController controller, String uuid) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Get.back();
    },
  );
  Widget continueButton = TextButton(
    child: const Text(
      "Confirm",
      style: TextStyle(fontWeight: FontWeight.w100),
    ),
    onPressed: () {
      controller.userCancelMining(uuid: uuid);

      Get.back();
    },
  ); // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text(
      "Confirm",
      style: TextStyle(color: Colors.black),
    ),
    content: const Text(
      "Are you sure to cancel mining?",
      style: TextStyle(color: Colors.black),
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  ); // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
