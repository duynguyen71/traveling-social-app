import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AnimatedMapControllerPage extends StatefulWidget {
  static const String route = 'map_controller_animated';

  const AnimatedMapControllerPage({Key? key}) : super(key: key);

  @override
  AnimatedMapControllerPageState createState() {
    return AnimatedMapControllerPageState();
  }
}

class AnimatedMapControllerPageState extends State<AnimatedMapControllerPage>
    with TickerProviderStateMixin {
  // Note the addition of the TickerProviderStateMixin here. If you are getting an error like
  // 'The class 'TickerProviderStateMixin' can't be used as a mixin because it extends a class other than Object.'
  // in your IDE, you can probably fix it by adding an analysis_options.yaml file to your project
  // with the following content:
  //  analyzer:
  //    language:
  //      enableSuperMixins: true
  // See https://github.com/flutter/flutter/issues/14317#issuecomment-361085869
  // This project didn't require that change, so YMMV.

  static LatLng london = LatLng(51.5, -0.09);
  static LatLng paris = LatLng(48.8566, 2.3522);
  static LatLng dublin = LatLng(53.3498, -6.2603);

  late final MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
    CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[
      Marker(
        width: 80,
        height: 80,
        point: london,
        builder: (ctx) => Container(
          key: const Key('blue'),
          child: const FlutterLogo(),
        ),
      ),
      Marker(
        width: 80,
        height: 80,
        point: dublin,
        builder: (ctx) => const FlutterLogo(
          key: Key('green'),
          textColor: Colors.green,
        ),
      ),
      Marker(
        width: 80,
        height: 80,
        point: paris,
        builder: (ctx) => Container(
          key: const Key('purple'),
          child: const FlutterLogo(textColor: Colors.purple),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Animated MapController')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      _animatedMapMove(london, 10);
                    },
                    child: const Text('London'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      _animatedMapMove(paris, 5);
                    },
                    child: const Text('Paris'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      _animatedMapMove(dublin, 5);
                    },
                    child: const Text('Dublin'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      final bounds = LatLngBounds();
                      bounds.extend(dublin);
                      bounds.extend(paris);
                      bounds.extend(london);
                      mapController.fitBounds(
                        bounds,
                        options: const FitBoundsOptions(
                          padding: EdgeInsets.only(left: 15, right: 15),
                        ),
                      );
                    },
                    child: const Text('Fit Bounds'),
                  ),
                  MaterialButton(
                    onPressed: () {
                      final bounds = LatLngBounds();
                      bounds.extend(dublin);
                      bounds.extend(paris);
                      bounds.extend(london);

                      final centerZoom =
                      mapController.centerZoomFitBounds(bounds);
                      _animatedMapMove(centerZoom.center, centerZoom.zoom);
                    },
                    child: const Text('Fit Bounds animated'),
                  ),
                ],
              ),
            ),
            Flexible(
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                    center: LatLng(51.5, -0.09),
                    zoom: 5,
                    maxZoom: 10,
                    minZoom: 3),
                children: [

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}