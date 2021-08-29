
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:sometrend_charttest/Data/Type/LoginType.dart';
import 'package:sometrend_charttest/theme/ThemeFactory.dart';

class DefaultAppbar extends StatefulWidget implements PreferredSizeWidget {

  final bool isBackBtn;
  final LoginType loginType;
  final Size preferredSize = Size.fromHeight(50);

  DefaultAppbar({Key key, @required this.isBackBtn, @required this.loginType}) : super(key: key);

  @override
  State<DefaultAppbar> createState() => _defaultAppbarState();
}

class _defaultAppbarState extends State<DefaultAppbar> {

  @override
  void initState() {
    super.initState();

  }

  /* backIcon Btn을 그리는 Widget */
  Widget backIconBtn() {
    return GestureDetector(
      child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
      ),
      onTap: () async {
        print('backIconBtn!!!!!!!!!');
        if(widget.loginType == LoginType.KAKAO) {
          await UserApi.instance.logout();
          Navigator.pop(context, false);
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
        leading: widget.isBackBtn ? backIconBtn() : Container(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 30,
              child: Icon(
                Icons.lock,
                color: theme.primaryBlackBgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
