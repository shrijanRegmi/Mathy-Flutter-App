import 'package:admob_flutter/admob_flutter.dart';
import 'package:mathy/models/function/changeIndex.dart';
import 'package:mathy/models/function/guest.dart';
import 'package:mathy/models/function/saveValues.dart';
import 'package:mathy/services/authentication/auth_provider.dart';
import 'package:mathy/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  Admob.initialize("ca-app-pub-4056821571384483~3086753910");
  runApp(Mathy());
}

// text ads
// banner id: ca-app-pub-3940256099942544/6300978111
// interstitial id: ca-app-pub-3940256099942544/1033173712
// rewarded id: ca-app-pub-3940256099942544/5224354917

class Mathy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChangeIndex>(
          create: (context) => ChangeIndex(),
        ),
        ChangeNotifierProvider<GuestUser>(
          create: (context) => GuestUser(),
        ),
        ChangeNotifierProvider<SaveMyValues>(
          create: (context) => SaveMyValues(),
        ),
        StreamProvider.value(value: AuthProvider().user),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: "Mont"),
        title: "Mathy",
        home: Material(
          child: Wrapper(),
        ),
      ),
    );
  }
}
