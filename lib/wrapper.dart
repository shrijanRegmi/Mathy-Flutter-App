import 'package:mathy/models/firebase/users.dart';
import 'package:mathy/models/function/guest.dart';
import 'package:mathy/models/function/saveValues.dart';
import 'package:mathy/screens/authentication/auth_screen.dart';
import 'package:mathy/screens/home/home_screen.dart';
import 'package:mathy/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserDetail>(context);
    final _guest = Provider.of<GuestUser>(context);
    final _saveValue = Provider.of<SaveMyValues>(context);
    print(_saveValue.playingMusic);
    return _user != null
        ? MultiProvider(providers: [
            StreamProvider<UserDetail>.value(
              value: DatabaseProvider(uid: _user.uid).userDetail,
            ),
            StreamProvider<List<UserDetail>>.value(
              value: DatabaseProvider(uid: _user.uid).topPlayers,
            )
          ], child: HomeScreen())
        : _guest.guest
            ? MultiProvider(providers: [
                StreamProvider<UserDetail>.value(
                  value: DatabaseProvider().userDetail,
                ),
                StreamProvider<List<UserDetail>>.value(
                  value: DatabaseProvider().topPlayers,
                )
              ], child: HomeScreen())
            : AuthScreen();
  }
}
