import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/entities/project_service_entity.dart';
import '../../domain/entities/project_unit_entity.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void loadHomeData() async {
    emit(HomeLoading());

    // Simulate API delay for Shimmer effect
    await Future.delayed(const Duration(seconds: 2));

    // Dummy data using the generated AI images
    final String mockDesc =
        'يعد هذا المشروع من أرقى المشاريع السكنية، حيث يجمع بين التصميم العصري الفاخر والمساحات الخضراء الشاسعة. يوفر المشروع أسلوب حياة متكامل مع خدمات استثنائية تلبي كافة احتياجات العائلة العصرية. تم تصميم الوحدات بعناية فائقة لتوفير أقصى درجات الخصوصية والراحة.';
    final List<String> mockAmenities = ['مسبح', 'جيم', 'أمن', 'جراج'];
    final List<ProjectServiceEntity> mockServices = [
      const ProjectServiceEntity(
        id: '1',
        title: 'التصور الذكي',
        description:
            'شاهد مساحتك قبل التنفيذ عبر تقنيات الذكاء الاصطناعي والتصاميم ثلاثية الأبعاد الواقعية جداً، لضمان دقة الاختيار.',
        imagePath: 'assets/images/service_1.png',
        icon: FluentIcons.brain_circuit_24_regular,
      ),
      const ProjectServiceEntity(
        id: '2',
        title: 'باقات التصميم الداخلي',
        description:
            'باقات مصممة خصيصاً لتناسب ذوقك وتلبي احتياجاتك، من المخططات الأولية وحتى اختيار أدق التفاصيل الفنية.',
        imagePath: 'assets/images/service_2.png',
        icon: FluentIcons.color_24_regular,
      ),
      const ProjectServiceEntity(
        id: '3',
        title: 'الإشراف على التنفيذ',
        description:
            'فريق من المهندسين الخبراء لمتابعة سير العمل في الموقع، لضمان تطابق التنفيذ مع التصاميم بأعلى معايير الجودة.',
        imagePath: 'assets/images/service_3.png',
        icon: FluentIcons.people_24_regular,
      ),
      const ProjectServiceEntity(
        id: '4',
        title: 'اختيار الخامات',
        description:
            'مساعدتك في انتقاء أجود الخامات والمواد الأولية من أفضل الموردين، بما يتوافق مع الميزانية والتصميم المعتمد.',
        imagePath: 'assets/images/service_4.png',
        icon: FluentIcons.layer_24_regular,
      ),
    ];
    final List<ProjectUnitEntity> mockUnits = [
      const ProjectUnitEntity(
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
        images: const [
          'assets/images/unit_apartment.png',
          'assets/images/floor_plan.png',
        ],
      ),
      const ProjectUnitEntity(
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
        images: const [
          'assets/images/unit_villa.png',
          'assets/images/floor_plan.png',
        ],
      ),
      const ProjectUnitEntity(
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
        images: const [
          'assets/images/unit_duplex.png',
          'assets/images/floor_plan.png',
        ],
      ),
    ];

    final projects = [
      ProjectEntity(
        id: '1',
        name: 'أثير ريزيدنس',
        location: 'الرياض - الياسمين',
        startingPrice: 650000,
        imagePath: 'assets/images/project_one_mock.png',
        description: mockDesc,
        amenities: mockAmenities,
        totalArea: '٩٠٠ فدان',
        unitTypes: 'شقق، فيلات، دوبلكس',
        deliveryDate: '٢٠٢٥',
        finishingType: 'نصف تشطيب',
        services: mockServices,
        units: mockUnits,
      ),
      ProjectEntity(
        id: '2',
        name: 'ريان هايتس',
        location: 'الرياض - النرجس',
        startingPrice: 720000,
        imagePath: 'assets/images/project_two_mock.png',
        description: mockDesc,
        amenities: mockAmenities,
        totalArea: '٥٠٠ فدان',
        unitTypes: 'شقق، بنتهاوس',
        deliveryDate: '٢٠٢٤',
        finishingType: 'تشطيب كامل',
        services: mockServices,
        units: mockUnits,
      ),
    ];

    emit(HomeLoaded(featuredProjects: projects));
  }
}
