import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transport_app/core/database/app_database.dart';
import 'package:transport_app/core/enums/location_type.dart';
import 'package:transport_app/core/enums/port_cfs_type.dart';
import 'package:transport_app/features/locations/data/location_repository.dart';
import 'package:transport_app/features/locations/domain/location_model.dart';
import 'package:transport_app/features/locations/presentation/location_view_model.dart';
import 'package:transport_app/features/parties/data/party_repository.dart';
import 'package:transport_app/features/parties/domain/party_model.dart';
import 'package:transport_app/features/parties/presentation/party_view_model.dart';
import 'package:transport_app/features/ports_cfs/data/port_cfs_repository.dart';
import 'package:transport_app/features/ports_cfs/domain/port_cfs_model.dart';
import 'package:transport_app/features/ports_cfs/presentation/port_cfs_view_model.dart';
import 'package:transport_app/features/shipping_lines/data/shipping_line_repository.dart';
import 'package:transport_app/features/shipping_lines/domain/shipping_line_model.dart';
import 'package:transport_app/features/shipping_lines/presentation/shipping_line_view_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('Party: persisted party data in SQLite is loaded into repository and ViewModel on restart', () async {
    // 1. Pre-populate SQLite with existing party data (simulating previously saved data)
    final now = DateTime.now();
    await db.into(db.localParties).insert(
          LocalPartiesCompanion.insert(
            id: 'pty-existing-1',
            partyName: 'Reliance Industries',
            customerMobile: '9876543210',
            email: const Value('reliance@test.com'),
            city: const Value('Mumbai'),
            createdAt: now,
          ),
        );

    // 2. Start up a new ProviderContainer (simulating app restart)
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
    );

    // 3. Read repository and view model
    final partyRepo = container.read(partyRepositoryProvider);
    container.read(partyViewModelProvider.notifier);

    // Wait for repository initialization from SQLite
    await partyRepo.initialized;

    // 4. Verify ViewModel has the persisted party data
    final partyState = container.read(partyViewModelProvider);
    expect(partyState.parties.length, 1);
    expect(partyState.parties.first.party.name, 'Reliance Industries');
    expect(partyState.parties.first.party.mobileNumber, '9876543210');

    container.dispose();
  });

  test('Shipping Line: persisted carrier data in SQLite is loaded into repository and ViewModel on restart', () async {
    // 1. Pre-populate SQLite with existing shipping lines
    final now = DateTime.now();
    await db.into(db.localShippingLines).insert(
          LocalShippingLinesCompanion.insert(
            id: 'shl-existing-1',
            name: 'Maersk Line',
            code: 'MAEU',
            createdAt: now,
          ),
        );

    // 2. Start up a new ProviderContainer (simulating app restart)
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
    );

    final shippingRepo = container.read(shippingLineRepositoryProvider);
    container.read(shippingLineViewModelProvider.notifier);

    await shippingRepo.initialized;

    final shippingState = container.read(shippingLineViewModelProvider);
    expect(shippingState.shippingLines.length, 1);
    expect(shippingState.shippingLines.first.name, 'Maersk Line');
    expect(shippingState.shippingLines.first.code, 'MAEU');

    container.dispose();
  });

  test('Location: persisted location data in SQLite is loaded into repository and ViewModel on restart', () async {
    // 1. Pre-populate SQLite with existing location
    final now = DateTime.now();
    await db.into(db.localLocations).insert(
          LocalLocationsCompanion.insert(
            id: 'loc-existing-1',
            name: 'JNPT Port Hub',
            locationType: 'port',
            createdAt: now,
          ),
        );

    // 2. Start up a new ProviderContainer (simulating app restart)
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
    );

    final locRepo = container.read(locationRepositoryProvider);
    container.read(locationViewModelProvider.notifier);

    await locRepo.initialized;

    final locState = container.read(locationViewModelProvider);
    expect(locState.locations.length, 1);
    expect(locState.locations.first.name, 'JNPT Port Hub');
    expect(locState.locations.first.type, LocationType.port);

    container.dispose();
  });

  test('Port/CFS: persisted port/cfs data in SQLite is loaded into repository and ViewModel on restart', () async {
    // 1. Pre-populate SQLite with existing port/CFS
    final now = DateTime.now();
    await db.into(db.localPortsCfs).insert(
          LocalPortsCfsCompanion.insert(
            id: 'pc-existing-1',
            name: 'Navi Mumbai CFS',
            type: 'CFS',
            location: 'Nhava Sheva',
            createdAt: now,
          ),
        );

    // 2. Start up a new ProviderContainer (simulating app restart)
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
    );

    final portRepo = container.read(portCfsRepositoryProvider);
    container.read(portCfsViewModelProvider.notifier);

    await portRepo.initialized;

    final portState = container.read(portCfsViewModelProvider);
    expect(portState.items.length, 1);
    expect(portState.items.first.name, 'Navi Mumbai CFS');
    expect(portState.items.first.type, PortCfsType.cfs);
    expect(portState.items.first.location, 'Nhava Sheva');

    container.dispose();
  });

  test('ViewModels update automatically when repos are modified or reloaded', () async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
    );

    final partyRepo = container.read(partyRepositoryProvider);
    final shippingRepo = container.read(shippingLineRepositoryProvider);
    final locRepo = container.read(locationRepositoryProvider);
    final portRepo = container.read(portCfsRepositoryProvider);

    await Future.wait([
      partyRepo.initialized,
      shippingRepo.initialized,
      locRepo.initialized,
      portRepo.initialized,
    ]);

    // Initial state is empty
    expect(container.read(partyViewModelProvider).parties, isEmpty);
    expect(container.read(shippingLineViewModelProvider).shippingLines, isEmpty);
    expect(container.read(locationViewModelProvider).locations, isEmpty);
    expect(container.read(portCfsViewModelProvider).items, isEmpty);

    // Add via repo directly (or from background sync / database reload)
    partyRepo.add(Party(
      id: 'pty-1',
      name: 'Tata Steel',
      mobileNumber: '9999988888',
      createdAt: DateTime.now(),
    ));

    shippingRepo.add(ShippingLine(
      id: 'shl-1',
      name: 'MSC Mediterranean',
      code: 'MSCU',
      createdAt: DateTime.now(),
    ));

    locRepo.add(Location(
      id: 'loc-1',
      name: 'Bhiwandi Warehouse',
      type: LocationType.warehouse,
      createdAt: DateTime.now(),
    ));

    portRepo.add(PortCfs(
      id: 'pc-1',
      name: 'Mundra Port',
      type: PortCfsType.port,
      location: 'Gujarat',
      createdAt: DateTime.now(),
    ));

    // Verify all ViewModels updated immediately via listeners without calling loadX()
    expect(container.read(partyViewModelProvider).parties.length, 1);
    expect(container.read(partyViewModelProvider).parties.first.party.name, 'Tata Steel');

    expect(container.read(shippingLineViewModelProvider).shippingLines.length, 1);
    expect(container.read(shippingLineViewModelProvider).shippingLines.first.code, 'MSCU');

    expect(container.read(locationViewModelProvider).locations.length, 1);
    expect(container.read(locationViewModelProvider).locations.first.name, 'Bhiwandi Warehouse');

    expect(container.read(portCfsViewModelProvider).items.length, 1);
    expect(container.read(portCfsViewModelProvider).items.first.name, 'Mundra Port');

    container.dispose();
  });
}
