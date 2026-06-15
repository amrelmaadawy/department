import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/entities/project_service_entity.dart';
import '../../domain/entities/project_unit_entity.dart';
import '../../../../features/projects/domain/usecases/get_projects_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetProjectsUseCase getProjectsUseCase;

  HomeCubit({required this.getProjectsUseCase}) : super(HomeInitial());

  void loadHomeData() async {
    emit(HomeLoading());

    final result = await getProjectsUseCase();

    // Dummy data using the generated AI images
    final String mockDesc =
        'يعد هذا المشروع من أرقى المشاريع السكنية، حيث يجمع بين التصميم العصري الفاخر والمساحات الخضراء الشاسعة. يوفر المشروع أسلوب حياة متكامل مع خدمات استثنائية تلبي كافة احتياجات العائلة العصرية. تم تصميم الوحدات بعناية فائقة لتوفير أقصى درجات الخصوصية والراحة.';
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
        images: [
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
        images: [
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
        images: [
          'assets/images/unit_duplex.png',
          'assets/images/floor_plan.png',
        ],
      ),
    ];

    result.fold(
      (failure) => emit(HomeLoaded(featuredProjects: const [])), // Or handle error state appropriately
      (projects) {
        // Take the first 3 projects as "Featured" or any other logic you prefer
        final featured = projects.take(3).toList();
        emit(HomeLoaded(featuredProjects: featured));
      },
    );
  }
}
