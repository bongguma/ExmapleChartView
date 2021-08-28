
import 'package:flutter/material.dart';

class DefaultAppbar extends StatefulWidget implements PreferredSizeWidget {

  DefaultAppbar(bool isBackBtn, {Key key}) : isBackBtn = isBackBtn, preferredSize = Size.fromHeight(100), super(key: key);

  @override
  final bool isBackBtn;

  @override
  final Size preferredSize;

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
    return IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {

        });
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 5,
      child: AppBar(
        backgroundColor: Colors.red,
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
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
