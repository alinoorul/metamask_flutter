import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:get/get.dart';
import 'package:niku/niku.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      GetMaterialApp(title: 'Metamask Gift', home: Home());
}

extension StringE on String {
  NikuText get text => NikuText(this);
}

extension ListE on List<Widget> {
  NikuColumn get column => NikuColumn(this);
  NikuRow get row => NikuRow(this);
  NikuWrap get wrap => NikuWrap(this);
}

class HomeController extends GetxController {
  bool get isEnabled => ethereum != null;

  bool get isInOperatingChain => currentChain == OPERATING_CHAIN;

  bool get isConnected => isEnabled && currentAddress.isNotEmpty;

  String currentAddress = '';

  int currentChain = -1;

  static const OPERATING_CHAIN = 56;

  ContractERC20? ethToken;

  ContractERC20? maticToken;

  BigInt ethBalance = BigInt.zero;

  BigInt maticBalance = BigInt.zero;

  connect() async {
    if (isEnabled) {
      final accs = await ethereum!.requestAccount();
      if (accs.isNotEmpty) currentAddress = accs.first;

      currentChain = await ethereum!.getChainId();

      update();
    }
  }

  getEthBalance() async {
    ethBalance = await provider!.getSigner().getBalance();
    update();
  }

  // getMatBalance() async {
  //   if (maticToken == null) {
  //     maticToken = ContractERC20(MATIC_ADDRESS, provider!.getSigner());
  //   }
  //   maticBalance = await maticToken!.balanceOf(currentAddress);
  //   update();
  // }

  clear() {
    currentAddress = '';
    currentChain = -1;
    update();
  }

  init() {
    if (isEnabled) {
      ethereum!.onAccountsChanged((accs) {
        clear();
      });

      ethereum!.onChainChanged((chain) {
        clear();
      });
    }
  }

  @override
  void onInit() {
    init();

    super.onInit();
  }

  static const CAKE_ADDRESS = '0x0e09fabb73bd3ade0a17ecc321fd13a19e81ce82';

  static const DEAD_ADDRESS = '0x000000000000000000000000000000000000dead';
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (h) => Scaffold(
        backgroundColor: const Color(0xff1c1143),
        body: Column(
          children: [
            Expanded(
                child: Column(
              children: [
                Container(
                    margin: EdgeInsets.all(10.0),
                    child: Container(
                      child: Image.asset('assets/Frame 1.png'),
                    )),
                Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      "Kart Racing League",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.9,
                      ),
                    )),
                Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      "BLIND MINT EVENT",
                      style: TextStyle(
                          color: Colors.amber[400],
                          fontSize: 40.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                          wordSpacing: 4.0,
                          fontStyle: FontStyle.italic),
                    )),
              ],
            )),
            SizedBox(
              height: 100,
            ),
            Expanded(
                child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(5.0),
                  child: Image.asset(
                    'assets/Frame 2.png',
                    width: 75.0,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Frame 1.png',
                      width: 25,
                      height: 25,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "35000",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18.0),
                      ),
                    )
                  ],
                )
              ],
            )),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.all(10),
                    child: TextButton.icon(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 40)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.amber[400])),
                        onPressed: null,
                        icon: Icon(
                          Icons.note,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        label: Text(
                          "Approve",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18.0),
                        ))),
                Builder(builder: (_) {
                  var shown = '';
                  if (h.isConnected)
                    return Container(
                        margin: EdgeInsets.all(10),
                        child: TextButton.icon(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 25)),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.amber[400])),
                            onPressed: null,
                            icon: Icon(
                              Icons.note,
                              size: 20.0,
                              color: Colors.black,
                            ),
                            label: Text(
                              "Connected",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18.0),
                            )));
                  else if (h.isEnabled)
                    return Container(
                        margin: EdgeInsets.all(10),
                        child: TextButton.icon(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 15)),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.amber[400])),
                            onPressed: () async {
                              print(await h.getEthBalance());
                              h.connect;
                            },
                            icon: Icon(
                              Icons.note,
                              size: 20.0,
                              color: Colors.black,
                            ),
                            label: Text(
                              "CONNECT WALLET",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 15.0),
                            )));
                  else
                    return NikuButton.outlined(
                      'Unsupported browser'.text.bold().fontSize(20),
                    ).onPressed(h.connect);
                }),
              ],
            )),
            Niku().height(30),
          ],
        ),
      ),
    );
  }
}
