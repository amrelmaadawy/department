import 'package:flutter_bloc/flutter_bloc.dart';
import 'custom_finishing_state.dart';
import '../../domain/entities/material_category.dart';
import '../../domain/entities/material_entity.dart';

class CustomFinishingCubit extends Cubit<CustomFinishingState> {
  // Mock base parameters
  final double baseUnitAreaSqm = 120.0;
  final double baseFinishingCost = 100000.0; // Flat base cost

  CustomFinishingCubit() : super(const CustomFinishingState());

  void loadMaterials() async {
    emit(state.copyWith(isLoading: true));

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final mockMaterials = {
      MaterialCategory.floors: [
        const MaterialEntity(
          id: 'f1',
          category: MaterialCategory.floors,
          name: 'رخام إيطالي',
          description:
              'يعطي طابعاً فخماً وملمساً بارداً. مثالي للمساحات المفتوحة.',
          imageUrl:
              'assets/images/material_marble.png', // Will copy generated image
          pricePerSqm: 1200.0,
          tag: 'فاخر',
        ),
        const MaterialEntity(
          id: 'f2',
          category: MaterialCategory.floors,
          name: 'بورسلين إسباني',
          description: 'متانة عالية وتنوع في التصاميم والألوان، سهل التنظيف.',
          imageUrl:
              'assets/images/material_porcelain.png', // Will copy generated image
          pricePerSqm: 650.0,
          tag: 'عملي',
        ),
        const MaterialEntity(
          id: 'f3',
          category: MaterialCategory.floors,
          name: 'باركيه ألماني',
          description: 'يضفي دفئاً ورونقاً طبيعياً للمكان، مناسب لغرف النوم.',
          imageUrl:
              'assets/images/material_parquet.png', // Will copy generated image
          pricePerSqm: 850.0,
          tag: 'دافئ',
        ),
        const MaterialEntity(
          id: 'f4',
          category: MaterialCategory.floors,
          name: 'أرضيات SPC',
          description: 'مقاوم للماء والرطوبة، خيار عملي واقتصادي بلمسة عصرية.',
          imageUrl:
              'assets/images/material_spc.png', // Will copy generated image
          pricePerSqm: 250.0,
          tag: 'اقتصادي',
        ),
      ],
      MaterialCategory.walls: [
        const MaterialEntity(
          id: 'w1',
          category: MaterialCategory.walls,
          name: 'دهان جوتن فينوماستيك',
          description: 'دهان عالي الجودة قابل للغسيل',
          imageUrl: '',
          pricePerSqm: 120.0,
          tag: 'عملي',
        ),
        const MaterialEntity(
          id: 'w2',
          category: MaterialCategory.walls,
          name: 'ورق حائط فرنسي',
          description: 'تصاميم كلاسيكية فاخرة',
          imageUrl: '',
          pricePerSqm: 350.0,
          tag: 'فاخر',
        ),
      ],
      MaterialCategory.ceilings: [
        const MaterialEntity(
          id: 'c1',
          category: MaterialCategory.ceilings,
          name: 'جبس بورد فلات',
          description: 'سقف مستوي مع إضاءة مخفية',
          imageUrl: '',
          pricePerSqm: 150.0,
          tag: 'عصري',
        ),
      ],
      MaterialCategory.doors: [
        const MaterialEntity(
          id: 'd1',
          category: MaterialCategory.doors,
          name: 'أبواب خشب زان',
          description: 'أبواب متينة بتصاميم كلاسيكية',
          imageUrl: '',
          pricePerSqm: 400.0,
          tag: 'كلاسيك',
        ),
      ],
    };

    // Pre-select first options for a baseline cost
    final initialSelections = {
      MaterialCategory.floors: mockMaterials[MaterialCategory.floors]![0],
      MaterialCategory.walls: mockMaterials[MaterialCategory.walls]![0],
      MaterialCategory.ceilings: mockMaterials[MaterialCategory.ceilings]![0],
      MaterialCategory.doors: mockMaterials[MaterialCategory.doors]![0],
    };

    emit(
      state.copyWith(
        isLoading: false,
        availableMaterials: mockMaterials,
        selectedMaterials: initialSelections,
      ),
    );

    _recalculateTotal();
  }

  void selectCategory(MaterialCategory category) {
    emit(state.copyWith(currentCategory: category));
  }

  void selectMaterial(MaterialEntity material) {
    final newSelections = Map<MaterialCategory, MaterialEntity>.from(
      state.selectedMaterials,
    );
    newSelections[material.category] = material;

    emit(state.copyWith(selectedMaterials: newSelections));
    _recalculateTotal();
  }

  void nextStep() {
    final categories = MaterialCategory.values;
    final currentIndex = categories.indexOf(state.currentCategory);

    if (currentIndex < categories.length - 1) {
      emit(state.copyWith(currentCategory: categories[currentIndex + 1]));
    }
  }

  void _recalculateTotal() {
    double materialsCost = 0;

    for (var material in state.selectedMaterials.values) {
      materialsCost += (material.pricePerSqm * baseUnitAreaSqm);
    }

    final double workmanship = 65000.0;
    final double subtotal = materialsCost + workmanship;
    final double vat = subtotal * 0.14; // 14% VAT
    final double total = subtotal + vat;

    emit(
      state.copyWith(
        materialsCost: materialsCost,
        workmanshipCost: workmanship,
        vatAmount: vat,
        totalEstimatedCost: total,
      ),
    );
  }
}
