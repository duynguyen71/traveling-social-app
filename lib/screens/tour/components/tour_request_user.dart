import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/tour/user_tour_bloc.dart';
import '../../../models/group.dart';
import '../../../models/tour_user.dart';
import '../../../services/chat_service.dart';
import '../../../services/post_service.dart';
import '../../../utilities/application_utility.dart';
import '../../../widgets/text_title.dart';
import '../../../widgets/user_avt.dart';
import '../../message/chat_screen.dart';
import '../../profile/profile_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TourRequestUser extends StatefulWidget {
  const TourRequestUser({Key? key, required this.tourId}) : super(key: key);

  final int tourId;

  @override
  State<TourRequestUser> createState() => _TourRequestUserState();
}

class _TourRequestUserState extends State<TourRequestUser> {
  final _postService = PostService();
  List<TourUser> _tourUsers = [];
  List<TourUser> _filtered = [];
  int _selectedSort = 3;

  bool _isLoading = false;

  set isLoading(bool i) => setState(() => _isLoading = i);

  set selectedSort(int sort) {
    setState(() {
      _selectedSort = sort;
    });
    switch (sort) {
      case 0:
        {
          filtered =
              _tourUsers.where((element) => element.status == 0).toList();
          break;
        }
      case 1:
        {
          filtered =
              _tourUsers.where((element) => element.status == 1).toList();
          break;
        }
      case 2:
        {
          filtered =
              _tourUsers.where((element) => element.status == 2).toList();
          break;
        }
      default:
        filtered = _tourUsers;
    }
  }

  set filtered(List<TourUser> list) => setState(() {
        _filtered = list;
      });

