import 'package:mathy/screens/authentication/login_view.dart';
import 'package:mathy/screens/authentication/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:admob_flutter/admob_flutter.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AdmobInterstitial _interStitial = AdmobInterstitial(
    adUnitId: "ca-app-pub-4056821571384483/5138202186", //real ad
    // adUnitId: "ca-app-pub-3940256099942544/1033173712", //test ad
  );
  ScrollController _c;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _c = PageController();
    _interStitial.load();
  }

  @override
  void dispose() {
    _interStitial.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
                color: Color(0xfff6f5f5),
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    return ListView(
                      children: <Widget>[
                        Container(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                            maxHeight: 700.0,
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 150.0,
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                        top: -100.0,
                                        left: -70.0,
                                        child: SvgPicture.asset(
                                            "images/auth_1.svg")),
                                    Positioned(
                                        right: -40.0,
                                        top: -20.0,
                                        child: SvgPicture.asset(
                                            "images/auth_4.svg")),
                                    Positioned(
                                        top: 30.0,
                                        right: 40.0,
                                        child: SvgPicture.asset(
                                            "images/auth_3.svg")),
                                    Positioned.fill(
                                        top: -200.0,
                                        child: Center(
                                            child: SvgPicture.asset(
                                                "images/auth_2.svg"))),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: PageView(
                                  physics: NeverScrollableScrollPhysics(),
                                  controller: _c,
                                  children: <Widget>[
                                    LoginView(_c, _scaffoldKey, () async {
                                      if (await _interStitial.isLoaded) {
                                        _interStitial.show();
                                      }
                                    }),
                                    SignUpView(_c, _scaffoldKey, () async {
                                      if (await _interStitial.isLoaded) {
                                        _interStitial.show();
                                      }
                                    })
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                )),
            Positioned(
              top: 10.0,
              left: 0.0,
              right: 0.0,
              child: AdmobBanner(
                adUnitId: "ca-app-pub-4056821571384483/5325355707", //real ad
                // adUnitId: "ca-app-pub-3940256099942544/6300978111", //test ad
                adSize: AdmobBannerSize.BANNER,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
