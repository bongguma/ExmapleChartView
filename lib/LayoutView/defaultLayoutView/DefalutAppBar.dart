import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:sometrend_charttest/Auth/GoogleLoginAuthProvider.dart';
import 'package:sometrend_charttest/Data/Type/LoginType.dart';
import 'package:sometrend_charttest/theme/ThemeFactory.dart';

class DefaultAppbar extends StatefulWidget implements PreferredSizeWidget {
  final bool isBackBtn;
  final LoginType loginType;
  final Size preferredSize = Size.fromHeight(50);

  DefaultAppbar({Key key, @required this.isBackBtn, @required this.loginType})
      : super(key: key);

  @override
  State<DefaultAppbar> createState() => _defaultAppbarState();
}

class _defaultAppbarState extends State<DefaultAppbar> {
  @override
  void initState() {
    super.initState();
  }

  /* backIcon Btn을 그리는 Widget */
  Widget backIconBtn(theme) {
    return GestureDetector(
      child: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: theme.primaryBlackBgColor,
        ),
      ),
      onTap: () {},
    );
  }

  /* 오른쪽 로그아웃을 그리는 Widget */
  Widget LogOutIconBtn(theme) {
    return GestureDetector(
      child: IconButton(
        icon: Icon(
          Icons.lock,
          color: theme.primaryBlackBgColor,
        ),
      ),
      onTap: () async {
        if (widget.loginType == LoginType.KAKAO) {
          await UserApi.instance.logout();
          Navigator.pop(context, false);
        } else if (widget.loginType == LoginType.GOOGLE) {
          GoogleLoginAuthProvider().logOut().then((isLogOut) {
            if (isLogOut) {
              Get.back();
            }
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = new ThemeFactory.of(context).theme;

    return DefaultTabController(
      length: 5,
      child: AppBar(
        backgroundColor: theme.secondaryBgColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: widget.isBackBtn ? backIconBtn(theme) : Container(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 30,
              child: LogOutIconBtn(theme),
            ),
          ],
        ),
      ),
    );
  }
}
