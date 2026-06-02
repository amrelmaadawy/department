import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/project_entity.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void loadHomeData() async {
    emit(HomeLoading());
    
    // Simulate API delay for Shimmer effect
    await Future.delayed(const Duration(seconds: 2));

    // Dummy data using the generated AI images
    final String mockDesc = 'يعد هذا المشروع من أرقى المشاريع السكنية، حيث يجمع بين التصميم العصري الفاخر والمساحات الخضراء الشاسعة. يوفر المشروع أسلوب حياة متكامل مع خدمات استثنائية تلبي كافة احتياجات العائلة العصرية. تم تصميم الوحدات بعناية فائقة لتوفير أقصى درجات الخصوصية والراحة.';
    final List<String> mockAmenities = ['مسبح', 'جيم', 'أمن', 'جراج'];

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
      ),
    ];

    emit(HomeLoaded(featuredProjects: projects));
  }
}
