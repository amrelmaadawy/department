class UpdateProfileParams {
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? bio;
  final String? avatarPath;

  const UpdateProfileParams({
    this.name,
    this.email,
    this.phone,
    this.address,
    this.bio,
    this.avatarPath,
  });

  Map<String, dynamic> toMap() {
    return {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (bio != null) 'bio': bio,
    };
  }
}
