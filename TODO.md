# TODO

- [ ] Fix notification permission flow in `lib/pages/onboarding_screen.dart`:
  - [x] Remove debug typo `statuss` and ensure correct permission status is used.
  - [x] Request notification permission and wait for result before showing dialog.
  - [ ] Handle non-supported platforms gracefully (e.g., status = PermissionStatus.denied/restricted).
  - [x] Keep UX: show dialog result, then continue to home.

- [ ] Run `flutter analyze` (if feasible) to confirm no compile errors.
