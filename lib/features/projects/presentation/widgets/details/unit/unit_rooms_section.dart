import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/features/home/domain/entities/unit_room_entity.dart';
import 'package:apartment/features/projects/presentation/cubit/unit_details_cubit.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment/core/routes/app_router.dart';
class UnitRoomsSection extends StatelessWidget {
  final List<UnitRoomEntity> rooms;
  final String apartmentId;

  const UnitRoomsSection({super.key, required this.rooms, required this.apartmentId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: context.colors.textPrimary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'تفاصيل الغرف والمساحات',
                style: TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          if (rooms.isEmpty)
            _buildEmptyState(context)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rooms.length,
              separatorBuilder: (context, index) =>
                  SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final room = rooms[index];
                return _buildRoomItem(context, room);
              },
            ),
        ],
      ),
    );


  }

  Widget _buildRoomItem(BuildContext context, UnitRoomEntity room) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: context.colors.border.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await context.push(AppRouter.roomDetails, extra: {
              'room': room,
              'apartmentId': int.parse(apartmentId),
              'unitRooms': rooms,
            });
            if (context.mounted) {
              context.read<UnitDetailsCubit>().refreshFinishingCost();
            }
          },
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconForRoomType(room.type),
              color: context.colors.gold,
              size: 20,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                if (room.typeLabel != room.name && room.typeLabel.isNotEmpty)
                  Text(
                    room.typeLabel,
                    style: TextStyle(
                      fontSize: AppFonts.labelSmall,
                      color: context.colors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                room.area > 0 ? '${room.area} م²' : 'غير محددة',
                style: TextStyle(
                  fontSize: AppFonts.bodyMedium,
                  fontWeight: FontWeight.bold,
                  color: room.area > 0
                      ? context.colors.primary
                      : context.colors.textSecondary,
                ),
              ),
              if (room.length != null && room.width != null)
                Text(
                  '${room.length} × ${room.width}',
                  style: TextStyle(
                    fontSize: AppFonts.labelSmall,
                    color: context.colors.textSecondary,
                  ),
                ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForRoomType(String type) {
    switch (type) {
      case 'bedroom':
        return FluentIcons.bed_24_regular;
      case 'bathroom':
        return FluentIcons.drop_24_regular;
      case 'kitchen':
        return FluentIcons.food_24_regular;
      case 'living_room':
        return FluentIcons.tv_24_regular;
      case 'men_majlis':
      case 'women_majlis':
        return FluentIcons.conference_room_24_regular;
      case 'laundry':
        return FluentIcons.weather_blowing_snow_24_regular; // placeholder for laundry
      case 'entrance':
        return FluentIcons.door_arrow_left_24_regular;
      default:
        return FluentIcons.building_24_regular;
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: context.colors.primary.withValues(alpha: 0.1),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              FluentIcons.board_24_regular,
              size: 32,
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'لم يتم إدراج المخطط التفصيلي',
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'جاري تحديث بيانات الغرف والمساحات الداخلية لهذه الوحدة وسيتم توفيرها قريباً.',
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              color: context.colors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
