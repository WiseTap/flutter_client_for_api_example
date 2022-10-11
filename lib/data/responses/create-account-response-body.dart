



class CreateAccountResBody {
  late final String status;
  late final String uid;

  CreateAccountResBody({required this.status, required this.uid});

  CreateAccountResBody.fromMap (map) {
    status = map['status'];
    uid = map['uid'];
  }
}