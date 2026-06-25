import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @aboutProject.
  ///
  /// In en, this message translates to:
  /// **'About Project'**
  String get aboutProject;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @agentRole.
  ///
  /// In en, this message translates to:
  /// **'Senior Support Engineer'**
  String get agentRole;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @aiFeatureUnderDevelopment.
  ///
  /// In en, this message translates to:
  /// **'This feature is currently under development.\nSoon you will be able to design your apartment and see it in VR before execution!'**
  String get aiFeatureUnderDevelopment;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @answerQuestionsForAI.
  ///
  /// In en, this message translates to:
  /// **'Answer a few questions and we\'ll generate a complete interior design customized to your taste.'**
  String get answerQuestionsForAI;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @appNotifications.
  ///
  /// In en, this message translates to:
  /// **'App Notifications'**
  String get appNotifications;

  /// No description provided for @appNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Alerts about unit status and installments'**
  String get appNotificationsDesc;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyFilters;

  /// No description provided for @arabicLang.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabicLang;

  /// No description provided for @areaSquareMeters.
  ///
  /// In en, this message translates to:
  /// **'Area: {area} m²'**
  String areaSquareMeters(String area);

  /// No description provided for @availablePaths.
  ///
  /// In en, this message translates to:
  /// **'Available Paths'**
  String get availablePaths;

  /// No description provided for @basedOnLuxuryPackage.
  ///
  /// In en, this message translates to:
  /// **'Based on luxury package'**
  String get basedOnLuxuryPackage;

  /// No description provided for @basicUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Basic Unit Price'**
  String get basicUnitPrice;

  /// No description provided for @bathroomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Baths'**
  String get bathroomsLabel;

  /// No description provided for @beechWoodDoors.
  ///
  /// In en, this message translates to:
  /// **'Beech Wood Doors'**
  String get beechWoodDoors;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @biometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get biometricLogin;

  /// No description provided for @biometricLoginDesc.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face to login quickly'**
  String get biometricLoginDesc;

  /// No description provided for @bookUnit.
  ///
  /// In en, this message translates to:
  /// **'Book Unit'**
  String get bookUnit;

  /// No description provided for @bookUnitBtn.
  ///
  /// In en, this message translates to:
  /// **'Book Unit'**
  String get bookUnitBtn;

  /// No description provided for @bookingError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during confirmation, please try again.'**
  String get bookingError;

  /// No description provided for @bookingSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You have started your home finishing journey. Our engineer will contact you within 24 hours.'**
  String get bookingSuccessSubtitle;

  /// No description provided for @bookingSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed successfully!'**
  String get bookingSuccessTitle;

  /// No description provided for @browseFinishingPackages.
  ///
  /// In en, this message translates to:
  /// **'Browse Finishing Packages'**
  String get browseFinishingPackages;

  /// No description provided for @buildDreamHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s build your dream home with the latest design technologies.'**
  String get buildDreamHomeSubtitle;

  /// No description provided for @categoryCeilings.
  ///
  /// In en, this message translates to:
  /// **'Ceilings'**
  String get categoryCeilings;

  /// No description provided for @categoryDoors.
  ///
  /// In en, this message translates to:
  /// **'Doors'**
  String get categoryDoors;

  /// No description provided for @categoryFloors.
  ///
  /// In en, this message translates to:
  /// **'Floors'**
  String get categoryFloors;

  /// No description provided for @categoryReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get categoryReview;

  /// No description provided for @categoryWalls.
  ///
  /// In en, this message translates to:
  /// **'Walls'**
  String get categoryWalls;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @chooseCeilingType.
  ///
  /// In en, this message translates to:
  /// **'Choose Ceiling Type'**
  String get chooseCeilingType;

  /// No description provided for @chooseDoorType.
  ///
  /// In en, this message translates to:
  /// **'Choose Door Type'**
  String get chooseDoorType;

  /// No description provided for @chooseFloorType.
  ///
  /// In en, this message translates to:
  /// **'Choose Floor Type'**
  String get chooseFloorType;

  /// No description provided for @chooseUnit.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Unit'**
  String get chooseUnit;

  /// No description provided for @chooseWallType.
  ///
  /// In en, this message translates to:
  /// **'Choose Wall Type'**
  String get chooseWallType;

  /// No description provided for @classicTag.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get classicTag;

  /// No description provided for @clearComparison.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearComparison;

  /// No description provided for @clearSignature.
  ///
  /// In en, this message translates to:
  /// **'Clear Signature'**
  String get clearSignature;

  /// No description provided for @closeGallery.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeGallery;

  /// No description provided for @compareNow.
  ///
  /// In en, this message translates to:
  /// **'Compare Now'**
  String get compareNow;

  /// No description provided for @compareUnits.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compareUnits;

  /// No description provided for @comparisonArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get comparisonArea;

  /// No description provided for @comparisonBaths.
  ///
  /// In en, this message translates to:
  /// **'Baths'**
  String get comparisonBaths;

  /// No description provided for @comparisonFloor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get comparisonFloor;

  /// No description provided for @comparisonPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get comparisonPrice;

  /// No description provided for @comparisonRooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get comparisonRooms;

  /// No description provided for @comparisonStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get comparisonStatus;

  /// No description provided for @comparisonType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get comparisonType;

  /// No description provided for @completeBookingAndPayment.
  ///
  /// In en, this message translates to:
  /// **'Complete Booking & Payment'**
  String get completeBookingAndPayment;

  /// No description provided for @confirmAndGenerateContracts.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Generate Contracts'**
  String get confirmAndGenerateContracts;

  /// No description provided for @confirmBookingAndProceed.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking & Proceed'**
  String get confirmBookingAndProceed;

  /// No description provided for @confirmBookingBtn.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Continue Booking'**
  String get confirmBookingBtn;

  /// No description provided for @confirmContractDraftNote.
  ///
  /// In en, this message translates to:
  /// **'By clicking confirm, a final contract draft will be generated for final review before signing.'**
  String get confirmContractDraftNote;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmReturnContracts.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Return to Contracts'**
  String get confirmReturnContracts;

  /// No description provided for @contractBtn.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get contractBtn;

  /// No description provided for @contractDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Contract Date'**
  String get contractDateLabel;

  /// No description provided for @contractDetails.
  ///
  /// In en, this message translates to:
  /// **'Contract Details'**
  String get contractDetails;

  /// No description provided for @contractGeneratedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Contract generated successfully and verified with your electronic signature. You can save a copy or proceed.'**
  String get contractGeneratedSuccess;

  /// No description provided for @contractScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Unit'**
  String get contractScreenTitle;

  /// No description provided for @contractStatusVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified & Approved'**
  String get contractStatusVerified;

  /// No description provided for @contractTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contract Terms & Conditions'**
  String get contractTermsTitle;

  /// No description provided for @contractsRequiredForSignature.
  ///
  /// In en, this message translates to:
  /// **'Contracts Required For Signature'**
  String get contractsRequiredForSignature;

  /// No description provided for @costDetails.
  ///
  /// In en, this message translates to:
  /// **'Cost Details'**
  String get costDetails;

  /// No description provided for @costEstimateTitle.
  ///
  /// In en, this message translates to:
  /// **'Cost Estimation'**
  String get costEstimateTitle;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @customFinishing.
  ///
  /// In en, this message translates to:
  /// **'Custom Finishing'**
  String get customFinishing;

  /// No description provided for @customFinishingComprehensive.
  ///
  /// In en, this message translates to:
  /// **'Custom finishing including materials and labor'**
  String get customFinishingComprehensive;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Change app colors to reduce eye strain'**
  String get darkModeDesc;

  /// No description provided for @deliveryDate.
  ///
  /// In en, this message translates to:
  /// **'Delivery Date'**
  String get deliveryDate;

  /// No description provided for @designAndBookUnit.
  ///
  /// In en, this message translates to:
  /// **'Design and Book Your Unit'**
  String get designAndBookUnit;

  /// No description provided for @designForTitle.
  ///
  /// In en, this message translates to:
  /// **'Design for: {title}'**
  String designForTitle(String title);

  /// No description provided for @designLab.
  ///
  /// In en, this message translates to:
  /// **'Design Lab'**
  String get designLab;

  /// No description provided for @designStudio.
  ///
  /// In en, this message translates to:
  /// **'Design Studio'**
  String get designStudio;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @discoverStyleAI.
  ///
  /// In en, this message translates to:
  /// **'Discover your style with AI'**
  String get discoverStyleAI;

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// No description provided for @durableDoorsClassicDesigns.
  ///
  /// In en, this message translates to:
  /// **'Durable doors with classic designs'**
  String get durableDoorsClassicDesigns;

  /// No description provided for @economicalTag.
  ///
  /// In en, this message translates to:
  /// **'Economical'**
  String get economicalTag;

  /// No description provided for @editSelectionsBtn.
  ///
  /// In en, this message translates to:
  /// **'Edit Selections'**
  String get editSelectionsBtn;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @errAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the terms and conditions first.'**
  String get errAgreeTerms;

  /// No description provided for @errSignBox.
  ///
  /// In en, this message translates to:
  /// **'Please draw your signature in the designated box.'**
  String get errSignBox;

  /// No description provided for @estimatedAreaNoUnit.
  ///
  /// In en, this message translates to:
  /// **'Estimated Area (No Unit)'**
  String get estimatedAreaNoUnit;

  /// No description provided for @estimatedAreaTitle.
  ///
  /// In en, this message translates to:
  /// **'Estimated Area ({area} m²)'**
  String estimatedAreaTitle(String area);

  /// No description provided for @estimatedFinishingCost.
  ///
  /// In en, this message translates to:
  /// **'Estimated Finishing Cost'**
  String get estimatedFinishingCost;

  /// No description provided for @executionSupervision.
  ///
  /// In en, this message translates to:
  /// **'Execution Supervision'**
  String get executionSupervision;

  /// No description provided for @executionSupervisionDesc.
  ///
  /// In en, this message translates to:
  /// **'A team of expert engineers to monitor progress on-site, ensuring execution perfectly matches designs with top quality.'**
  String get executionSupervisionDesc;

  /// No description provided for @expectedVisitDate.
  ///
  /// In en, this message translates to:
  /// **'Expected Visit Date'**
  String get expectedVisitDate;

  /// No description provided for @exploreAsHost.
  ///
  /// In en, this message translates to:
  /// **'Explore as a host'**
  String get exploreAsHost;

  /// No description provided for @exploreProjects.
  ///
  /// In en, this message translates to:
  /// **'Explore Projects'**
  String get exploreProjects;

  /// No description provided for @exploreTailoredPackages.
  ///
  /// In en, this message translates to:
  /// **'Explore ready-made and carefully tailored packages to suit your needs.'**
  String get exploreTailoredPackages;

  /// No description provided for @faqSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse categories for quick solutions'**
  String get faqSubtitle;

  /// No description provided for @faqTitle.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faqTitle;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This feature will be added soon!'**
  String get featureComingSoon;

  /// No description provided for @featuredProjects.
  ///
  /// In en, this message translates to:
  /// **'Featured Projects'**
  String get featuredProjects;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterApartment.
  ///
  /// In en, this message translates to:
  /// **'Apartments'**
  String get filterApartment;

  /// No description provided for @filterByProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get filterByProject;

  /// No description provided for @filterByStyle.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get filterByStyle;

  /// No description provided for @filterDuplex.
  ///
  /// In en, this message translates to:
  /// **'Duplex'**
  String get filterDuplex;

  /// No description provided for @filterEastern.
  ///
  /// In en, this message translates to:
  /// **'Eastern Prov.'**
  String get filterEastern;

  /// No description provided for @filterJeddah.
  ///
  /// In en, this message translates to:
  /// **'Jeddah'**
  String get filterJeddah;

  /// No description provided for @filterVilla.
  ///
  /// In en, this message translates to:
  /// **'Villas'**
  String get filterVilla;

  /// No description provided for @finalApproval.
  ///
  /// In en, this message translates to:
  /// **'Final Approval'**
  String get finalApproval;

  /// No description provided for @finalCustomizationReview.
  ///
  /// In en, this message translates to:
  /// **'Final Customization Review'**
  String get finalCustomizationReview;

  /// No description provided for @finalTotalCost.
  ///
  /// In en, this message translates to:
  /// **'Final Total Cost'**
  String get finalTotalCost;

  /// No description provided for @financialSummary.
  ///
  /// In en, this message translates to:
  /// **'Financial Summary'**
  String get financialSummary;

  /// No description provided for @finishItYourWay.
  ///
  /// In en, this message translates to:
  /// **'Finish It Your Way'**
  String get finishItYourWay;

  /// No description provided for @finishingContract.
  ///
  /// In en, this message translates to:
  /// **'Finishing Contract'**
  String get finishingContract;

  /// No description provided for @finishingContractSummary.
  ///
  /// In en, this message translates to:
  /// **'Finishing Contract Summary'**
  String get finishingContractSummary;

  /// No description provided for @finishingContractTerms.
  ///
  /// In en, this message translates to:
  /// **'1. The contractor undertakes to execute finishing works according to approved specifications.\n2. Prices include supply of materials and labor.\n3. Client commits to paying installments based on agreed completion percentages.\n4. Contractor guarantees quality of work for one full year.\n5. Any design modifications after execution starts are subject to separate pricing.\n... [More Legal Terms]'**
  String get finishingContractTerms;

  /// No description provided for @finishingProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Finishing Progress'**
  String get finishingProgressTitle;

  /// No description provided for @finishingType.
  ///
  /// In en, this message translates to:
  /// **'Finishing Type'**
  String get finishingType;

  /// No description provided for @flatCeilingWithHiddenLighting.
  ///
  /// In en, this message translates to:
  /// **'Flat ceiling with hidden lighting'**
  String get flatCeilingWithHiddenLighting;

  /// No description provided for @flatGypsumBoard.
  ///
  /// In en, this message translates to:
  /// **'Flat Gypsum Board'**
  String get flatGypsumBoard;

  /// No description provided for @floor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get floor;

  /// No description provided for @floorDesc.
  ///
  /// In en, this message translates to:
  /// **'Floor {floorVal}'**
  String floorDesc(String floorVal);

  /// No description provided for @floorLabel.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get floorLabel;

  /// No description provided for @forInitialCostEstimateOnly.
  ///
  /// In en, this message translates to:
  /// **'For initial cost estimate only'**
  String get forInitialCostEstimateOnly;

  /// No description provided for @frenchWallpaper.
  ///
  /// In en, this message translates to:
  /// **'French Wallpaper'**
  String get frenchWallpaper;

  /// No description provided for @fullCustomFinishing.
  ///
  /// In en, this message translates to:
  /// **'Full Custom Finishing'**
  String get fullCustomFinishing;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @generatingPdf.
  ///
  /// In en, this message translates to:
  /// **'Preparing file...'**
  String get generatingPdf;

  /// No description provided for @germanParquet.
  ///
  /// In en, this message translates to:
  /// **'German Parquet'**
  String get germanParquet;

  /// No description provided for @germanParquetDesc.
  ///
  /// In en, this message translates to:
  /// **'Adds warmth and natural elegance to the space, suitable for bedrooms.'**
  String get germanParquetDesc;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String helloUser(String name);

  /// No description provided for @highQualityWashablePaint.
  ///
  /// In en, this message translates to:
  /// **'High-quality washable paint'**
  String get highQualityWashablePaint;

  /// No description provided for @iAgreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms and conditions'**
  String get iAgreeToTerms;

  /// No description provided for @imageCountOf.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String imageCountOf(String current, String total);

  /// No description provided for @inProgressNow.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgressNow;

  /// No description provided for @interiorDesignPackages.
  ///
  /// In en, this message translates to:
  /// **'Interior Design Packages'**
  String get interiorDesignPackages;

  /// No description provided for @interiorDesignPackagesDesc.
  ///
  /// In en, this message translates to:
  /// **'Customized packages designed to suit your taste, from initial layouts to the finest technical details.'**
  String get interiorDesignPackagesDesc;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// No description provided for @italianMarble.
  ///
  /// In en, this message translates to:
  /// **'Italian Marble'**
  String get italianMarble;

  /// No description provided for @italianMarbleDesc.
  ///
  /// In en, this message translates to:
  /// **'Provides a luxurious feel and cool touch. Ideal for open spaces.'**
  String get italianMarbleDesc;

  /// No description provided for @jotunFenomasticPaint.
  ///
  /// In en, this message translates to:
  /// **'Jotun Fenomastic Paint'**
  String get jotunFenomasticPaint;

  /// No description provided for @liveBadge.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get liveBadge;

  /// No description provided for @loadingStatus.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingStatus;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged in Successfully!'**
  String get loginSuccess;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged out Successfully!'**
  String get logoutSuccess;

  /// No description provided for @luxuriousClassicDesigns.
  ///
  /// In en, this message translates to:
  /// **'Luxurious classic designs'**
  String get luxuriousClassicDesigns;

  /// No description provided for @luxuriousTag.
  ///
  /// In en, this message translates to:
  /// **'Luxurious'**
  String get luxuriousTag;

  /// No description provided for @materialSelection.
  ///
  /// In en, this message translates to:
  /// **'Material Selection'**
  String get materialSelection;

  /// No description provided for @maxUnitsReached.
  ///
  /// In en, this message translates to:
  /// **'You can compare up to 3 units only'**
  String get maxUnitsReached;

  /// No description provided for @million.
  ///
  /// In en, this message translates to:
  /// **'Million'**
  String get million;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumber;

  /// No description provided for @modernTag.
  ///
  /// In en, this message translates to:
  /// **'Modern'**
  String get modernTag;

  /// No description provided for @myContracts.
  ///
  /// In en, this message translates to:
  /// **'My Contracts'**
  String get myContracts;

  /// No description provided for @myDesigns.
  ///
  /// In en, this message translates to:
  /// **'My Designs'**
  String get myDesigns;

  /// No description provided for @mySavedDesigns.
  ///
  /// In en, this message translates to:
  /// **'My Saved Designs'**
  String get mySavedDesigns;

  /// No description provided for @myUnits.
  ///
  /// In en, this message translates to:
  /// **'My Units'**
  String get myUnits;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @navDesign.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get navDesign;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get navProjects;

  /// No description provided for @navProposals.
  ///
  /// In en, this message translates to:
  /// **'Proposals'**
  String get navProposals;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @newestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get newestFirst;

  /// No description provided for @newsletter.
  ///
  /// In en, this message translates to:
  /// **'Newsletter'**
  String get newsletter;

  /// No description provided for @newsletterDesc.
  ///
  /// In en, this message translates to:
  /// **'Updates on new projects and offers'**
  String get newsletterDesc;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @noDesignsFound.
  ///
  /// In en, this message translates to:
  /// **'No designs match your search'**
  String get noDesignsFound;

  /// No description provided for @noProjectsFound.
  ///
  /// In en, this message translates to:
  /// **'No projects found'**
  String get noProjectsFound;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @okWaitingForIt.
  ///
  /// In en, this message translates to:
  /// **'OK, waiting for it'**
  String get okWaitingForIt;

  /// No description provided for @oldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get oldestFirst;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Explore an exclusive collection of luxury properties tailored to your refined taste.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Choose materials, modify designs, and get instant costs in a unique interactive experience.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Relax while we transform your plans into an architectural masterpiece with the highest quality standards.'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Discover your ideal space'**
  String get onboardingTitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Design your home smoothly'**
  String get onboardingTitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Hotel standard execution'**
  String get onboardingTitle3;

  /// No description provided for @onlineNow.
  ///
  /// In en, this message translates to:
  /// **'Online Now'**
  String get onlineNow;

  /// No description provided for @orVia.
  ///
  /// In en, this message translates to:
  /// **'Or via'**
  String get orVia;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get orderNumber;

  /// No description provided for @orderNumberCopiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Order number copied successfully'**
  String get orderNumberCopiedSuccessfully;

  /// No description provided for @ourServices.
  ///
  /// In en, this message translates to:
  /// **'Our Services'**
  String get ourServices;

  /// No description provided for @ourServicesDesc.
  ///
  /// In en, this message translates to:
  /// **'We offer a comprehensive range of luxury finishing and decoration services, turning your space into a masterpiece that meets the highest expectations.'**
  String get ourServicesDesc;

  /// No description provided for @overviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overviewTitle;

  /// No description provided for @ownerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get ownerNameLabel;

  /// No description provided for @paidAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid (Down Payment + Installments)'**
  String get paidAmountLabel;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @practicalTag.
  ///
  /// In en, this message translates to:
  /// **'Practical'**
  String get practicalTag;

  /// No description provided for @premiumCustomer.
  ///
  /// In en, this message translates to:
  /// **'Premium Customer'**
  String get premiumCustomer;

  /// No description provided for @pricePerSqm.
  ///
  /// In en, this message translates to:
  /// **'SAR / sqm'**
  String get pricePerSqm;

  /// No description provided for @priceTitle.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get priceTitle;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @profileMenuContactSales.
  ///
  /// In en, this message translates to:
  /// **'Contact Sales'**
  String get profileMenuContactSales;

  /// No description provided for @profileMenuEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Personal Data'**
  String get profileMenuEditProfile;

  /// No description provided for @profileMenuHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get profileMenuHelpCenter;

  /// No description provided for @profileMenuInstallments.
  ///
  /// In en, this message translates to:
  /// **'Installments & Payments'**
  String get profileMenuInstallments;

  /// No description provided for @profileMenuMyUnits.
  ///
  /// In en, this message translates to:
  /// **'Reserved Units'**
  String get profileMenuMyUnits;

  /// No description provided for @profileMenuSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security & Password'**
  String get profileMenuSecurity;

  /// No description provided for @profileSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get profileSectionAccount;

  /// No description provided for @profileSectionApp.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get profileSectionApp;

  /// No description provided for @profileSectionRealEstate.
  ///
  /// In en, this message translates to:
  /// **'Real Estate Management'**
  String get profileSectionRealEstate;

  /// No description provided for @profileSectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Support & Help'**
  String get profileSectionSupport;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get profileTitle;

  /// No description provided for @project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// No description provided for @projectLabel.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get projectLabel;

  /// No description provided for @promoTitle.
  ///
  /// In en, this message translates to:
  /// **'Build your space..\nTo your taste'**
  String get promoTitle;

  /// No description provided for @propertySaleContract.
  ///
  /// In en, this message translates to:
  /// **'Property Sale Contract'**
  String get propertySaleContract;

  /// No description provided for @readyPackagesBtn.
  ///
  /// In en, this message translates to:
  /// **'Ready Packages'**
  String get readyPackagesBtn;

  /// No description provided for @readyPackagesScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready Packages'**
  String get readyPackagesScreenTitle;

  /// No description provided for @readyPackagesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the suitable package and modify it freely.. We designed multiple options to suit all needs and budgets.'**
  String get readyPackagesSubtitle;

  /// No description provided for @registerAgreement.
  ///
  /// In en, this message translates to:
  /// **'By registering, you agree to the'**
  String get registerAgreement;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account Created Successfully!'**
  String get registerSuccess;

  /// No description provided for @remainingAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remainingAmountLabel;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @returnToHomeBtn.
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get returnToHomeBtn;

  /// No description provided for @returnToSavedDesigns.
  ///
  /// In en, this message translates to:
  /// **'Return to view designs you\'ve previously saved.'**
  String get returnToSavedDesigns;

  /// No description provided for @reviewAndSignContracts.
  ///
  /// In en, this message translates to:
  /// **'Review & Sign Contracts'**
  String get reviewAndSignContracts;

  /// No description provided for @reviewNote.
  ///
  /// In en, this message translates to:
  /// **'Note: Displayed prices are estimated based on a standard area (100 sqm). Final measurements will be reviewed by the specialized engineer.'**
  String get reviewNote;

  /// No description provided for @reviewSelections.
  ///
  /// In en, this message translates to:
  /// **'Review Your Selections'**
  String get reviewSelections;

  /// No description provided for @reviewSelectionsAndConfirm.
  ///
  /// In en, this message translates to:
  /// **'Review your selections and confirm cost details before approving the contracts to ensure execution matches your desires.'**
  String get reviewSelectionsAndConfirm;

  /// No description provided for @riyadh.
  ///
  /// In en, this message translates to:
  /// **'Riyadh'**
  String get riyadh;

  /// No description provided for @roomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get roomsLabel;

  /// No description provided for @sar.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get sar;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @searchDesigns.
  ///
  /// In en, this message translates to:
  /// **'Search designs...'**
  String get searchDesigns;

  /// No description provided for @searchProject.
  ///
  /// In en, this message translates to:
  /// **'Search for a project or location'**
  String get searchProject;

  /// No description provided for @selectUnitToDesign.
  ///
  /// In en, this message translates to:
  /// **'Select Unit to Design'**
  String get selectUnitToDesign;

  /// No description provided for @selectUnitsToCompare.
  ///
  /// In en, this message translates to:
  /// **'Select units to compare (2-3 units)'**
  String get selectUnitsToCompare;

  /// No description provided for @selectionsSummary.
  ///
  /// In en, this message translates to:
  /// **'Selections Summary'**
  String get selectionsSummary;

  /// No description provided for @semiFinished.
  ///
  /// In en, this message translates to:
  /// **'(Semi-finished)'**
  String get semiFinished;

  /// No description provided for @serviceMaterialsDesc.
  ///
  /// In en, this message translates to:
  /// **'Assisting you in selecting the finest materials from top suppliers, aligning with your budget and approved design.'**
  String get serviceMaterialsDesc;

  /// No description provided for @shareDesign.
  ///
  /// In en, this message translates to:
  /// **'Share Design'**
  String get shareDesign;

  /// No description provided for @shareDesignText.
  ///
  /// In en, this message translates to:
  /// **'Check out this amazing design I generated for my unit using Shatebha Bkayfak App! 🏡✨'**
  String get shareDesignText;

  /// No description provided for @shareError.
  ///
  /// In en, this message translates to:
  /// **'Sorry, an error occurred while sharing the design.'**
  String get shareError;

  /// No description provided for @shareLoading.
  ///
  /// In en, this message translates to:
  /// **'Preparing design for sharing...'**
  String get shareLoading;

  /// No description provided for @signAbove.
  ///
  /// In en, this message translates to:
  /// **'Please sign inside the box above'**
  String get signAbove;

  /// No description provided for @signNow.
  ///
  /// In en, this message translates to:
  /// **'Sign Now'**
  String get signNow;

  /// No description provided for @signature.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get signature;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @smartVisualization.
  ///
  /// In en, this message translates to:
  /// **'Smart Visualization'**
  String get smartVisualization;

  /// No description provided for @smartVisualizationDesc.
  ///
  /// In en, this message translates to:
  /// **'Visualize your space before execution using AI and ultra-realistic 3D designs to ensure the perfect choice.'**
  String get smartVisualizationDesc;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @spanishPorcelain.
  ///
  /// In en, this message translates to:
  /// **'Spanish Porcelain'**
  String get spanishPorcelain;

  /// No description provided for @spanishPorcelainDesc.
  ///
  /// In en, this message translates to:
  /// **'High durability, variety in designs and colors, easy to clean.'**
  String get spanishPorcelainDesc;

  /// No description provided for @spcFlooring.
  ///
  /// In en, this message translates to:
  /// **'SPC Flooring'**
  String get spcFlooring;

  /// No description provided for @spcFlooringDesc.
  ///
  /// In en, this message translates to:
  /// **'Water and moisture resistant, practical and economical choice with a modern touch.'**
  String get spcFlooringDesc;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Your Signature Space'**
  String get splashTagline;

  /// No description provided for @srvBuyingDesc.
  ///
  /// In en, this message translates to:
  /// **'Helping you choose the best properties'**
  String get srvBuyingDesc;

  /// No description provided for @srvBuyingTitle.
  ///
  /// In en, this message translates to:
  /// **'Buying'**
  String get srvBuyingTitle;

  /// No description provided for @srvContractingDesc.
  ///
  /// In en, this message translates to:
  /// **'Professional execution, quality and commitment'**
  String get srvContractingDesc;

  /// No description provided for @srvContractingTitle.
  ///
  /// In en, this message translates to:
  /// **'Contracting'**
  String get srvContractingTitle;

  /// No description provided for @srvEContractsDesc.
  ///
  /// In en, this message translates to:
  /// **'Secure contracts with smart steps'**
  String get srvEContractsDesc;

  /// No description provided for @srvEContractsTitle.
  ///
  /// In en, this message translates to:
  /// **'E-Contracts'**
  String get srvEContractsTitle;

  /// No description provided for @srvInvestmentDesc.
  ///
  /// In en, this message translates to:
  /// **'Towards a promising real estate future'**
  String get srvInvestmentDesc;

  /// No description provided for @srvInvestmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get srvInvestmentTitle;

  /// No description provided for @srvLeasingDesc.
  ///
  /// In en, this message translates to:
  /// **'Reliable leasing solutions'**
  String get srvLeasingDesc;

  /// No description provided for @srvLeasingTitle.
  ///
  /// In en, this message translates to:
  /// **'Leasing'**
  String get srvLeasingTitle;

  /// No description provided for @srvMarketingDesc.
  ///
  /// In en, this message translates to:
  /// **'Reaching the best opportunities'**
  String get srvMarketingDesc;

  /// No description provided for @srvMarketingTitle.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get srvMarketingTitle;

  /// No description provided for @srvPropertyMgtDesc.
  ///
  /// In en, this message translates to:
  /// **'Professional management for lasting value'**
  String get srvPropertyMgtDesc;

  /// No description provided for @srvPropertyMgtTitle.
  ///
  /// In en, this message translates to:
  /// **'Property Management'**
  String get srvPropertyMgtTitle;

  /// No description provided for @srvRealEstateDevDesc.
  ///
  /// In en, this message translates to:
  /// **'Innovative visions for distinguished projects'**
  String get srvRealEstateDevDesc;

  /// No description provided for @srvRealEstateDevTitle.
  ///
  /// In en, this message translates to:
  /// **'Real Estate Dev.'**
  String get srvRealEstateDevTitle;

  /// No description provided for @srvSellingDesc.
  ///
  /// In en, this message translates to:
  /// **'Professional marketing for best prices'**
  String get srvSellingDesc;

  /// No description provided for @srvSellingTitle.
  ///
  /// In en, this message translates to:
  /// **'Selling'**
  String get srvSellingTitle;

  /// No description provided for @startExperience.
  ///
  /// In en, this message translates to:
  /// **'Start Experience'**
  String get startExperience;

  /// No description provided for @startFinishingBtn.
  ///
  /// In en, this message translates to:
  /// **'Start Finishing Yourself'**
  String get startFinishingBtn;

  /// No description provided for @startNow.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get startNow;

  /// No description provided for @startsFrom.
  ///
  /// In en, this message translates to:
  /// **'Starts from'**
  String get startsFrom;

  /// No description provided for @statusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get statusDelivered;

  /// No description provided for @statusFinishing.
  ///
  /// In en, this message translates to:
  /// **'Finishing'**
  String get statusFinishing;

  /// No description provided for @supportAgentName.
  ///
  /// In en, this message translates to:
  /// **'Sarah'**
  String get supportAgentName;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Support & Help'**
  String get supportTitle;

  /// No description provided for @tabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get tabOverview;

  /// No description provided for @tabServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get tabServices;

  /// No description provided for @tabUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get tabUnits;

  /// No description provided for @techSupport.
  ///
  /// In en, this message translates to:
  /// **'Technical Support'**
  String get techSupport;

  /// No description provided for @termsAgreementText.
  ///
  /// In en, this message translates to:
  /// **'By clicking confirm, you agree to the Terms and Conditions'**
  String get termsAgreementText;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @totalArea.
  ///
  /// In en, this message translates to:
  /// **'Total Area'**
  String get totalArea;

  /// No description provided for @totalContractValue.
  ///
  /// In en, this message translates to:
  /// **'Total Contract Value'**
  String get totalContractValue;

  /// No description provided for @totalEstimatedCost.
  ///
  /// In en, this message translates to:
  /// **'Total Estimated Cost'**
  String get totalEstimatedCost;

  /// No description provided for @totalExpectedCost.
  ///
  /// In en, this message translates to:
  /// **'Total Expected Cost'**
  String get totalExpectedCost;

  /// No description provided for @totalFinishingCost.
  ///
  /// In en, this message translates to:
  /// **'Total Finishing Cost'**
  String get totalFinishingCost;

  /// No description provided for @totalMaterials.
  ///
  /// In en, this message translates to:
  /// **'Total Materials'**
  String get totalMaterials;

  /// No description provided for @totalWorkmanship.
  ///
  /// In en, this message translates to:
  /// **'Total Workmanship'**
  String get totalWorkmanship;

  /// No description provided for @trackExecutionBtn.
  ///
  /// In en, this message translates to:
  /// **'Track Execution'**
  String get trackExecutionBtn;

  /// No description provided for @trackFinishing.
  ///
  /// In en, this message translates to:
  /// **'Track Finishing'**
  String get trackFinishing;

  /// No description provided for @typeMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Type your message here...'**
  String get typeMessageHint;

  /// No description provided for @unitAndProjectDetails.
  ///
  /// In en, this message translates to:
  /// **'Unit and Project Details'**
  String get unitAndProjectDetails;

  /// No description provided for @unitArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get unitArea;

  /// No description provided for @unitAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get unitAvailable;

  /// No description provided for @unitBaths.
  ///
  /// In en, this message translates to:
  /// **'Baths'**
  String get unitBaths;

  /// No description provided for @unitBeds.
  ///
  /// In en, this message translates to:
  /// **'Beds'**
  String get unitBeds;

  /// No description provided for @unitComparison.
  ///
  /// In en, this message translates to:
  /// **'Unit Comparison'**
  String get unitComparison;

  /// No description provided for @unitContractTerms.
  ///
  /// In en, this message translates to:
  /// **'1. Initial booking is subject to developer\'s final approval.\n2. Prices are estimates and may change based on final measurements.\n3. Booking deposit is non-refundable after 14 days.\n4. Buyer commits to completing the down payment within the specified timeline.\n5. All attached plans and specifications are an integral part of this contract.\n... [More Legal Terms]'**
  String get unitContractTerms;

  /// No description provided for @unitDetailsDefault.
  ///
  /// In en, this message translates to:
  /// **'Unit Details'**
  String get unitDetailsDefault;

  /// No description provided for @unitDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Unit Details'**
  String get unitDetailsTitle;

  /// No description provided for @unitDetailsWithArea.
  ///
  /// In en, this message translates to:
  /// **'Unit {title} with area {area}m²'**
  String unitDetailsWithArea(String title, String area);

  /// No description provided for @unitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unitLabel;

  /// No description provided for @unitPriceWithTitle.
  ///
  /// In en, this message translates to:
  /// **'Unit Price ({title})'**
  String unitPriceWithTitle(String title);

  /// No description provided for @unitSoldOut.
  ///
  /// In en, this message translates to:
  /// **'Sold Out'**
  String get unitSoldOut;

  /// No description provided for @unitSqMeter.
  ///
  /// In en, this message translates to:
  /// **'sqm'**
  String get unitSqMeter;

  /// No description provided for @unitStartsFrom.
  ///
  /// In en, this message translates to:
  /// **'Starts from'**
  String get unitStartsFrom;

  /// No description provided for @unitSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Unit Summary'**
  String get unitSummaryTitle;

  /// No description provided for @unitTitle.
  ///
  /// In en, this message translates to:
  /// **'Unit: {unit}'**
  String unitTitle(String unit);

  /// No description provided for @unitType.
  ///
  /// In en, this message translates to:
  /// **'Unit Type'**
  String get unitType;

  /// No description provided for @unitTypeDesc.
  ///
  /// In en, this message translates to:
  /// **'Unit {title} - {area} sqm'**
  String unitTypeDesc(String title, String area);

  /// No description provided for @unitTypes.
  ///
  /// In en, this message translates to:
  /// **'Unit Types'**
  String get unitTypes;

  /// No description provided for @unitsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} units selected'**
  String unitsSelected(String count);

  /// No description provided for @updateData.
  ///
  /// In en, this message translates to:
  /// **'Update Data'**
  String get updateData;

  /// No description provided for @updateProfileSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get updateProfileSuccess;

  /// No description provided for @vatAmount.
  ///
  /// In en, this message translates to:
  /// **'VAT (14%)'**
  String get vatAmount;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @warmTag.
  ///
  /// In en, this message translates to:
  /// **'Warm'**
  String get warmTag;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We craft your space into an architectural masterpiece that reflects your personality.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish it your way'**
  String get welcomeTitle;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @whatsappBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue via WhatsApp'**
  String get whatsappBtn;

  /// No description provided for @aiRendersTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Designs'**
  String get aiRendersTitle;

  /// No description provided for @aiWorkingTitle.
  ///
  /// In en, this message translates to:
  /// **'AI is now working'**
  String get aiWorkingTitle;

  /// No description provided for @aiWorkingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Analyzing the design and selecting the best colors and lighting...'**
  String get aiWorkingSubtitle;

  /// No description provided for @aiRendersRetry.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get aiRendersRetry;

  /// No description provided for @aiRendersSaveDesign.
  ///
  /// In en, this message translates to:
  /// **'Save Design'**
  String get aiRendersSaveDesign;

  /// No description provided for @aiRendersSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get aiRendersSaving;

  /// No description provided for @aiRendersDownloadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Design downloaded and saved to gallery successfully!'**
  String get aiRendersDownloadSuccess;

  /// No description provided for @aiRendersDownloadError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while downloading the image.'**
  String get aiRendersDownloadError;

  /// No description provided for @aiRendersNoDesigns.
  ///
  /// In en, this message translates to:
  /// **'No designs found.'**
  String get aiRendersNoDesigns;

  /// No description provided for @aiGalleryTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Gallery'**
  String get aiGalleryTitle;

  /// No description provided for @aiGalleryNoDesigns.
  ///
  /// In en, this message translates to:
  /// **'No saved designs'**
  String get aiGalleryNoDesigns;

  /// No description provided for @aiGalleryCreatePrompt.
  ///
  /// In en, this message translates to:
  /// **'Create your designs...'**
  String get aiGalleryCreatePrompt;

  /// No description provided for @aiGalleryUnnamedRoom.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Room'**
  String get aiGalleryUnnamedRoom;

  /// No description provided for @aiGalleryDesignDetails.
  ///
  /// In en, this message translates to:
  /// **'Design Details'**
  String get aiGalleryDesignDetails;

  /// No description provided for @aiGalleryImageNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Image not available'**
  String get aiGalleryImageNotAvailable;

  /// No description provided for @roomNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Room Name'**
  String get roomNameLabel;

  /// No description provided for @unnamedLabel.
  ///
  /// In en, this message translates to:
  /// **'Unnamed'**
  String get unnamedLabel;

  /// No description provided for @creationDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Creation Date'**
  String get creationDateLabel;

  /// No description provided for @notAvailableLabel.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get notAvailableLabel;

  /// No description provided for @projectUnitsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Units'**
  String projectUnitsCount(int count);

  /// No description provided for @homeNoProjectsTitle.
  ///
  /// In en, this message translates to:
  /// **'No featured projects at the moment'**
  String get homeNoProjectsTitle;

  /// No description provided for @homeNoProjectsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We are constantly working to provide the best real estate projects, please check back later or explore our services above.'**
  String get homeNoProjectsSubtitle;

  /// No description provided for @filterUnitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter Units'**
  String get filterUnitsTitle;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @areaTitle.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get areaTitle;

  /// No description provided for @bedroomsCount.
  ///
  /// In en, this message translates to:
  /// **'Bedrooms'**
  String get bedroomsCount;

  /// No description provided for @bathroomsCount.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms'**
  String get bathroomsCount;

  /// No description provided for @floorOrZone.
  ///
  /// In en, this message translates to:
  /// **'Floor / Zone'**
  String get floorOrZone;

  /// No description provided for @floorRange.
  ///
  /// In en, this message translates to:
  /// **'Floor Range'**
  String get floorRange;

  /// No description provided for @noMatchingUnits.
  ///
  /// In en, this message translates to:
  /// **'No matching units found'**
  String get noMatchingUnits;

  /// No description provided for @noAvailableUnits.
  ///
  /// In en, this message translates to:
  /// **'No available units currently'**
  String get noAvailableUnits;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting or clearing your filters to find units that meet your needs.'**
  String get tryAdjustingFilters;

  /// No description provided for @unitsWillBeAddedSoon.
  ///
  /// In en, this message translates to:
  /// **'Units will be added to this project soon. Please check back later.'**
  String get unitsWillBeAddedSoon;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @apartments.
  ///
  /// In en, this message translates to:
  /// **'Apartments'**
  String get apartments;

  /// No description provided for @villas.
  ///
  /// In en, this message translates to:
  /// **'Villas'**
  String get villas;

  /// No description provided for @duplexes.
  ///
  /// In en, this message translates to:
  /// **'Duplexes'**
  String get duplexes;

  /// No description provided for @groundFloor.
  ///
  /// In en, this message translates to:
  /// **'Ground Floor'**
  String get groundFloor;

  /// No description provided for @roomsAndAreasDetails.
  ///
  /// In en, this message translates to:
  /// **'Rooms & Areas Details'**
  String get roomsAndAreasDetails;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @noFloorPlanAvailable.
  ///
  /// In en, this message translates to:
  /// **'No detailed floor plan available'**
  String get noFloorPlanAvailable;

  /// No description provided for @updatingRoomsDataSoon.
  ///
  /// In en, this message translates to:
  /// **'Updating room and area data for this unit. It will be available soon.'**
  String get updatingRoomsDataSoon;

  /// No description provided for @aiSettings.
  ///
  /// In en, this message translates to:
  /// **'AI Settings'**
  String get aiSettings;

  /// No description provided for @chooseStyleOptional.
  ///
  /// In en, this message translates to:
  /// **'Choose Style (Optional)'**
  String get chooseStyleOptional;

  /// No description provided for @additionalNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes (Optional)'**
  String get additionalNotesOptional;

  /// No description provided for @notesExample.
  ///
  /// In en, this message translates to:
  /// **'Example: I want to blend the simplicity of Japanese design...'**
  String get notesExample;

  /// No description provided for @suggestedNotes.
  ///
  /// In en, this message translates to:
  /// **'Suggested Notes'**
  String get suggestedNotes;

  /// No description provided for @requestSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Request sent successfully!'**
  String get requestSentSuccessfully;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @approximateCost.
  ///
  /// In en, this message translates to:
  /// **'Approximate Cost'**
  String get approximateCost;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// No description provided for @smartDesign.
  ///
  /// In en, this message translates to:
  /// **'Smart Design'**
  String get smartDesign;

  /// No description provided for @availableFinishingOptions.
  ///
  /// In en, this message translates to:
  /// **'Available Finishing Options'**
  String get availableFinishingOptions;

  /// No description provided for @buildingNumber.
  ///
  /// In en, this message translates to:
  /// **'Building {number}'**
  String buildingNumber(Object number);

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @stepStyle.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get stepStyle;

  /// No description provided for @stepMaterials.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get stepMaterials;

  /// No description provided for @stepDesign.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get stepDesign;

  /// No description provided for @stepApproval.
  ///
  /// In en, this message translates to:
  /// **'Approval'**
  String get stepApproval;

  /// No description provided for @yourRoomDesigns.
  ///
  /// In en, this message translates to:
  /// **'Your Room Designs'**
  String get yourRoomDesigns;

  /// No description provided for @designsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Designs'**
  String designsCount(Object count);

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @paymentSummary.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get paymentSummary;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @vat.
  ///
  /// In en, this message translates to:
  /// **'VAT'**
  String get vat;

  /// No description provided for @downPayment.
  ///
  /// In en, this message translates to:
  /// **'Down Payment'**
  String get downPayment;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @payAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount} SAR'**
  String payAmount(String amount);

  /// No description provided for @paymentSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful!'**
  String get paymentSuccessTitle;

  /// No description provided for @paymentSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Down payment confirmed successfully. Our team will start processing your order right away.'**
  String get paymentSuccessSubtitle;

  /// No description provided for @goToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Go to Dashboard'**
  String get goToDashboard;

  /// No description provided for @applePay.
  ///
  /// In en, this message translates to:
  /// **'Apple Pay'**
  String get applePay;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card / Mada'**
  String get creditCard;

  /// No description provided for @bankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get bankTransfer;

  /// No description provided for @securePayment.
  ///
  /// In en, this message translates to:
  /// **'Secure Electronic Payment'**
  String get securePayment;

  /// No description provided for @roomsProgress.
  ///
  /// In en, this message translates to:
  /// **'Rooms Progress'**
  String get roomsProgress;

  /// No description provided for @roomProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Room Progress'**
  String get roomProgressLabel;

  /// No description provided for @roomXOfY.
  ///
  /// In en, this message translates to:
  /// **'Room {current} of {total}'**
  String roomXOfY(String current, String total);

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @nextRoom.
  ///
  /// In en, this message translates to:
  /// **'Next Room'**
  String get nextRoom;

  /// No description provided for @designOptions.
  ///
  /// In en, this message translates to:
  /// **'Design Options'**
  String get designOptions;

  /// No description provided for @designWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Warning Before Design'**
  String get designWarningTitle;

  /// No description provided for @designWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'You have not selected materials for some available sections. Would you like to continue without them or go back to select?'**
  String get designWarningMessage;

  /// No description provided for @designAnyway.
  ///
  /// In en, this message translates to:
  /// **'Design Anyway'**
  String get designAnyway;

  /// No description provided for @cancelAndContinueSelection.
  ///
  /// In en, this message translates to:
  /// **'Cancel & Continue Selection'**
  String get cancelAndContinueSelection;

  /// No description provided for @chooseTypeOf.
  ///
  /// In en, this message translates to:
  /// **'Choose {typeName} Type'**
  String chooseTypeOf(String typeName);

  /// No description provided for @materialDetails.
  ///
  /// In en, this message translates to:
  /// **'Material Details'**
  String get materialDetails;

  /// No description provided for @selectThisMaterial.
  ///
  /// In en, this message translates to:
  /// **'Select This Material'**
  String get selectThisMaterial;

  /// No description provided for @unselectMaterial.
  ///
  /// In en, this message translates to:
  /// **'Unselect Material'**
  String get unselectMaterial;

  /// No description provided for @pricePerUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Price: {price} SAR / {unit}'**
  String pricePerUnitLabel(String price, String unit);

  /// No description provided for @totalRoomCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Room Cost: {cost} SAR'**
  String totalRoomCostLabel(String cost);

  /// No description provided for @noMaterialsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No materials available in this section currently'**
  String get noMaterialsAvailable;

  /// No description provided for @unitFeatures.
  ///
  /// In en, this message translates to:
  /// **'Unit Features'**
  String get unitFeatures;

  /// No description provided for @startFinishingJourney.
  ///
  /// In en, this message translates to:
  /// **'Start Finishing Journey'**
  String get startFinishingJourney;

  /// No description provided for @applyMaterialToOtherRooms.
  ///
  /// In en, this message translates to:
  /// **'Would you like to apply this material to other rooms?'**
  String get applyMaterialToOtherRooms;

  /// No description provided for @applyToAll.
  ///
  /// In en, this message translates to:
  /// **'Apply to All'**
  String get applyToAll;

  /// No description provided for @selectRooms.
  ///
  /// In en, this message translates to:
  /// **'Select Rooms'**
  String get selectRooms;

  /// No description provided for @roomArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get roomArea;

  /// No description provided for @roomDimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get roomDimensions;

  /// No description provided for @areaNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get areaNotSpecified;

  /// No description provided for @appliedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{materialName} applied to all rooms successfully'**
  String appliedSuccessfully(String materialName);

  /// No description provided for @appliedToSelectedRooms.
  ///
  /// In en, this message translates to:
  /// **'{materialName} applied to selected rooms successfully'**
  String appliedToSelectedRooms(String materialName);

  /// No description provided for @pricePerRoom.
  ///
  /// In en, this message translates to:
  /// **'{price} SAR for room'**
  String pricePerRoom(String price);

  /// No description provided for @readFullContract.
  ///
  /// In en, this message translates to:
  /// **'Read Full Contract'**
  String get readFullContract;

  /// No description provided for @contractSummary.
  ///
  /// In en, this message translates to:
  /// **'Contract Summary'**
  String get contractSummary;

  /// No description provided for @confirmAndAgree.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Agree'**
  String get confirmAndAgree;

  /// No description provided for @slideToSign.
  ///
  /// In en, this message translates to:
  /// **'Slide to Agree & Sign'**
  String get slideToSign;

  /// No description provided for @viewDetailedLegalTerms.
  ///
  /// In en, this message translates to:
  /// **'View Detailed Legal Terms'**
  String get viewDetailedLegalTerms;

  /// No description provided for @signedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Signed Successfully'**
  String get signedSuccessfully;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
