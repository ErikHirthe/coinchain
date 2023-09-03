import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/crptyo_wallet_response.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/ui/features/bottom_navigation/fiat/fiat_deposit/fiat_deposit_controller.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';

class CryptoDepositScreen extends StatefulWidget {
  const CryptoDepositScreen({super.key});

  @override
  State<CryptoDepositScreen> createState() => _CryptoDepositScreenState();
}

class _CryptoDepositScreenState extends State<CryptoDepositScreen> {
  final _controller = Get.find<FiatDepositController>();
  TextEditingController amountEditController = TextEditingController();
  TextEditingController addressEditController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  Rx<File> selectedFile = File("").obs;
  Rx<Wallet> selectedWallet = Wallet(id: 0).obs;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => _controller.getCryptoWallets());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Column(
            children: _controller.cryptoWalletResponse.value.data != null
                ? _controller.cryptoWalletResponse.value.data!
                    .map(
                      (e) => Card(
                        elevation: 5,
                        shadowColor: Colors.blue.withOpacity(.4),
                        child: ListTile(
                          leading: Image.network(e.qr ?? ''),
                          title: Text(
                            e.name ?? 'Crypto Name',
                            style: const TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            e.address ?? 'Crypto Address',
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 15),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: e.address!))
                                  .then((_) {
                                showToast("Copied address", isError: false);
                              });
                            },
                            icon: const Icon(Icons.copy),
                          ),
                          onTap: () => showAlert(context, e),
                        ),
                      ),
                    )
                    .toList()
                : [],
          ),
          vSpacer30(),
          twoTextSpace(
              "Amount & Select Coin you deposit".tr, "Select wallet".tr),
          vSpacer5(),
          textFieldWithWidget(
            controller: amountEditController,
            type: TextInputType.number,
            hint: "0",
            suffixWidget: Obx(
              () {
                return dropdownSuffix(
                    dropDownWallets(
                        _controller.fiatDepositData.value.walletList ?? [],
                        selectedWallet.value,
                        "Select".tr, onChange: (selected) {
                      selectedWallet.value = selected;
                      // _getAndSetCoinRate();
                    }),
                    width: 150,
                    mainAxisAlignment: MainAxisAlignment.end);
              },
            ),
          ),
          vSpacer20(),
          twoTextSpace("Enter remark".tr, ""),
          vSpacer5(),
          textFieldWithWidget(
            controller: remarkController,
            type: TextInputType.multiline,
            maxLines: 4,
            hint: "Enter remark".tr,
          ),
          vSpacer20(),
          _documentView(),
          vSpacer20(),
          buttonRoundedMain(
            text: "Deposit".tr,
            onPressCallback: () => _checkInputData(),
          )
        ],
      ),
    );
  }

  showAlert(BuildContext context, CryptoWallet cryptoWallet) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            cryptoWallet.name ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                cryptoWallet.qr ?? '',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              TextField(
                controller: TextEditingController(
                  text: cryptoWallet.address,
                ),
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      Clipboard.setData(
                              ClipboardData(text: cryptoWallet.address!))
                          .then((_) {
                        showToast("Copied address", isError: false);
                      });
                    },
                    icon: const Icon(
                      Icons.copy,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10)
            ],
          ),
        );
      },
    );
  }

  void _onTextChanged(String amount) {}

  Widget _documentView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            width: 150,
            child: buttonText("Select document".tr, onPressCallback: () {
              showImageChooser(context, (chooseFile, isGallery) {
                selectedFile.value = chooseFile;
              }, isCrop: false);
            })),
        Obx(() {
          final text = selectedFile.value.path.isEmpty
              ? "No document selected".tr
              : selectedFile.value.name;
          return Expanded(child: textAutoSizePoppins(text, maxLines: 2));
        })
      ],
    );
  }

  void _checkInputData() {
    final amount = makeDouble(amountEditController.text.trim());
    if (amount <= 0) {
      showToast("Amount_less_then".trParams({"amount": "0"}));
      return;
    }

    if (selectedFile.value.path.isEmpty) {
      showToast("select bank document".tr);
      return;
    }

    _controller.currencyDepositProcess(
        selectedWallet.value.id,
        amount,
        currency: "USD", //selectedWallet.value.coinType,
        //bankId: bank?.id,
        remark: remarkController.text,
        file: selectedFile.value,
        () => _clearView());
  }

  void _clearView() {
    amountEditController.text = "";
    selectedFile.value = File("");
  }
}