  set tourUsers(List<TourUser> list) => setState(() {
        _tourUsers = list;
      });

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _postService.getTourUsers(widget.tourId).then((value) {
      setState(() {
        _tourUsers = value;
        _filtered = value;
      });
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
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
                automaticallyImplyLeading: false,
                title: const TextTitle(text: "Tour users"),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Colors.grey.shade100,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButton(
                            elevation: 0,
                            value: _selectedSort,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 20,
                            underline: SizedBox(),
                            onChanged: (newValue) {
                              selectedSort = newValue as int;
                            },
                            items: [
                              DropdownMenuItem(
                                child: Text('Đã từ chối'),
                                value: 0,
                              ),
                              DropdownMenuItem(
                                child: Text('Yêu cầu'),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: Text('Đã duyệt'),
                                value: 2,
                              ),
                              DropdownMenuItem(
                                child: Text('Tất cả'),
                                value: 3,
                              ),
                            ]),
                      ),
                    ),
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
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: [
                      ListView(
                        shrinkWrap: true,
                        children: [
                          _isLoading
                              ? const Center(
                                  child: CupertinoActivityIndicator(),
                                )
                              : const SizedBox.shrink(),
                          ListView.builder(
                            itemBuilder: (context, index) {
                              var tourUser = _filtered[index];
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade100))),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child: Row(
                                  children: [
                                    UserAvatar(
                                      size: 40,
                                      avt: tourUser.user?.avt,
                                      onTap: () => Navigator.push(
                                        context,
                                        ProfileScreen.route(tourUser.user!.id!),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: Text(
                                            tourUser.user?.username ?? '')),
                                    TextButton(
                                      onPressed: () {
                                        switch (tourUser.status) {
                                          //Yeu cau
                                          case 1:
                                            {
                                              _handleRequestingStatus(
                                                  context, tourUser);
                                              break;
                                            }
                                          case 2:
                                            {
                                              _handleAccepted(
                                                  context, tourUser);
                                              break;
                                            }
                                          case 0:
                                            {
                                              _handleRejected(
                                                  context, tourUser);
                                              break;
                                            }
                                        }
                                      },
                                      child: _buildButton(tourUser),
                                      style: TextButton.styleFrom(
                                        elevation: 0,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        minimumSize: const Size(100, 30),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            shrinkWrap: true,
                            itemCount: _filtered.length,
                          )
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
      expand: false,
      minChildSize: .5,
      initialChildSize: .9,
      maxChildSize: .9,
    );
  }

  void _handleAccepted(BuildContext context, TourUser tourUser) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(
              '${tourUser.user?.username} đã được duyệt vào lúc ${ApplicationUtility.formatDate(tourUser.createDate, formatPattern: "dd-MMM HH:ss", locale: Localizations.localeOf(context))}'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _navigateToChat(
                    userId: tourUser.user!.id!,
                    username: tourUser.user!.username!);
              },
              child: Text('Nhắn tin'),
            ),
            CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      ProfileScreen.route(
                        tourUser.user!.id!,
                      ));
                },
                child: Text(
                    'Xem trang cá nhân @${tourUser?.user?.username ?? ''}')),
            CupertinoActionSheetAction(
              onPressed: () async {
                await _rejectUser(tourUser, context);
                context.read<UserTourBloc>().add(RejectUser(tourUser!.id!));
                _updateClientStatus(tourUser, status: 0);
              },
              child: const Text('Bỏ duyệt'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop("Hủy");
            },
            isDefaultAction: true,
            child: const Text(
              'Hủy',
            ),
          ),
          // title: const Text('duy nguyen posts'),
        );
      },
    );
  }

  void _handleRejected(BuildContext context, TourUser tourUser) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(
              'Bạn đã từ chối ${tourUser.user?.username} vào lúc ${ApplicationUtility.formatDate(tourUser.createDate, formatPattern: "dd-MMM HH:ss", locale: Localizations.localeOf(context))}'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                bool success = await _updateStatus(tourUser, status: 2);
                if (success) {
                  context
                      .read<UserTourBloc>()
                      .add(AcceptTourUserEvent(tourUser));
                  _updateClientStatus(tourUser, status: 2);
                  Navigator.pop(context);
                } else {
                  await _showAlerDialog(
                      "User ${tourUser?.user?.username ?? ''} đã tham giam vào chuyến đi khác trong lúc chờ bạn duyệt!");
                  context.read<UserTourBloc>().add(RejectUser(tourUser!.id!));
                  var copy = _tourUsers
                      .where((element) => element.id != tourUser?.id)
                      .toList();
                  tourUsers = copy;
                  filtered = copy;
                  Navigator.pop(context);
                }
              },
              child: Text('Duyệt lại'),
            ),
            CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    ProfileScreen.route(
                      tourUser.user!.id!,
                    ),
                  );
                },
                child: Text(
                    'Xem trang cá nhân @${tourUser?.user?.username ?? ''}')),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop("Hủy");
            },
            isDefaultAction: true,
            child: const Text(
              'Hủy',
            ),
          ),
          // title: const Text('duy nguyen posts'),
        );
      },
    );
  }

  void _handleRequestingStatus(BuildContext context, TourUser tourUser) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(
              '${tourUser.user?.username} đã yêu cầu tham gia vào lúc ${ApplicationUtility.formatDate(tourUser.createDate, formatPattern: "dd-MMM HH:ss", locale: Localizations.localeOf(context))}'),
          actions: [
            // DUYỆT NGƯỜI THAM GIA
            CupertinoActionSheetAction(
                onPressed: () async {
                  bool success = await _updateStatus(tourUser, status: 2);
                  if (success) {
                    context
                        .read<UserTourBloc>()
                        .add(AcceptTourUserEvent(tourUser));
                    _updateClientStatus(tourUser, status: 2);
                    Navigator.pop(context);
                  } else {
                    await _showAlerDialog(
                        "User ${tourUser?.user?.username ?? ''} đã tham giam vào chuyến đi khác trong lúc chờ bạn duyệt!");
                    context.read<UserTourBloc>().add(RejectUser(tourUser!.id!));
                    var copy = _tourUsers
                        .where((element) => element.id != tourUser?.id)
                        .toList();
                    tourUsers = copy;
                    filtered = copy;
                    Navigator.pop(context);
                  }
                },
                child: const Text('Duyệt')),
            CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    ProfileScreen.route(
                      tourUser.user!.id!,
                    ),
                  );
                },
                child: Text(
                    'Xem trang cá nhân @${tourUser?.user?.username ?? ''}')),
            CupertinoActionSheetAction(
                onPressed: () async {
                  await _rejectUser(tourUser, context);
                },
                child: const Text('Từ chối')),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop("Hủy");
            },
            isDefaultAction: true,
            child: const Text(
              'Hủy',
            ),
          ),
          // title: const Text('duy nguyen posts'),
        );
      },
    );
  }

  // Bỏ duyệt hoặc từ chối yêu cầu
  Future<void> _rejectUser(TourUser tourUser, BuildContext context) async {
    await _updateStatus(tourUser, status: 0);
    _updateClientStatus(tourUser, status: 0);
    context.read<UserTourBloc>().add(RejectUser(tourUser.id!));
    Navigator.pop(context);
  }

  void _updateClientStatus(TourUser tourUser, {required int status}) {
    List<TourUser> copy = _tourUsers
        .map((element) => element.id == tourUser.id
            ? element.copyWithStatus(status: status)
            : element)
        .toList();
    tourUsers = copy;
    filtered = copy;
  }

  //
  // void _removeTourUser(TourUser tourUser) {
  //   var copy =
  //       _tourUsers.where((element) => element.id != tourUser?.id).toList();
  //   tourUsers = copy;
  //   filtered = copy;
  // }

  Future<bool> _updateStatus(TourUser tourUser, {required int status}) async {
    bool success = await _postService.updateTourUserStatus(
        status: status, tourUserId: tourUser.id);
    return success;
  }

  _navigateToChat({required int userId, required String username}) async {
    var chatService = ChatService();
    Group? chatGroup = await chatService.getChatGroupBetweenTwoUsers(userId);
    if (chatGroup != null) {
      Navigator.push(
          context, ChatScreen.route(groupId: chatGroup.id!, name: username));
    }
  }

  _showAlerDialog(String message) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          //TODO: translate
          title: Text(
            AppLocalizations.of(context)!.notification,
          ),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Xác nhận"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Text _buildButton(TourUser tourUser) {
    var button = '';
    switch (tourUser.status) {
      case 0:
        {
          button = 'Rejected';
          break;
        }
      case 1:
        {
          button = 'Requested';
          break;
        }
      case 2:
        {
          button = 'Accept';
          break;
        }
      default:
        button = 'Rejected';
    }
    return Text(
      button,
      textAlign: TextAlign.start,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          color: Colors.black87,
          letterSpacing: .6,
          fontWeight: FontWeight.w500,
          fontSize: 12),
    );
  }
}
