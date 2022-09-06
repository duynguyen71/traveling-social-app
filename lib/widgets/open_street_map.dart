import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:traveling_social_app/bloc/appIication/application_state_bloc.dart';
import 'package:traveling_social_app/bloc/review/creation_review_cubit.dart';
import 'package:traveling_social_app/models/location.dart';
import 'package:flutter_map/flutter_map.dart';
import '../constants/app_theme_constants.dart';
import '../utilities/application_utility.dart';

class OpenStreetMap extends StatefulWidget {
  const OpenStreetMap({Key? key, this.location}) : super(key: key);

  @override
  State<OpenStreetMap> createState() => _OpenStreetMapState();

  final Location? location;
}

class _OpenStreetMapState extends State<OpenStreetMap>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late LatLng _point;
  late final MapController mapController = MapController();
  bool showLocations = false;
  late LatLng _lastSelectedLoc;

  @override
  void initState() {
    super.initState();
    var location = widget.location!;
    _point = LatLng(location.latitude!, location.longitude!);
    _lastSelectedLoc = LatLng(location.latitude!, location.longitude!);
    context.read<ApplicationStateBloc>().add(const GetCurrentLocationEvent());
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
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        return await _onWillPop(context);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          FlutterMap(
            mapController: mapController,
            key: ValueKey(MediaQuery.of(context).orientation),
            options: MapOptions(
              center: _point,
              zoom: 15,
              onTap: (tapPosition, point) async {
                _onTapMap(point, context);
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
                            onPressed: () async {
                              var location = context
                                  .read<ApplicationStateBloc>()
                                  .state
                                  .selectedLocation;
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: const Text("Thông báo"),
                                      content: Text(
                                          "Bạn đã chọn ${location?.label ?? ''}"),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: const Text("Got it"),
                                          isDefaultAction: true,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  },
                                  barrierDismissible: false);
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
                                              color: kPrimaryColor,
                                              fontSize: 14),
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
                                                .add(ForwardLocationEvent(
                                                    value));
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
                              var status = state.status;
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      status == ApplicationStatus.loading
                                          ? const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child:
                                                    CupertinoActivityIndicator(),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                      Container(
                                        constraints: const BoxConstraints(
                                          maxHeight: 300,
                                        ),
                                        child: ListView.builder(
                                          shrinkWrap: false,
                                          itemBuilder: (context, index) {
                                            var location = locations[index];
                                            return GestureDetector(
                                              onTap: () {
                                                onTapLocationText(
                                                    location, context);
                                              },
                                              child: Container(
                                                color: Colors.white,
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child:
                                                    Text(location.label ?? ''),
                                              ),
                                            );
                                          },
                                          itemCount: locations.length,
                                        ),
                                      ),
                                    ],
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
                      // return
                      child: IconButton(
                        onPressed: () {
                          var latLng = LatLng(widget.location!.latitude!,
                              widget.location!.longitude!);
                          _animatedMapMove(latLng, 15);
                          context
                              .read<ApplicationStateBloc>()
                              .add(SelectLocationEvent(widget.location));
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
                          if (currentLoc == null) {
                            context
                                .read<ApplicationStateBloc>()
                                .add(const GetCurrentLocationEvent());
                            return;
                          }
                          var latLng = LatLng(
                              currentLoc.latitude!, currentLoc.longitude!);
                          context
                              .read<ApplicationStateBloc>()
                              .add(SelectLocationEvent(currentLoc));
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
      ),
    );
  }

  _onWillPop(BuildContext context) async {
    var location = context.read<ApplicationStateBloc>().state.selectedLocation;
    await showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Thông báo"),
            content: Text("Bạn đã chọn ${location?.label ?? ''}"),
            actions: [
              CupertinoDialogAction(
                child: const Text("Got it"),
                isDefaultAction: true,
                onPressed: () {
                  context
                      .read<CreateReviewPostCubit>()
                      .updateReviewPost(location: location);
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: const Text("Hủy"),
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
        barrierDismissible: false);
    return Future.value(true);
  }

  void onTapLocationText(Location location, BuildContext context) {
    ApplicationUtility.hideKeyboard();
    setState(() {
      showLocations = false;
      var latLng = LatLng(location.latitude!, location.longitude!);
      _point = latLng;
      _animatedMapMove(latLng, 15);
    });
    context.read<ApplicationStateBloc>().add(SelectLocationEvent(location));
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
    });
    context.read<ApplicationStateBloc>().add(ReverseLocationEvent(
        latitude: point.latitude, longitude: point.longitude));
    setState(() {
      showLocations = true;
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
