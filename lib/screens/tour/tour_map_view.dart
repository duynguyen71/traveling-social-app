import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../bloc/appIication/application_state_bloc.dart';

class TourMapView extends StatefulWidget {
  const TourMapView({Key? key, required this.latLng}) : super(key: key);
  final LatLng latLng;

  @override
  State<TourMapView> createState() => _TourMapViewState();
}

class _TourMapViewState extends State<TourMapView>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final MapController mapController = MapController();

  bool showLocations = false;
  late LatLng _point;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _point = widget.latLng;
    });
  }

  @override
  void initState() {
    super.initState();
    var loc = context.read<ApplicationStateBloc>().state.currentLocation;
    if (loc == null) {
      context.read<ApplicationStateBloc>().add(GetCurrentLocationEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        FlutterMap(
          mapController: mapController,
          key: ValueKey(MediaQuery.of(context).orientation),
          options: MapOptions(
            onMapReady: () {},
            center: widget.latLng,
            zoom: 15,
            onTap: (tapPosition, point) async {
              // _onTapMap(point, context);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _point,
                  width: 100,
                  height: 100,
                  builder: (context) => const Icon(
                    Icons.location_on,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    color: Colors.white,
                    // return
                    child: IconButton(
                      onPressed: () {
                        _animatedMapMove(widget.latLng, 15);
                        setState(() {
                          _point = widget.latLng;
                        });
                      },
                      icon: Icon(Icons.keyboard_return),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    color: Colors.white,
                    child: IconButton(
                      onPressed: () {
                        var currentLoc = context
                            .read<ApplicationStateBloc>()
                            .state
                            .currentLocation;
                        var latLng = LatLng(
                            currentLoc!.latitude!, currentLoc!.longitude!);
                        _animatedMapMove(latLng, 15);
                        setState(() {
                          _point = latLng;
                        });
                      },
                      icon: const Icon(Icons.center_focus_strong_rounded),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
