class Group {
  int? idGroup;
  String description;
  int status;

  Group({
    this.idGroup,
    required this.description,
    required this.status,
  });

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      idGroup: map['id_group'],
      description: map['gp_description'],
      status: map['gp_status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_group': idGroup,
      'gp_description': description,
      'gp_status': status,
    };
  }
}
