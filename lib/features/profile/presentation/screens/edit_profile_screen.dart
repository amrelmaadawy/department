import 'package:apartment/features/profile/domain/usecases/update_profile_params.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/presentation/widgets/network_action_guard.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';

import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _bioController = TextEditingController();

  String? _selectedAvatarPath;
  bool _isInitialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _initControllers(ProfileLoaded state) {
    if (_isInitialized) return;
    _nameController.text = state.profile.user.name;
    _emailController.text = state.profile.user.email;
    _phoneController.text = state.profile.user.phone!;
    _addressController.text = state.profile.user.address ?? '';
    _bioController.text = state.profile.user.bio ?? '';
    _isInitialized = true;
  }

  void _onSave(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final params = UpdateProfileParams(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        bio: _bioController.text.trim(),
        avatarPath: _selectedAvatarPath,
      );

      context.read<ProfileCubit>().updateProfile(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        title: Text(
          l10n.profileMenuEditProfile,
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: AppFonts.headlineSmall,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(FluentIcons.ios_arrow_rtl_24_regular,
              color: context.colors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            AppToast.show(context,
                message: l10n.updateProfileSuccess, isError: false);
            context.pop(); // Go back after successful update
          } else if (state is ProfileUpdateError) {
            AppToast.show(context, message: state.message, isError: true);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoaded || state is ProfileUpdateLoading || state is ProfileUpdateError) {
            // Just init if it's loaded
            if (state is ProfileLoaded) {
              _initControllers(state);
            }

            final isLoading = state is ProfileUpdateLoading;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    /*
                    // Avatar
                    Center(
                      child: GestureDetector(
                        onTap: isLoading ? null : _pickImage,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: context.colors.gold, width: 3),
                                color: context.colors.white,
                                image: _selectedAvatar != null
                                    ? DecorationImage(
                                        image: FileImage(_selectedAvatar!),
                                        fit: BoxFit.cover,
                                      )
                                    : (_currentAvatarUrl != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                _currentAvatarUrl!),
                                            fit: BoxFit.cover,
                                          )
                                        : null),
                              ),
                              child: _selectedAvatar == null &&
                                      _currentAvatarUrl == null
                                  ? Center(
                                      child: Icon(FluentIcons.person_48_regular,
                                          size: 60,
                                          color: context.colors.textSecondary),
                                    )
                                  : null,
                            ),
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: context.colors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: context.colors.white, width: 2),
                              ),
                              child: Icon(FluentIcons.camera_24_regular,
                                  color: context.colors.white, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    */

                    // Form Fields
                    CustomTextField(
                      controller: _nameController,
                      label: l10n.fullName,
                      hint: 'Ahmed Al-Attar',
                      icon: FluentIcons.person_24_regular,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return l10n.requiredField;
                        }
                        return null;
                      },
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    CustomTextField(
                      controller: _emailController,
                      label: l10n.email,
                      hint: 'ahmed.alattar@example.com',
                      icon: FluentIcons.mail_24_regular,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return l10n.requiredField;
                        }
                        if (!val.contains('@')) {
                          return l10n.invalidEmail;
                        }
                        return null;
                      },
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    CustomTextField(
                      controller: _phoneController,
                      label: l10n.phoneNumber,
                      hint: '+966 50 123 4567',
                      icon: FluentIcons.phone_24_regular,
                      keyboardType: TextInputType.phone,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return l10n.requiredField;
                        }
                        return null;
                      },
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    CustomTextField(
                      controller: _addressController,
                      label: l10n.address,
                      hint: 'الرياض، المملكة العربية السعودية',
                      icon: FluentIcons.location_24_regular,
                      enabled: !isLoading,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    CustomTextField(
                      controller: _bioController,
                      label: l10n.bio,
                      hint: 'Interior Design Enthusiast',
                      icon: FluentIcons.text_description_24_regular,
                      maxLines: 3,
                      enabled: !isLoading,
                    ),

                    const SizedBox(height: AppSpacing.xxxl * 1.5),

                    // Save Button
                    NetworkActionGuard(
                      child: CustomButton(
                        text: l10n.saveChanges,
                        isLoading: isLoading,
                        onPressed: () => _onSave(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
