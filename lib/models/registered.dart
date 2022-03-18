class Registered {

  final String? uid;

  Registered( this.uid );

}

class RegisteredData {

  final String? uid;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? photoUrl;
  final bool? isAnon;

  RegisteredData( this.uid, this.name, this.email, this.phoneNumber, this.photoUrl, this.isAnon );
}