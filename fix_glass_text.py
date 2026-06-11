import os

# Fix welcome_screen.dart
f1 = "lib/features/app_startup/presentation/screens/welcome_screen.dart"
with open(f1, "r", encoding="utf-8") as f:
    c1 = f.read()

c1 = c1.replace(
    "color: context.colors.white.withValues(alpha: 0.1),",
    "color: Colors.white.withValues(alpha: 0.1),"
)
c1 = c1.replace(
    "color: context.colors.white.withValues(alpha: 0.2),",
    "color: Colors.white.withValues(alpha: 0.2),"
)
c1 = c1.replace(
    """                                        Text(
                                          l10n.welcomeSubtitle,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: context.colors.white,""",
    """                                        Text(
                                          l10n.welcomeSubtitle,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,"""
)

with open(f1, "w", encoding="utf-8") as f:
    f.write(c1)


# Fix onboarding_screen.dart
f2 = "lib/features/onboarding/presentation/screens/onboarding_screen.dart"
with open(f2, "r", encoding="utf-8") as f:
    c2 = f.read()

c2 = c2.replace(
    "foregroundColor: context.colors.white,",
    "foregroundColor: Colors.white,"
)
c2 = c2.replace(
    "color: context.colors.white.withValues(alpha: 0.1),",
    "color: Colors.white.withValues(alpha: 0.1),"
)
c2 = c2.replace(
    "color: context.colors.white.withValues(alpha: 0.2),",
    "color: Colors.white.withValues(alpha: 0.2),"
)
c2 = c2.replace(
    "color: context.colors.white.withValues(alpha: 0.3),",
    "color: Colors.white.withValues(alpha: 0.3),"
)
c2 = c2.replace(
    """                            child: Text(
                              onboardingData[_currentIndex]['subtitle']!,
                              key: ValueKey<String>(onboardingData[_currentIndex]['subtitle']!),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: context.colors.white,""",
    """                            child: Text(
                              onboardingData[_currentIndex]['subtitle']!,
                              key: ValueKey<String>(onboardingData[_currentIndex]['subtitle']!),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,"""
)
c2 = c2.replace(
    """                                            Text(
                                            l10n.startNow,
                                            style: TextStyle(
                                              color: context.colors.white,""",
    """                                            Text(
                                            l10n.startNow,
                                            style: TextStyle(
                                              color: Colors.white,"""
)
c2 = c2.replace(
    """                                        : Icon(
                                            Icons.arrow_forward_ios,
                                                color: context.colors.white,""",
    """                                        : Icon(
                                            Icons.arrow_forward_ios,
                                                color: Colors.white,"""
)

with open(f2, "w", encoding="utf-8") as f:
    f.write(c2)

print("Done")
