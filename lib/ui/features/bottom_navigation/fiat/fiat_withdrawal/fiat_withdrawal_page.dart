import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/models/wallet.dart';
import 'package:tradexpro_flutter/helper/app_widgets.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/dimens.dart';
import 'package:tradexpro_flutter/utils/extentions.dart';
import 'package:tradexpro_flutter/utils/number_util.dart';
import 'package:tradexpro_flutter/utils/spacers.dart';
import 'package:tradexpro_flutter/utils/text_field_util.dart';
import 'fiat_withdrawal_controller.dart';
import 'package:flutter/services.dart';

class FiatWithdrawalPage extends StatefulWidget {
  const FiatWithdrawalPage({Key? key}) : super(key: key);

  @override
  FiatWithdrawalPageState createState() => FiatWithdrawalPageState();
}

class FiatWithdrawalPageState extends State<FiatWithdrawalPage> {
  final _controller = Get.put(FiatWithdrawalController());
  bool showPassword = false;
  String selectedCoinType = '';

  @override
  void initState() {
    _controller.selectedBankIndex.value = -1;
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => _controller.getFiatWithdrawal());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.paddingMid),
          child: Column(
            children: [
              Obx(
                () => dropDownWallet(
                  _controller.fiatWithdrawalResp.value.myWallet ?? [],
                  _controller.selectedWallet.value,
                  onChange: (selected) {
                    //_controller.selectedWallet.value = selected;
                    debugPrint("Select Wallet ==> ${selected}");
                    selectedCoinType = selected;
                    WidgetsBinding.instance.addPostFrameCallback(
                      (timeStamp) => _controller.getWithdrawRequirement(
                        coinType: selected,
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: RadioListTile(
                    title: const Text(
                      "ERC20",
                      style: TextStyle(color: Colors.black),
                    ),
                    value: "ERC20",
                    groupValue: _controller.withDrawalType,
                    onChanged: (value) {
                      setState(() {
                        _controller.withDrawalType = value!;
                      });
                    },
                  )),
                  Expanded(
                      child: RadioListTile(
                    title: const Text(
                      "TRC20",
                      style: TextStyle(color: Colors.black),
                    ),
                    value: "TRC20",
                    groupValue: _controller.withDrawalType,
                    onChanged: (value) {
                      setState(() {
                        _controller.withDrawalType = value!;
                      });
                    },
                  ))
                ],
              ),
              vSpacer20(),
              twoTextSpace("Withdrawal address".tr, "",
                  color: context.theme.primaryColor),
              vSpacer5(),
              textFieldWithWidget(
                controller: _controller.addressEditController,
                hint: "Enter withdrawal address".tr,
                onTextChange: _controller.onTextChanged,
                type: TextInputType.text,
                suffixWidget: IconButton(
                  onPressed: () {
                    Clipboard.getData(Clipboard.kTextPlain).then((value) {
                      _controller.addressEditController.text =
                          value!.text!; //value is clipbarod data
                    });
                  },
                  icon: const Icon(Icons.paste),
                ),
              ),
              vSpacer20(),
              twoTextSpace("Amount of withdrawals".tr, "",
                  color: context.theme.primaryColor),
              vSpacer5(),
              textFieldWithWidget(
                controller: _controller.amountEditController,
                hint: "Enter withdrawal amount",
                type: TextInputType.number,
              ),
              vSpacer5(),
              Obx(() {
                final balance =
                    "${"Available".tr}: ${currencyFormat(double.parse(_controller.withdrawRequirementResponse.value.availableBalance?.balance ?? '00'))}";
                final handlingFee =
                    "${"Handling fee".tr}: ${_controller.withdrawRequirementResponse.value.withdrawHandlingFee?.handlingFee ?? 0}";
                return twoTextSpaceFixed(balance, handlingFee,
                    color: context.theme.primaryColor);
              }),
              vSpacer30(),
              twoTextSpace("Login password for security reason".tr, "",
                  color: context.theme.primaryColor),
              vSpacer5(),
              textFieldWithWidget(
                  isObscure: showPassword,
                  controller: _controller.passwordEditController,
                  hint: "Enter password",
                  suffixWidget: IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      icon: Icon(showPassword
                          ? BootstrapIcons.eye_slash
                          : BootstrapIcons.eye))),
              vSpacer30(),
              buttonRoundedMain(
                  text: "Submit Withdrawal".tr,
                  onPressCallback: () {
                    setState(() {
                      return _controller.checkInputData(
                        context,
                        _controller.withdrawRequirementResponse.value
                            .availableBalance!.balance!,
                        _controller.withdrawRequirementResponse.value
                            .withdrawHandlingFee!.handlingFee
                            .toString(),
                        selectedCoinType,
                      );
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}

Widget dropDownWallet(List<Wallet> items, Wallet selectedValue,
    {Function(String value)? onChange}) {
  return DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      border: Border.all(color: Colors.black38, width: 0),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: DropdownButton(
        hint: Text("Select Wallet", style: Get.textTheme.bodyMedium),
        value: selectedValue.coinType.isValid ? selectedValue : null,
        items: items.map<DropdownMenuItem<Wallet>>((Wallet value) {
          return DropdownMenuItem<Wallet>(
            value: value,
            child: Row(
              children: [
                Text(value.coinType ?? "",
                    style: Get.textTheme.bodyMedium!.copyWith())
              ],
            ),
          );
        }).toList(),
        onChanged: (value) => onChange!(value!.coinType!),
        icon: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(Icons.arrow_drop_down),
        ),
        iconEnabledColor: Colors.black, //Icon color
        style: const TextStyle(color: Colors.black, fontSize: 20),

        dropdownColor: Colors.grey,
        underline: Container(),
        isExpanded: true,
      ),
    ),
  );
}
