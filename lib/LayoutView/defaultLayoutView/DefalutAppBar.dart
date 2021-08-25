
import 'package:flutter/material.dart';

class DefaultAppbar extends StatefulWidget implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(100);



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
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: backIconBtn(),
        title: GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: Text('appBar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
