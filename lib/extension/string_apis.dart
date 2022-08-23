extension StringValidations on String? {
  bool get isNullOrBlank =>
      this == null || this!.isEmpty || this!.trim().isEmpty;
}
