import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveling_social_app/services/post_service.dart';
import 'package:traveling_social_app/utilities/application_utility.dart';
import 'package:traveling_social_app/widgets/tour.dart';

import '../../bloc/tour/user_tour_bloc.dart';
import '../../models/tag.dart';
import '../../widgets/base_app_bar.dart';
import '../create_review/find_pick_tag.dart';
import '../profile/components/icon_with_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateTourScreen extends StatefulWidget {
  const CreateTourScreen({Key? key}) : super(key: key);

  @override
  State<CreateTourScreen> createState() => _CreateTourScreenState();

  static Route route() =>
      MaterialPageRoute(builder: (context) => const CreateTourScreen());
}

class _CreateTourScreenState extends State<CreateTourScreen>
    with AutomaticKeepAliveClientMixin {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _costController = TextEditingController();
  final _numOfMemberController = TextEditingController();
  final _dayController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _postService = PostService();

  @override
  void initState() {
    super.initState();
    // context.read<UserTourBloc>().context.watch<SubjectBloc>()
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _numOfMemberController.dispose();
    _dayController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var tour = context.watch<UserTourBloc>().state.createTour;
    _titleController.text = tour?.title ?? '';
    _contentController.text = tour?.content ?? '';
    _costController.text = tour?.cost != null ? tour!.cost.toString() : '0';
    _numOfMemberController.text =
        tour?.numOfMember != null ? tour!.numOfMember.toString() : '0';
    _dayController.text =
        tour?.totalDay != null ? tour!.totalDay.toString() : '0';

    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.white,
        appBar: BaseAppBar(
          title: ("Chuyến đi của bạn"),
          actions: [
            Center(
              child: GestureDetector(
                onTap: () => _handleSavePost(),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    AppLocalizations.of(context)!.posting,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Form(
                            autovalidateMode: AutovalidateMode.disabled,
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Title
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        showCursor: false,
                                        keyboardType: TextInputType.multiline,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Tiêu đề không được để trống";
                                          } else if (value.length > 25) {
                                            return "Tiêu đề không quá 25 ký tự";
                                          }
                                          return null;
                                        },
                                        maxLines: null,
                                        controller: _titleController,
                                        decoration: InputDecoration(
                                            labelText: 'Tiêu đề chuyến đi',
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(8.0),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Colors.black26),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Colors.black26),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                //Content
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Nội dung không được để trống";
                                        } else if (value.length < 25) {
                                          return "Nội dung phải trên 25 ký tự";
                                        }
                                        return null;
                                      },
                                      maxLines: null,
                                      controller: _contentController,
                                      decoration: InputDecoration(
                                          labelText: 'Miêu tả lộ trình của bạn',
                                          contentPadding: EdgeInsets.all(8.0),
                                          // isCollapsed: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1,
                                                color: Colors.black26),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1,
                                                color: Colors.black26),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          )),
                                    )),
                                  ],
                                ),

                                // Chọn địa điểm
                                const SizedBox(height: 10),
                                //
                                BlocBuilder<UserTourBloc, UserTourState>(
                                  buildWhen: (previous, current) {
                                    return (previous.createTour?.location !=
                                        current.createTour?.location);
                                  },
                                  builder: (context, state) {
                                    var loc = state.createTour?.location;
                                    return Row(
                                      children: [
                                        IconTextButton(
                                          text: loc == null
                                              ? 'Chọn điểm đến'
                                              : (loc.label ?? "Chọn điểm đến"),
                                          onTap: () {
                                            _onSelectLocation(context);
                                          },
                                          icon: const Icon(
                                              Icons.location_on_outlined),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(child: BlocBuilder<UserTourBloc,
                                        UserTourState>(
                                      builder: (context, state) {
                                        return TextFormField(
                                          controller: _costController,
                                          keyboardType: const TextInputType
                                                  .numberWithOptions(
                                              decimal: true, signed: true),
                                          maxLines: null,
                                          decoration: InputDecoration(
                                              labelText:
                                                  'Tổng tiển dự kiến (VND)',
                                              contentPadding:
                                                  EdgeInsets.all(8.0),
                                              isCollapsed: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 1,
                                                    color: Colors.black26),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 1,
                                                    color: Colors.black26),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              )),
                                        );
                                      },
                                    )),
                                  ],
                                ),
                              ],
                            )),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: _numOfMemberController,
                                keyboardType: TextInputType.number,
                                maxLines: null,
                                decoration: InputDecoration(
                                  labelText: 'Số thành viên',
                                  contentPadding: EdgeInsets.all(8.0),
                                  isCollapsed: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.black26),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.black26),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: TextFormField(
                                controller: _dayController,
                                keyboardType: TextInputType.number,
                                maxLines: null,
                                decoration: InputDecoration(
                                    labelText: 'Tổng ngày đi',
                                    contentPadding: EdgeInsets.all(8.0),
                                    isCollapsed: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.black26),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.black26),
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<UserTourBloc, UserTourState>(
                          buildWhen: (previous, current) {
                            return previous.createTour?.tags !=
                                current.createTour?.tags;
                          },
                          builder: (context, state) {
                            var selectedTags = state.createTour?.tags ?? [];
                            return Wrap(
                              runSpacing: 5,
                              spacing: 2,
                              children: [
                                IconTextButton(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return FindPickTag(
                                            initialTags: [...?selectedTags],
                                            onSave: (List<Tag> tags) {
                                              var getContextTour =
                                                  _getContextTour(context);
                                              var copyWith = getContextTour
                                                  .copyWith(tags: tags);
                                              _updateTour(context, copyWith);
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                        backgroundColor: Colors.white,
                                        isDismissible: true,
                                        isScrollControlled: true);
                                  },
                                  text: (selectedTags != null &&
                                          selectedTags.isEmpty)
                                      ? 'Thêm thẻ'
                                      : "Sửa",
                                  icon: const Icon(Icons.tag),
                                ),
                                ...selectedTags.map(
                                  (e) => e.status == 0
                                      ? const SizedBox.shrink()
                                      : Text(
                                          e.name.toString(),
                                          style: const TextStyle(
                                              color: Colors.blueAccent),
                                        ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            BlocBuilder<UserTourBloc, UserTourState>(
              builder: (context, state) {
                return state.status == UserTourStateStatus.loading
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
    );
  }

  _handleSavePost() async {
    var tour = _getContextTour(context);
    var text = _costController.text;
    tour = tour.copyWith(
      title: _titleController.text,
      content: _contentController.text,
      numOfMember: int.tryParse(_numOfMemberController.text),
      cost: double.tryParse(text),
      totalDay: int.tryParse(_dayController.text),
    );
    _updateTour(context, tour);
    await _postService.saveTour(tour: tour);
    context.read<UserTourBloc>().add(const GetCurrentTourEvent());
    Navigator.pop(context);
  }

  Tour _getContextTour(BuildContext context) {
    var tour = context.read<UserTourBloc>().state.createTour;
    tour ??= const Tour();
    return tour;
  }

  _updateTour(BuildContext context, Tour tour) {
    context.read<UserTourBloc>().add(UpdateEditingTourEvent(tour));
  }

  void _onSelectLocation(BuildContext context) {
    var tour = _getContextTour(context);
    tour = tour.copyWith(
      title: _titleController.text,
      content: _contentController.text,
      cost: double.tryParse(_costController.text),
      numOfMember: int.tryParse(_numOfMemberController.text),
      totalDay: int.tryParse(_dayController.text),
    );
    _updateTour(context, tour);
    ApplicationUtility.showModalSelectLocationDialog(context,
        (selectedLocation) {
      var tour = _getContextTour(context);
      tour = tour.copyWith(location: selectedLocation);
      _updateTour(context, tour);
      Navigator.pop(context);
    });
  }

  @override
  bool get wantKeepAlive => true;
}
