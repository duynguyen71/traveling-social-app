import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traveling_social_app/widgets/rounded_icon_button.dart';
import 'package:traveling_social_app/widgets/rounded_input_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/appIication/application_state_bloc.dart';
import '../models/location.dart';

class LocationFinder extends StatefulWidget {
  const LocationFinder({Key? key, required this.onSaveLocation})
      : super(key: key);
  final Function(Location? location) onSaveLocation;


  @override
  State<LocationFinder> createState() => _LocationFinderState();
}

class _LocationFinderState extends State<LocationFinder> {
  Location? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .925,
      maxChildSize: .925,
      minChildSize: .7,
      snap: false,
      builder: (context, scrollController) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                title: RoundedInputContainer(
                  color: Colors.grey.shade100,
                  child: TextField(
                    textAlign: TextAlign.left,
                    onChanged: (value) {
                      if (value.isEmpty) {}
                    },
                    onSubmitted: (value) {
                      context
                          .read<ApplicationStateBloc>()
                          .add(ForwardLocationEvent(value));
                    },
                    decoration: const InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: 'Địa chỉ',
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      hintStyle: TextStyle(
                        letterSpacing: .5,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.zero,
                ),
                actions: [
                  // Save button
                  TextButton(
                    onPressed: () => widget.onSaveLocation(selectedLocation),
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ListView(
                        controller: scrollController,
                        shrinkWrap: true,
                        children: [
                          selectedLocation != null
                              ? SelectedLocationWidget(
                              location: selectedLocation!,
                              onRemove: () {
                                setState(() => selectedLocation = null);
                              })
                              : const SizedBox.shrink(),
                          BlocBuilder<ApplicationStateBloc,
                              ApplicationStateState>(
                            builder: (context, state) {
                              var locations = state.locations;
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var location = locations[index];
                                  return LocationWidget(
                                    location: location,
                                    onSelected: () =>
                                        setState(
                                                () =>
                                            selectedLocation = location),
                                  );
                                },
                                itemCount: locations.length,
                              );
                            },
                          )
                        ],
                      ),
                      BlocBuilder<ApplicationStateBloc, ApplicationStateState>(
                        builder: (context, state) {
                          return state.status == ApplicationStatus.loading
                              ? const Positioned.fill(
                              child: Center(
                                child: CupertinoActivityIndicator(),
                              ))
                              : const SizedBox.shrink();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class LocationWidget extends StatelessWidget {
  const LocationWidget(
      {Key? key, required this.location, required this.onSelected})
      : super(key: key);
  final Location location;
  final Function onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => onSelected(),
        child: Ink(
          child: Container(
            decoration: BoxDecoration(
                border:
                Border(bottom: BorderSide(color: Colors.grey.shade100))),
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.label ?? '',
                        style: TextStyle(
                            color: Colors.black87,
                            letterSpacing: .7,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        location.city ?? '',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SelectedLocationWidget extends StatelessWidget {
  const SelectedLocationWidget(
      {Key? key, required this.location, required this.onRemove})
      : super(key: key);
  final Location location;
  final Function onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {},
        child: Ink(
          child: Container(
            decoration: BoxDecoration(
                border:
                Border(bottom: BorderSide(color: Colors.grey.shade100))),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.label ?? '',
                        style: TextStyle(
                            color: Colors.black87,
                            letterSpacing: .7,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        location.city ?? '',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundedIconButton(
                    onClick: onRemove,
                    icon: Icons.remove,
                    bgColor: Colors.redAccent,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
