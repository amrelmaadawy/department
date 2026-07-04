---
trigger: always_on
---

# GLOBAL ANTIGRAVITY RULES — REAL ESTATE ERP & CUSTOMER JOURNEY PLATFORM

## 1. Architecture
- Follow Clean Architecture only.
- Layers: Presentation, Domain, Data.
- Dependencies point inward.
- No cross-layer violations, UI business logic, or direct feature coupling.
- Shared logic belongs to Core; features communicate through abstractions.

## 2. Development
- Feature-Driven Development.
- Every feature is self-contained (data/domain/presentation).
- Shared business logic only through Core interfaces.
- Integrate with existing architecture before coding.

## 3. Feature Structure
No deviations.

## 4. Reuse First
Before creating new code: inspect architecture, constants, theme, localization, shared widgets, reusable implementations. Reuse first; duplicates forbidden.

## 5. File Size
- Max 150 lines/file.
- Split large widgets, cubits, services, files.

## 6. Code Quality
- Clean, DRY, SOLID.
- No dead code, unused imports, magic values, duplicated logic.
- Prefer composition.

## 7. Naming
Screen→HomeScreen, View→HomeView, Widget→PropertyCard, Cubit→PropertyCubit, State→PropertyState, Entity→PropertyEntity, Model→PropertyModel, Repository→PropertyRepository, UseCase→GetPropertyUseCase.

## 8. State Management
- Cubit by default.
- Bloc only for complex flows.
- Immutable Equatable states.
- No business logic inside UI.
- Side effects outside widgets.

## 9. Dependency Injection
- GetIt only.
- Central registration.
- No manual dependency creation.

## 10. Networking
- Dio only.
- Requests through interceptors (Auth, Logging, Error).
- Centralized endpoints.
- No endpoint strings inside features.

## 11. API
- Typed request/response models.
- Strong JSON parsing.
- No dynamic responses.
- API changes isolated in Data layer.

## 12. Errors
- Map exceptions to Failures.
- Friendly UI errors.
- Every async flow: loading/success/error.

## 13. Security
- No plaintext secrets.
- Secure Storage for tokens.
- No hardcoded API keys, URLs, or secrets.
- Validate all input.

## 14. Configuration
- Environment-based configs: Dev, Staging, Production.
- Centralized configuration.

## 15. Local Storage
- Abstracted behind repositories.
- UI never accesses storage directly.
- Replaceable implementation.

## 16. Cache
- Explicit cache policy.
- Repository-managed.
- Defined invalidation rules.
- UI never manages cache.

## 17. Data Consistency
- Single Source of Truth.
- Repository controls mutations.
- Keep state/storage synchronized.

## 18. Offline
- Abstract storage.
- Document sync & conflict resolution.

## 19. UI
- No hardcoded colors, sizes, radius, shadows.
- Use reusable Design System components.

## 20. Design System
- Colors→AppColors
- Fonts→AppFonts
- Spacing→AppSpacing
- Radius→AppRadius
- Icons→AppIcons
- Assets→Centralized Manager
- No direct values.

## 21. Typography
- Font sizes only from AppFonts.

## 22. Constants
Reuse centralized Strings, Routes, Keys, Durations, Sizes, Labels, Enums, Padding. Add missing values there only.

## 23. Localization
- Arabic & English.
- RTL support.
- No hardcoded text.
- All strings from localization files.

## 24. Responsive
Support Android/iOS phones, tablets, foldables, portrait/landscape, 320px+, adaptive layouts, no fixed dimensions.

## 25. Accessibility
- Scalable text.
- Accessible touch targets.
- Proper contrast.

## 26. Performance
- Avoid unnecessary rebuilds.
- Use const.
- Pagination.
- Cache images.
- Dispose controllers.
- Heavy work async.

 27. Performance Budget
- Fast loading.
- Paginate large datasets.
- Expensive logic belongs to Domain.
## 28. Customer Journey
- Show current/previous/next step, selected project/unit/package/materials, estimated cost.
- Support persistent progress, auto-save, resume later, real-time cost updates.

## 29. Cost Calculation
- Centralize all calculations.
- UI never calculates prices.
- Material changes instantly update material, package, additional, total finishing, and final costs.

## 30. AI Design
- Every design links to Project, Unit, Style, Package, Materials.
- Support Save, Compare, Regenerate, Favorite.

