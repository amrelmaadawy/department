import '../../domain/entities/settings_entity.dart';

class SettingsModel extends SettingsEntity {
  const SettingsModel({
    required super.siteName,
    super.siteSubtitle,
    required super.siteDescription,
    required super.siteLogo,
    required super.contactPhone,
    required super.contactEmail,
    required super.companyAddress,
    required super.companyCr,
    required super.companyVat,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      siteName: json['site_name'] ?? '',
      siteSubtitle: json['site_subtitle'],
      siteDescription: json['site_description'] ?? '',
      siteLogo: json['site_logo'] ?? '',
      contactPhone: json['contact_phone'] ?? '',
      contactEmail: json['contact_email'] ?? '',
      companyAddress: json['company_address'] ?? '',
      companyCr: json['company_cr'] ?? '',
      companyVat: json['company_vat'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'site_name': siteName,
      'site_subtitle': siteSubtitle,
      'site_description': siteDescription,
      'site_logo': siteLogo,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'company_address': companyAddress,
      'company_cr': companyCr,
      'company_vat': companyVat,
    };
  }
}
