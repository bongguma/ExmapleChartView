import 'package:flutter/material.dart';
import 'package:flutter_kakao_map/flutter_kakao_map.dart';
import 'package:flutter_kakao_map/kakao_maps_flutter_platform_interface.dart';

class KakaoMapTestView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Radar 차트예제'),
      ),
      body: KakaoMapView(),
    );
  }
}

class KakaoMapView extends StatefulWidget {
  @override
  KakaoMapViewState createState() => KakaoMapViewState();
}

class KakaoMapViewState extends State<KakaoMapView>{

  KakaoMapController mapController;
  MapPoint _visibleRegion = MapPoint(37.5087553, 127.0632877);
  CameraPosition _kInitialPosition =
  CameraPosition(target: MapPoint(37.5087553, 127.0632877), zoom: 3);

  void onMapCreated(KakaoMapController controller) async {
    final MapPoint visibleRegion = await controller.getMapCenterPoint();
    setState(() {
      mapController = controller;
      _visibleRegion = visibleRegion;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: SizedBox(
                width: 500,
                height: 500,
                child: KakaoMap(
                    onMapCreated: onMapCreated,
                    initialCameraPosition: _kInitialPosition)))
      ],
    );
  }

}