## 31. Core Protection
- Core changes require review.
- Features cannot bypass or directly modify Core.
- Shared logic belongs only to Core.

## 32. Testing
- Minimum: Repository, UseCase, Cubit tests.
- Cover Authentication, API, Cost Calculation, Customer Journey, State Management.

## 33. Logging
- Centralized logging.
- Different Debug/Release behavior.
- Log failures and business events.

## 34. Documentation
- Document Core, complex features, architecture decisions, and keep specs updated.

## 35. Migration
- Structural changes require migration plans.
- Consider backward compatibility.
- Version database changes.

## 36. Git
- No direct commits to main.
- Use feature branches, PRs, code reviews.
- Commit prefixes: feat, fix, refactor, docs, test, chore.

## 37. Release Readiness
A feature is complete only with Loading, Error, Empty states, Edge-case handling, Localization, Responsive support, Accessibility, Testing.

## 38. Prohibited
- No architecture violations.
- No hardcoded colors, fonts, strings, constants.
- No direct API/DB access from UI.
- No uncontrolled global state.
- No bypassing repositories.
- No Core modification without approval.

## 39. Final Enforcement
Reject any implementation violating architecture, design system, localization, responsiveness, security, testing, customer journey, or code quality.

# Additional Enterprise Rules

## 40. Navigation
- GoRouter only.
- Centralized routes.
- Route guards.
- Deep linking.
- No inline navigation.

## 41. Roles & Permissions
- Centralized RBAC.
- UI visibility follows permissions.
- Business rules never rely only on UI.
- Roles: Customer, Sales Agent, Project Manager, Admin, Super Admin, Supplier, Developer.

## 42. Design System First
Before building screens, reuse existing components, spacing, typography, patterns; duplicate widgets are forbidden.

## 43. Feature Specification
Before implementation define: User Story, Business Rules, States, API Contract, Edge Cases, Failure Scenarios.

## 44. Analytics
- Centralized analytics.
- Track major actions.
- Provider-independent.
- Events: Project/Unit viewed, Package/Material selected, Design generated, Contract signed, Payment completed.

## 45. Notifications
- Isolated notification layer.
- Provider-independent.
- Support Push, In-App, Email, SMS.

## 46. Payments
- Abstract payment layer.
- Depend on interfaces only.
- Replaceable providers (Paymob, Fawry, Stripe, Apple Pay, Google Pay).

## 47. Uploads
- Centralized upload manager.
- Progress, retry, recovery.
- Support Images, Documents, Contracts, Floor Plans, AI Designs.

## 48. Admin
Every entity supports CRUD, Search, Filter, Sort, Pagination.

## 49. Marketplace
Materials, Products, Suppliers, Packages are independent entities. Marketplace integration must not require architecture changes.

## 50. AI Independence
- AI services behind abstractions.
- Replaceable providers (OpenAI, Stability AI, Planner5D, RoomGPT, future providers).
- Business logic remains provider-agnostic.

## 51. Domain First
Business rules belong only to Domain through UseCases. UI, Data, Network contain no business logic.

## 52. Feature Flags
Support remote enable/disable, rollout strategies, Beta, AI, Marketplace, Payment features.

## 53. Vendor Lock Prevention
Wrap all external services behind abstractions (AI, Payments, Analytics, Notifications, Storage, Authentication).

## 54. Definition of Done
Complete only when architecture compliant, localized, responsive, accessible, loading/error/empty states implemented, analytics/logging integrated, tests written, documentation updated, code reviewed, no violations.

## 55. Enterprise Enforcement
Before coding: analyze architecture, features, constants, localization, design system, reusable widgets, repositories, use cases. Reuse first; create new only when necessary.

## 56. Device Compatibility
Support Android 10+, latest iOS, phones, tablets, multiple densities, RTL/LTR, dark/light themes, no UI breakage.

## 57. Images
Responsive images, multiple resolutions, lazy loading, caching, optimization, avoid full-size rendering.

## 58. Proactive Improvement
Act as Software Architect, Product Thinker, UX Reviewer.
Always evaluate better architecture, UX, security, scalability, maintainability, performance before implementation.
Explain improvements and trade-offs, then implement the best compatible solution.

## 59. Challenge Assumptions
Challenge decisions causing technical debt or poor scalability, maintainability, security, UX, or performance.
Recommend better alternatives.
Prioritize long-term maintainability over short-term speed.