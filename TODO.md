# TODO

- [ ] (1) Update Pet model + PetService to support size/gender/birthDate so AddPetProfileScreen is accurate.
- [ ] (2) Fix appointment booking to use the user’s real pets (remove unknown_pet) by fetching user pets in BookAppointmentScreen.
- [ ] (3) Ensure booking is written to Firestore as part of the appointment flow coming from AppointmentScreen.
- [ ] (4) Move order recording from PaymentSuccessScreen into CheckoutScreen after Stripe payment succeeds.
- [ ] (5) Prevent duplicate order writes by disabling/removing recording in PaymentSuccessScreen.
- [ ] (6) Optionally update user doc with orderIds in OrderService.recordPaidOrder.
- [ ] (7) Run `flutter analyze` and do a quick manual smoke test (add pet, book appointment, checkout).

