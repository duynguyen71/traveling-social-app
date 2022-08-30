class CreateChatGroup {
  Set<String> usernames = {};
  Set<int> ids = {};
  String? groupName;

  Map<String, dynamic> toJson() {
    // return {}.putIfAbsent('name', () => groupName.toString())
    //   ..putIfAbsent('usernames', () => usernames.toString())
    //   ..putIfAbsent('ids', () => ids.toString());
    Map<String, dynamic> map = <String, dynamic>{};
    map['groupNames'] = groupName;
    map['userIds'] = ids;
    map['names'] = ['khanhduy21123', 'khanhduy21122'];
    return map;
  }
}
