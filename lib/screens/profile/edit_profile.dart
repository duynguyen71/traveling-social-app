import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_bloc.dart';
import 'package:traveling_social_app/authentication/bloc/authentication_state.dart';
import 'package:traveling_social_app/constants/api_constants.dart';
import 'package:traveling_social_app/extension/string_apis.dart';
import 'package:traveling_social_app/models/update_base_user_info.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/widgets/base_app_bar.dart';
import 'package:traveling_social_app/widgets/current_user_avt.dart';

import '../../bloc/appIication/application_state_bloc.dart';
import '../../constants/app_theme_constants.dart';
import '../../models/location.dart';
import '../../services/user_service.dart';

import '../../widgets/location_finder.dart';

class EditProfile extends StatefulWidget {
  const EditProfile(
      {Key? key,
      required this.onUpdateCallback,
      required this.onTapUserAvt,
      required this.onTapCoverBg})
      : super(key: key);

  final Future<void> Function(UpdateBaseUserInfo userInfo) onUpdateCallback;
  final Function(BuildContext context) onTapUserAvt;
  final Function(BuildContext context) onTapCoverBg;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with AutomaticKeepAliveClientMixin {
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _websiteController = TextEditingController();
  final _locationController = TextEditingController();
  final _formatBirthdayController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _userService = UserService();
  String? _usernameError;

  set usernameError(String? str) => setState(() => _usernameError = str);

  @override
  void initState() {
    super.initState();
    var user = context.read<AuthenticationBloc>().state.user;
    _usernameController.text = user.username;
    _fullNameController.text = user.fullName ?? '';
    _bioController.text = user.bio ?? '';
    _websiteController.text = user.website ?? '';
    _formatBirthdayController.text = user.birthdate ?? '';
  }

  @override
  void didChangeDependencies() {
    // if (mounted) {
    //   var user = context.read<AuthenticationBloc>().state.user;
    //   _formatBirthdayController.text = ApplicationUtility.formatDate(
    //           user.birthdate,
    //           locale: Localizations.localeOf(context)) ??
    //       '';
    // }
    super.didChangeDependencies();
  }

  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return DraggableScrollableSheet(
      initialChildSize: .95,
      maxChildSize: .95,
      minChildSize: .6,
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
              child: BaseAppBar(
                title: AppLocalizations.of(context)!.editProfile,
                leading: Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    // Cancel button
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
                actions: [
                  // Save button
                  TextButton(
                    onPressed: () async {
                      await _updateBaseUserInfo();
                    },
                    child: Text(AppLocalizations.of(context)!.save),
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
                    alignment: Alignment.topLeft,
                    children: [
                      ListView(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          //AVT
                          SizedBox(
                            height: (size.height * .3) + 60,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: (size.height * .3),
                                  width: double.infinity,
                                  child: GestureDetector(
                                    onTap: () {
                                      widget.onTapCoverBg(context);
                                    },
                                    //BACKGROUND
                                    child: BlocConsumer<AuthenticationBloc,
                                        AuthenticationState>(
                                      builder: (context, state) {
                                        return AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                '$imageUrl${state.user.background}',
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              "assets/images/home_bg.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                      listener: (context, state) =>
                                          state.user.background,
                                    ),
                                  ),
                                ),
                                //CURRENT USER AVT
                                Positioned(
                                  top: (size.height * .3) - 40,
                                  left: kDefaultPadding,
                                  child: CurrentUserAvt(
                                    padding: const EdgeInsets.all(4.0),
                                    onTap: () {
                                      widget.onTapUserAvt(context);
                                    },
                                    size: 80,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // END OF AVT AND BACKGROUND
                          Container(
                            // margin: const EdgeInsets.symmetric(vertical: 40),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              shrinkWrap: true,
                              children: [
                                // Username
                                CustomTextField(
                                  label: AppLocalizations.of(context)!.username,
                                  onChanged: _validationUsernameOnChanged,
                                  errorText: _usernameError,
                                  controller: _usernameController,
                                  hintText: 'username',
                                ),
                                // FullName
                                CustomTextField(
                                  label: AppLocalizations.of(context)!.fullName,
                                  controller: _fullNameController,
                                  hintText: AppLocalizations.of(context)!
                                      .addYourFullName,
                                ),
                                // Bio
                                CustomTextField(
                                  minLines: 3,
                                  textInputType: TextInputType.multiline,
                                  label: AppLocalizations.of(context)!.bio,
                                  controller: _bioController,
                                  hintText:
                                      AppLocalizations.of(context)!.addBio,
                                ),
                                // Location
                                CustomTextField(
                                  onTap: _handleShowLocations,
                                  enabled: false,
                                  label: AppLocalizations.of(context)!.location,
                                  controller: _locationController,
                                  hintText: AppLocalizations.of(context)!
                                      .addYourLocation,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    color: Colors.black45,
                                  ),
                                ),
                                // Website
                                CustomTextField(
                                  textInputType: TextInputType.url,
                                  label: 'Website',
                                  controller: _websiteController,
                                  hintText:
                                      AppLocalizations.of(context)!.addWebsite,
                                ),
                              ],
                            ),
                          ),
                        ],
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

  // FractionallySizedBox
  _handleShowLocations() {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context) {
          return LocationFinder(
            onSaveLocation: (Location? location) {
              Navigator.pop(context);
              dto = dto.copyWith(location: location);
              if (location != null) {
                _locationController.text = location.label ?? '';
              }
            },
          );
        },
        backgroundColor: Colors.transparent,
        isDismissible: true,
        isScrollControlled: true);
  }

  _validationUsernameOnChanged(String? str) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () async {
      await _checkValidUsername(str);
    });
  }

  Future<void> _checkValidUsername(String? str) async {
    if (str.isNullOrBlank) {
      usernameError = 'Please add your username!';
      return;
    }
    var baseUsername = context.read<AuthenticationBloc>().state.user.username;
    if (baseUsername == str) {
      usernameError = null;
      return;
    }
    var resp =
        await _userService.checkValidationInput(input: 'username', value: str);
    usernameError = resp;
  }

  /// Show pick date dialog & get Date
  // Future<void> _getBirthdate(BuildContext context) async {
  //   var tryGetDate = await showDatePicker(
  //     context: context,
  //     initialDate:
  //         DateTime.tryParse(_birthdayController.text) ?? DateTime.now(),
  //     firstDate: DateTime.utc(1900),
  //     lastDate: DateTime.now(),
  //     locale: Localizations.localeOf(context),
  //     fieldLabelText: AppLocalizations.of(context)!.addYourBirthDate,
  //   );
  //
  //   var formatDate = ApplicationUtility.formatDate(tryGetDate.toString(),
  //       locale: Localizations.localeOf(context));
  //
  //   if (formatDate != null) {
  //     _birthdayController.text = tryGetDate.toString();
  //     _formatBirthdayController.text = formatDate;
  //   }
  // }

  var dto = UpdateBaseUserInfo();

  /// Handle update base user info
  _updateBaseUserInfo() async {
    ApplicationUtility.hideKeyboard();
    var newUsername = _usernameController.text;
    await _checkValidUsername(newUsername);
    if (_usernameError != null) {
      return;
    }
    dto = dto.copyWith(
        website: _websiteController.text,
        bio: _bioController.text,
        username: _usernameController.text,
        fullName: _fullNameController.text);
    await widget.onUpdateCallback(dto);
    ApplicationUtility.hideKeyboard();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _websiteController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _formatBirthdayController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      this.hintText,
      required this.label,
      required this.controller,
      this.minLines,
      this.textInputType,
      this.enabled = true,
      this.icon = const SizedBox.shrink(),
      this.onTap,
      this.onChanged,
      this.errorText})
      : super(key: key);
  final String? hintText;
  final String label;
  final int? minLines;
  final TextEditingController controller;
  final TextInputType? textInputType;
  final bool enabled;
  final Widget icon;
  final Function()? onTap;
  final Function(String? value)? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
            ),
            Flexible(
              child: TextFormField(
                onChanged: onChanged,
                enabled: enabled,
                minLines: minLines,
                maxLines: null,
                obscureText: false,
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  errorText: errorText,
                  errorStyle: const TextStyle(
                    color: Colors.redAccent,
                  ),
                  isCollapsed: true,
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    fontSize: 14,
                  ),
                  // contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                ),
                style: const TextStyle(
                  color: Colors.blueAccent,
                ),
                keyboardType: textInputType,
              ),
            ),
            icon
          ],
        ),
      ),
    );
  }
}
