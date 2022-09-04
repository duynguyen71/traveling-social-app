import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:traveling_social_app/bloc/appIication/application_state_bloc.dart';
import 'package:traveling_social_app/models/location.dart';
import 'dart:math';
import 'package:flutter_map/flutter_map.dart';
import '../constants/app_theme_constants.dart';

class OpenStreetMap extends StatefulWidget {
  const OpenStreetMap({Key? key, this.location}) : super(key: key);

  @override
  State<OpenStreetMap> createState() => _OpenStreetMapState();

  final Location? location;
}

class _OpenStreetMapState extends State<OpenStreetMap>
    with TickerProviderStateMixin {
  late LatLng _point;
  late final MapController mapController;
  bool showLocations = false;

  @override
  void initState() {
    super.initState();
    var location = widget.location!;
    _point = LatLng(location.latitude!, location.longitude!);
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

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        FlutterMap(
          key: ValueKey(MediaQuery.of(context).orientation),
          options: MapOptions(
            onMapCreated: (m) {
              mapController = m;
            },
            center: _point,
            zoom: 15,
            onTap: (tapPosition, point) async {
              _onTapMap(point, context);
            },
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayerOptions(
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
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.only(right: 4),
                          icon: Icon(Icons.arrow_back_ios_new)),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: BlocBuilder<ApplicationStateBloc,
                                      ApplicationStateState>(
                                    builder: (context, state) {
                                      var selectedLocation =
                                          state.selectedLocation;
                                      if (selectedLocation != null) {
                                        _textController.text =
                                            selectedLocation.label.toString();
                                        _textController.selection =
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset: selectedLocation
                                                        .label
                                                        .toString()
                                                        .length));
                                      }
                                      return TextField(
                                        style: const TextStyle(
                                            color: kPrimaryColor, fontSize: 14),
                                        keyboardType: TextInputType.multiline,
                                        textAlign: TextAlign.left,
                                        maxLines: null,
                                        onTap: () {
                                          setState(() {
                                            showLocations = true;
                                          });
                                        },
                                        textInputAction: TextInputAction.go,
                                        onSubmitted: (value) {
                                          context
                                              .read<ApplicationStateBloc>()
                                              .add(ForwardLocationEvent(value));
                                          setState(() {
                                            showLocations = true;
                                          });
                                        },
                                        controller: _textController,
                                        decoration: InputDecoration(
                                          isCollapsed: true,
                                          filled: true,
                                          fillColor: Colors.grey.shade200,
                                          contentPadding:
                                              const EdgeInsets.all(8.0),
                                          border: InputBorder.none,
                                          hintStyle: const TextStyle(
                                            color: Colors.black45,
                                            fontSize: 14,
                                          ),
                                          hintText: selectedLocation == null
                                              ? "Nhập địa điểm cần tìm..."
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  showLocations
                      ? BlocBuilder<ApplicationStateBloc,
                          ApplicationStateState>(
                          builder: (context, state) {
                            var locations = state.locations;
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: Colors.white,
                                constraints: const BoxConstraints(
                                  maxHeight: 300,
                                ),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: false,
                                  itemBuilder: (context, index) {
                                    var location = locations[index];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showLocations = false;
                                          var latLng = LatLng(
                                              location.latitude!,
                                              location.longitude!);
                                          _point = latLng;
                                          _animatedMapMove(latLng, 10);
                                        });
                                        context
                                            .read<ApplicationStateBloc>()
                                            .add(SelectLocationEvent(location));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        color: Colors.white,
                                        child: Text(location.label.toString()),
                                      ),
                                    );
                                  },
                                  itemCount: locations.length,
                                ),
                              ),
                            );
                          },
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          top: 10,
          right: 0,
          left: 0,
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
                    child: IconButton(
                      onPressed: () {
                        var currentLoc = context
                            .read<ApplicationStateBloc>()
                            .state
                            .selectedLocation;
                        var latLng = LatLng(
                            currentLoc!.latitude!, currentLoc!.longitude!);
                        _animatedMapMove(latLng, 15);
                        context
                            .read<ApplicationStateBloc>()
                            .add(SelectLocationEvent(currentLoc));
                        setState(() {
                          _point = latLng;
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
                        context
                            .read<ApplicationStateBloc>()
                            .add(SelectLocationEvent(currentLoc));
                        _animatedMapMove(latLng, 15);
                        setState(() {
                          _point = latLng;
                        });
                      },
                      icon: Icon(Icons.center_focus_strong_rounded),
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

  void _onTapMap(LatLng point, BuildContext context) {
    if (showLocations) {
      setState(() {
        showLocations = false;
      });
      return;
    }
    setState(() {
      _point = point;
      showLocations = true;
    });
    context.read<ApplicationStateBloc>().add(ReverseLocationEvent(
        latitude: point.latitude, longitude: point.longitude));
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
