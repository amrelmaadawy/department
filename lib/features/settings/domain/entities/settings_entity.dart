import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
  final String siteName;
  final String? siteSubtitle;
  final String siteDescription;
  final String siteLogo;
  final String contactPhone;
  final String contactEmail;
  final String companyAddress;
  final String companyCr;
  final String companyVat;

  const SettingsEntity({
    required this.siteName,
    this.siteSubtitle,
    required this.siteDescription,
    required this.siteLogo,
    required this.contactPhone,
    required this.contactEmail,
    required this.companyAddress,
    required this.companyCr,
    required this.companyVat,
  });

  @override
  List<Object?> get props => [
        siteName,
        siteSubtitle,
        siteDescription,
        siteLogo,
        contactPhone,
        contactEmail,
        companyAddress,
        companyCr,
        companyVat,
      ];
}
