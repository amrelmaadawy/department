import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment/features/packages/presentation/cubit/packages_state.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';

class PackagesCubit extends Cubit<PackagesState> {
  PackagesCubit() : super(PackagesInitial());

  void loadPackages() {
    emit(PackagesLoading());

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 600), () {
      final mockPackages = [
        const FinishingPackageEntity(
          id: '1',
          tier: PackageTier.economic,
          title: 'الاقتصادي',
          pricePerSqm: 1500,
          features: [
            'تأسيس سباكة وكهرباء',
            'دهانات بلاستيك عالية الجودة',
            'سيراميك فرز أول',
          ],
          buttonText: 'اختر الباقة',
        ),
        const FinishingPackageEntity(
          id: '2',
          tier: PackageTier.standard,
          title: 'المتوسط',
          pricePerSqm: 2800,
          features: [
            'أسقف جيبسوم بورد مودرن',
            'بورسلين مستورد للاستقبال',
            'أطقم حمامات فاخرة',
          ],
          badge: 'الأكثر طلباً',
          buttonText: 'اختر الباقة',
        ),
        const FinishingPackageEntity(
          id: '3',
          tier: PackageTier.luxury,
          title: 'الفاخر',
          pricePerSqm: 4500,
          features: [
            'رخام مستورد للاستقبال بالكامل',
            'ديكورات خشبية وبديل الرخام',
            'تأسيس وتجهيز سمارت هوم',
          ],
          buttonText: 'اختر الباقة',
        ),
        const FinishingPackageEntity(
          id: '4',
          tier: PackageTier.custom,
          title: 'حسب الطلب',
          subtitle: 'تشطيب حصري',
          pricePerSqm: 0, // 0 implies custom pricing
          features: [
            'تصميم داخلي حصري وفريد',
            'خامات مستوردة بالكامل نادرة',
            'إشراف هندسي يومي مخصص',
          ],
          buttonText: 'اطلب المعاينة',
        ),
      ];

      emit(PackagesLoaded(mockPackages));
    });
  }
}
