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

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish it your way'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build your private space.. from core-and-shell to luxury'**
  String get welcomeSubtitle;

  /// No description provided for @startNow.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get startNow;

  /// No description provided for @exploreAsHost.
  ///
  /// In en, this message translates to:
  /// **'Explore as a host'**
  String get exploreAsHost;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumber;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @orVia.
  ///
  /// In en, this message translates to:
  /// **'Or via'**
  String get orVia;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @registerAgreement.
  ///
  /// In en, this message translates to:
  /// **'By registering, you agree to the'**
  String get registerAgreement;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

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

  /// No description provided for @navDesign.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get navDesign;

  /// No description provided for @navProposals.
  ///
  /// In en, this message translates to:
  /// **'Proposals'**
  String get navProposals;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String helloUser(String name);

  /// No description provided for @riyadh.
  ///
  /// In en, this message translates to:
  /// **'Riyadh'**
  String get riyadh;

  /// No description provided for @promoTitle.
  ///
  /// In en, this message translates to:
  /// **'Build your space..\nTo your taste'**
  String get promoTitle;

  /// No description provided for @exploreProjects.
  ///
  /// In en, this message translates to:
  /// **'Explore Projects'**
  String get exploreProjects;

  /// No description provided for @featuredProjects.
  ///
  /// In en, this message translates to:
  /// **'Featured Projects'**
  String get featuredProjects;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @startsFrom.
  ///
  /// In en, this message translates to:
  /// **'Starts from'**
  String get startsFrom;

  /// No description provided for @sar.
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get sar;

  /// No description provided for @searchProject.
  ///
  /// In en, this message translates to:
  /// **'Search for a project or location'**
  String get searchProject;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterJeddah.
  ///
  /// In en, this message translates to:
  /// **'Jeddah'**
  String get filterJeddah;

  /// No description provided for @filterEastern.
  ///
  /// In en, this message translates to:
  /// **'Eastern Prov.'**
  String get filterEastern;

  /// No description provided for @noProjectsFound.
  ///
  /// In en, this message translates to:
  /// **'No projects found'**
  String get noProjectsFound;

  /// No description provided for @tabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get tabOverview;

  /// No description provided for @tabUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get tabUnits;

  /// No description provided for @tabServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get tabServices;

  /// No description provided for @aboutProject.
  ///
  /// In en, this message translates to:
  /// **'About Project'**
  String get aboutProject;

  /// No description provided for @totalArea.
  ///
  /// In en, this message translates to:
  /// **'Total Area'**
  String get totalArea;

  /// No description provided for @unitTypes.
  ///
  /// In en, this message translates to:
  /// **'Unit Types'**
  String get unitTypes;

  /// No description provided for @deliveryDate.
  ///
  /// In en, this message translates to:
  /// **'Delivery Date'**
  String get deliveryDate;

  /// No description provided for @finishingType.
  ///
  /// In en, this message translates to:
  /// **'Finishing'**
  String get finishingType;

  /// No description provided for @chooseUnit.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Unit'**
  String get chooseUnit;

  /// No description provided for @million.
  ///
  /// In en, this message translates to:
  /// **'Million'**
  String get million;

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

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

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

  /// No description provided for @materialSelection.
  ///
  /// In en, this message translates to:
  /// **'Material Selection'**
  String get materialSelection;

  /// No description provided for @serviceMaterialsDesc.
  ///
  /// In en, this message translates to:
  /// **'Assisting you in selecting the finest materials from top suppliers, aligning with your budget and approved design.'**
  String get serviceMaterialsDesc;

  /// No description provided for @filterApartment.
  ///
  /// In en, this message translates to:
  /// **'Apartments'**
  String get filterApartment;

  /// No description provided for @filterVilla.
  ///
  /// In en, this message translates to:
  /// **'Villas'**
  String get filterVilla;

  /// No description provided for @filterDuplex.
  ///
  /// In en, this message translates to:
  /// **'Duplex'**
  String get filterDuplex;

  /// No description provided for @unitArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get unitArea;

  /// No description provided for @unitBeds.
  ///
  /// In en, this message translates to:
  /// **'Beds'**
  String get unitBeds;

  /// No description provided for @unitBaths.
  ///
  /// In en, this message translates to:
  /// **'Baths'**
  String get unitBaths;

  /// No description provided for @unitStartsFrom.
  ///
  /// In en, this message translates to:
  /// **'Starts from'**
  String get unitStartsFrom;

  /// No description provided for @unitAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get unitAvailable;

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

  /// No description provided for @unitDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Unit Details'**
  String get unitDetailsTitle;

  /// No description provided for @floorLabel.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get floorLabel;

  /// No description provided for @roomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get roomsLabel;

  /// No description provided for @bathroomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Baths'**
  String get bathroomsLabel;

  /// No description provided for @overviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overviewTitle;

  /// No description provided for @costEstimateTitle.
  ///
  /// In en, this message translates to:
  /// **'Cost Estimation'**
  String get costEstimateTitle;

  /// No description provided for @basicUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Basic Unit Price'**
  String get basicUnitPrice;

  /// No description provided for @semiFinished.
  ///
  /// In en, this message translates to:
  /// **'(Semi-finished)'**
  String get semiFinished;

  /// No description provided for @estimatedFinishingCost.
  ///
  /// In en, this message translates to:
  /// **'Estimated Finishing Cost'**
  String get estimatedFinishingCost;

  /// No description provided for @basedOnLuxuryPackage.
  ///
  /// In en, this message translates to:
  /// **'Based on luxury package'**
  String get basedOnLuxuryPackage;

  /// No description provided for @totalExpectedCost.
  ///
  /// In en, this message translates to:
  /// **'Total Expected Cost'**
  String get totalExpectedCost;

  /// No description provided for @readyPackagesBtn.
  ///
  /// In en, this message translates to:
  /// **'Ready Packages'**
  String get readyPackagesBtn;

  /// No description provided for @startFinishingBtn.
  ///
  /// In en, this message translates to:
  /// **'Start Finishing Yourself'**
  String get startFinishingBtn;

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

  /// No description provided for @pricePerSqm.
  ///
  /// In en, this message translates to:
  /// **'SAR / sqm'**
  String get pricePerSqm;

  /// No description provided for @signature.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get signature;

  /// No description provided for @customFinishing.
  ///
  /// In en, this message translates to:
  /// **'Custom Finishing'**
  String get customFinishing;

  /// No description provided for @categoryFloors.
  ///
  /// In en, this message translates to:
  /// **'Floors'**
  String get categoryFloors;

  /// No description provided for @categoryWalls.
  ///
  /// In en, this message translates to:
  /// **'Walls'**
  String get categoryWalls;

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

  /// No description provided for @categoryReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get categoryReview;

  /// No description provided for @chooseFloorType.
  ///
  /// In en, this message translates to:
  /// **'Choose Floor Type'**
  String get chooseFloorType;

  /// No description provided for @chooseWallType.
  ///
  /// In en, this message translates to:
  /// **'Choose Wall Type'**
  String get chooseWallType;

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

  /// No description provided for @reviewSelections.
  ///
  /// In en, this message translates to:
  /// **'Review Your Selections'**
  String get reviewSelections;

  /// No description provided for @totalEstimatedCost.
  ///
  /// In en, this message translates to:
  /// **'Total Estimated Cost'**
  String get totalEstimatedCost;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;
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
