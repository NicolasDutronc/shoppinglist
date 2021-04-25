class HubMessage {
  String _type;
  int _id;
  dynamic _msg;

  HubMessage(this._type, this._id, this._msg);

  String get type => _type;

  int get id => _id;

  dynamic get msg => _msg;

  HubMessage.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    _id = json['id'];
    _msg = json['message'];
  }

  @override
  String toString() => 'Message --> type : $type, id: $id, msg: $msg';
}
