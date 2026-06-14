import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../../home/domain/entities/project_entity.dart';
import '../../../home/domain/entities/project_service_entity.dart';
import '../../../home/domain/entities/project_unit_entity.dart';

class ProjectsMockData {
  static const String mockDesc =
      'يعد هذا المشروع من أرقى المشاريع السكنية، حيث يجمع بين التصميم العصري الفاخر والمساحات الخضراء الشاسعة. يوفر المشروع أسلوب حياة متكامل مع خدمات استثنائية تلبي كافة احتياجات العائلة العصرية. تم تصميم الوحدات بعناية فائقة لتوفير أقصى درجات الخصوصية والراحة.';
  static const List<String> mockAmenities = ['مسبح', 'جيم', 'أمن', 'جراج'];

  static const List<ProjectServiceEntity> mockServices = [
    ProjectServiceEntity(
      id: '1',
      title: 'التصور الذكي',
      description:
          'شاهد مساحتك قبل التنفيذ عبر تقنيات الذكاء الاصطناعي والتصاميم ثلاثية الأبعاد الواقعية جداً، لضمان دقة الاختيار.',
      imagePath: 'assets/images/service_1.png',
      icon: FluentIcons.brain_circuit_24_regular,
    ),
    ProjectServiceEntity(
      id: '2',
      title: 'باقات التصميم الداخلي',
      description:
          'باقات مصممة خصيصاً لتناسب ذوقك وتلبي احتياجاتك، من المخططات الأولية وحتى اختيار أدق التفاصيل الفنية.',
      imagePath: 'assets/images/service_2.png',
      icon: FluentIcons.color_24_regular,
    ),
    ProjectServiceEntity(
      id: '3',
      title: 'الإشراف على التنفيذ',
      description:
          'فريق من المهندسين الخبراء لمتابعة سير العمل في الموقع، لضمان تطابق التنفيذ مع التصاميم بأعلى معايير الجودة.',
      imagePath: 'assets/images/service_3.png',
      icon: FluentIcons.people_24_regular,
    ),
    ProjectServiceEntity(
      id: '4',
      title: 'اختيار الخامات',
      description:
          'مساعدتك في انتقاء أجود الخامات والمواد الأولية من أفضل الموردين، بما يتوافق مع الميزانية والتصميم المعتمد.',
      imagePath: 'assets/images/service_4.png',
      icon: FluentIcons.layer_24_regular,
    ),
  ];

  static const List<ProjectUnitEntity> mockUnits = [
    ProjectUnitEntity(
      id: '101',
      title: 'شقة فاخرة A1',
      type: UnitType.apartment,
      area: 150,
      bedrooms: 3,
      bathrooms: 2,
      price: 650000,
      status: UnitStatus.available,
      imagePath: 'assets/images/unit_apartment.png',
      floor: 4,
      extras: ['تراس إضافي', 'غرفة خادمة'],
      description:
          'وحدة سكنية فاخرة بتصميم عصري يتيح أقصى استفادة من المساحات الطبيعية. تتميز بتهوية ممتازة وإضاءة طبيعية تغطي كافة الغرف بفضل الواجهة البحرية.',
      images: [
        'assets/images/unit_apartment.png',
        'assets/images/floor_plan.png',
      ],
    ),
    ProjectUnitEntity(
      id: '102',
      title: 'فيلا رويال',
      type: UnitType.villa,
      area: 450,
      bedrooms: 5,
      bathrooms: 4,
      price: 2500000,
      status: UnitStatus.available,
      imagePath: 'assets/images/unit_villa.png',
      floor: 1,
      extras: ['مسبح خاص', 'حديقة واسعة'],
      description:
          'فيلا فخمة توفر لك ولعائلتك الخصوصية التامة مع مساحات خضراء شاسعة وتصميم كلاسيكي حديث.',
      images: [
        'assets/images/unit_villa.png',
        'assets/images/floor_plan.png',
      ],
    ),
    ProjectUnitEntity(
      id: '103',
      title: 'دوبلكس بانوراما',
      type: UnitType.duplex,
      area: 280,
      bedrooms: 4,
      bathrooms: 3,
      price: 1200000,
      status: UnitStatus.sold,
      imagePath: 'assets/images/unit_duplex.png',
      floor: 5,
      extras: ['روف جاردن'],
      description:
          'دوبلكس بإطلالة بانورامية رائعة، يوفر مساحات مفتوحة ومرونة عالية في تقسيم الغرف والديكور.',
      images: [
        'assets/images/unit_duplex.png',
        'assets/images/floor_plan.png',
      ],
    ),
    ProjectUnitEntity(
      id: '104',
      title: 'شقة بحديقة B2',
      type: UnitType.apartment,
      area: 180,
      bedrooms: 3,
      bathrooms: 3,
      price: 850000,
      status: UnitStatus.available,
      imagePath: 'assets/images/unit_apartment.png',
      floor: 2,
      extras: ['حديقة خاصة'],
      description:
          'شقة أرضية ملحق بها حديقة خاصة توفر متنفساً طبيعياً، تصميم حديث يستغل كل متر بحرفية.',
      images: [
        'assets/images/unit_apartment.png',
        'assets/images/floor_plan.png',
      ],
    ),
  ];

  static List<ProjectEntity> getProjects() {
    return [
      const ProjectEntity(
        id: 3,
        name: 'واحة النخيل',
        location: 'الدمام - حي الفيصلية',
        startingPrice: 650000,
        images: ['assets/images/projects/project3.png'],
        description: mockDesc,
        amenities: mockAmenities,
        totalArea: '٩٠٠ فدان',
        unitTypes: 'شقق، فيلات، دوبلكس',
        deliveryDate: '٢٠٢٥',
        finishingType: 'نصف تشطيب',
        services: mockServices,
        units: mockUnits,
      ),
      const ProjectEntity(
        id: 4,
        name: 'جاردن فيو',
        location: 'الرياض - حي النرجس',
        startingPrice: 950000,
        images: ['assets/images/projects/project4.png'],
        description: mockDesc,
        amenities: mockAmenities,
        totalArea: '٥٠٠ فدان',
        unitTypes: 'شقق، بنتهاوس',
        deliveryDate: '٢٠٢٤',
        finishingType: 'تشطيب كامل',
        services: mockServices,
        units: mockUnits,
      ),
      const ProjectEntity(
        id: 2,
        name: 'أبراج الصفوة',
        location: 'جدة - حي الشاطئ',
        startingPrice: 1200000,
        images: ['assets/images/projects/project2.png'],
        description: mockDesc,
        amenities: mockAmenities,
        totalArea: '٣٠٠ فدان',
        unitTypes: 'شقق فاخرة',
        deliveryDate: '٢٠٢٦',
        finishingType: 'عظم',
        services: mockServices,
        units: mockUnits,
      ),
      const ProjectEntity(
        id: 1,
        name: 'مشروع الفخامة ريزيدنس',
        location: 'الرياض - حي الملقا',
        startingPrice: 850000,
        images: ['assets/images/projects/project1.png'],
        description: mockDesc,
        amenities: mockAmenities,
        totalArea: '٧٥٠ فدان',
        unitTypes: 'فيلات مستقلة',
        deliveryDate: '٢٠٢٥',
        finishingType: 'نصف تشطيب',
        services: mockServices,
        units: mockUnits,
      ),
    ];
  }
}
