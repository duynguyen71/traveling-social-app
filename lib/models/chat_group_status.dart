enum ChatGroupStatus {
  join('JOIN'),
  leave('LEAVE'),
  sent('SENT'),
  typing('TYPING'),
  none("NONE");

  const ChatGroupStatus(this.value);

  final String value;
}
