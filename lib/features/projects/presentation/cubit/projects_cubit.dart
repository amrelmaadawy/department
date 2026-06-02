import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../../home/domain/entities/project_entity.dart';
import '../../../home/domain/entities/project_service_entity.dart';

part 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  ProjectsCubit() : super(ProjectsInitial());

  List<ProjectEntity> _allProjects = [];
  String _currentFilter = 'الكل';
  String _currentSearchQuery = '';

  void loadProjects() async {
    emit(ProjectsLoading());

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1500));

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

    _allProjects = [
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
      ),
      ProjectEntity(
        id: '3',
        name: 'نوران فيو',
        location: 'جدة - الشاطئ',
        startingPrice: 560000,
        imagePath: 'assets/images/project_three_mock.png',
        description: mockDesc,
        amenities: mockAmenities,
        totalArea: '٣٠٠ فدان',
        unitTypes: 'شقق فاخرة',
        deliveryDate: '٢٠٢٦',
        finishingType: 'عظم',
        services: mockServices,
      ),
      ProjectEntity(
        id: '4',
        name: 'ليان ريزيدنس',
        location: 'الرياض - الملقا',
        startingPrice: 610000,
        imagePath: 'assets/images/project_four_mock.png',
        description: mockDesc,
        amenities: mockAmenities,
        totalArea: '٧٥٠ فدان',
        unitTypes: 'فيلات مستقلة',
        deliveryDate: '٢٠٢٥',
        finishingType: 'نصف تشطيب',
        services: mockServices,
      ),
    ];

    emit(
      ProjectsLoaded(
        allProjects: _allProjects,
        filteredProjects: _allProjects,
        selectedFilter: _currentFilter,
      ),
    );
  }

  void filterByCity(String city) {
    _currentFilter = city;
    _applyFilters();
  }

  void searchProjects(String query) {
    _currentSearchQuery = query.toLowerCase();
    _applyFilters();
  }

  void _applyFilters() {
    if (state is! ProjectsLoaded) return;

    List<ProjectEntity> filtered = _allProjects;

    // Apply city filter
    if (_currentFilter != 'الكل') {
      filtered = filtered
          .where((p) => p.location.contains(_currentFilter))
          .toList();
    }

    // Apply search query
    if (_currentSearchQuery.isNotEmpty) {
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(_currentSearchQuery) ||
            p.location.toLowerCase().contains(_currentSearchQuery);
      }).toList();
    }

    emit(
      ProjectsLoaded(
        allProjects: _allProjects,
        filteredProjects: filtered,
        selectedFilter: _currentFilter,
      ),
    );
  }
}
