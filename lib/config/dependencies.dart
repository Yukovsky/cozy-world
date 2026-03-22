import 'package:common_locale_data/ru.dart';
import 'package:cozy_world/data/services/i_connection_service.dart';
import 'package:cozy_world/presentation/modules/counter/controllers/hearts_animation_controller.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:strings_api/data_strings_repository.dart';
import 'package:strings_api/domain_strings_repository.dart';
import 'package:strings_api/presentation_strings_repository.dart';

import 'package:strings_impl/strings_impl.dart';

import 'package:dates_api/dates_api.dart';
import 'package:dates_impl/dates_impl.dart';
import 'package:cozy_world/data/datasources/local/i_storage_datasource.dart';
import 'package:cozy_world/data/implementations/datasources/local/storage_datasource.dart';
import 'package:cozy_world/data/implementations/repositories/dirty_manager_repository_impl.dart';
import 'package:cozy_world/data/implementations/repositories/support_repository_impl.dart';
import 'package:cozy_world/data/implementations/services/ferry_connection_service_impl.dart';
import 'package:cozy_world/data/datasources/local/i_secure_storage_datasource.dart';
import 'package:cozy_world/data/implementations/datasources/local/secure_storage_datasource.dart';
import 'package:cozy_world/data/implementations/repositories/config_repository_impl.dart';
import 'package:cozy_world/data/implementations/repositories/relationship_repository_impl.dart';

import 'package:cozy_world/domain/repositories/i_data_state_repository.dart';
import 'package:cozy_world/domain/repositories/i_support_repository.dart';
import 'package:cozy_world/domain/usecases/change_message_read_status_usecase.dart';
import 'package:cozy_world/domain/usecases/compute_all_elapsed_usecase.dart';
import 'package:cozy_world/domain/usecases/get_categories_usecase.dart';
import 'package:cozy_world/domain/usecases/get_category_messages_usecase.dart';
import 'package:cozy_world/domain/usecases/get_relationship_dates_usecase.dart';
import 'package:cozy_world/domain/usecases/get_today_message_usecase.dart';
import 'package:cozy_world/domain/repositories/i_config_repository.dart';
import 'package:cozy_world/domain/repositories/i_relationship_dates_repository.dart';
import 'package:cozy_world/domain/usecases/compute_elapsed_usecase.dart';

import 'package:cozy_world/presentation/modules/support/controllers/categories_controller.dart';
import 'package:cozy_world/presentation/modules/support/controllers/change_read_status_controller.dart';
import 'package:cozy_world/presentation/modules/support/controllers/today_message_controller.dart';
import 'package:cozy_world/presentation/services/i_app_router_service.dart';
import 'package:cozy_world/presentation/modules/counter/controllers/counter_controller.dart';
import 'package:cozy_world/presentation/modules/history/history_controller.dart';
import 'package:cozy_world/presentation/routes/app_navigator.dart';
import 'package:cozy_world/presentation/routes/app_router.dart';
import 'package:cozy_world/presentation/routes/navigation_controller.dart';

Future<void> setupDependencies() async {
  await setupStrings();
  await setupDataLayer();
  await setupDomainLayer();
  await setupPresentationLayer();
}

Future<void> setupStrings() async {
  Get.put<DataStringsRepository>(DataStringsImpl(), permanent: true);

  Get.put<DomainStringsRepository>(DomainStringsImpl(), permanent: true);

  Get.put<PresentationStringsRepository>(
    PresentationStringsImpl(),
    permanent: true,
  );
}

Future<void> setupDataLayer() async {
  await GetStorage.init();

  Get.lazyPut<IDatesDatasource>(() => HardcodedDatesDataSource());

  Get.lazyPut<ISecureStorageDataSource>(
    () => SecureStorageDatasource(FlutterSecureStorage()),
  );

  Get.lazyPut<IStorageDatasource>(() => StorageDatasource(GetStorage()));

  Get.lazyPut<IConfigRepository>(
    () => ConfigRepositoryImpl(Get.find<ISecureStorageDataSource>()),
  );

  Get.putAsync<IConnectionService>(() async {
    final clientController = FerryConnectionService(
      Get.find<IConfigRepository>(),
      Get.find<DataStringsRepository>(),
    );
    await clientController.initClient();
    return clientController;
  }, permanent: true);

  // Get.lazyPut<IStorageRepository>(
  //   () => StorageRepositoryImpl(Get.find<IStorageDatasource>()),
  // );

  Get.lazyPut<IRelationshipDatesRepository>(
    () => RelationshipDateRepositoryImpl(
      Get.find<IDatesDatasource>(),
      Get.find<DataStringsRepository>(),
    ),
  );

  Get.put<IDataStateRepository>(DirtyManagerRepositoryImpl(), permanent: true);

  Get.lazyPut<ISupportRepository>(
    () => FerrySupportRepositoryImpl(
      clientService: Get.find<IConnectionService>(),
      strings: Get.find<DataStringsRepository>(),
    ),
  );
}

Future<void> setupDomainLayer() async {
  Get.lazyPut(() => ComputeElapsedUseCase(Get.find<DomainStringsRepository>()));

  Get.lazyPut(
    () => GetRelationshipDatesUseCase(
      Get.find<IRelationshipDatesRepository>(),
      Get.find<DomainStringsRepository>(),
    ),
  );

  Get.lazyPut(
    () => ComputeAllElapsedUseCase(Get.find<ComputeElapsedUseCase>()),
  );

  Get.lazyPut(
    () => GetCategoriesUsecase(
      Get.find<ISupportRepository>(),
      Get.find<IDataStateRepository>(),
    ),
  );

  Get.lazyPut(
    () => GetCategoryMessagesUsecase(
      Get.find<ISupportRepository>(),
      Get.find<IDataStateRepository>(),
    ),
  );

  Get.lazyPut(() => GetTodayMessageUsecase(Get.find<ISupportRepository>()));

  Get.lazyPut(
    () => ChangeMessageReadStatusUseCase(
      Get.find<ISupportRepository>(),
      Get.find<IDataStateRepository>(),
      Get.find<DomainStringsRepository>(),
    ),
  );
}

Future<void> setupPresentationLayer() async {
  Get.put(
    AppRouterDelegate(Get.find<PresentationStringsRepository>()),
    permanent: true,
  );

  Get.lazyPut(() => CommonLocaleDataRu());

  Get.lazyPut(
    () => CounterController(
      Get.find<ComputeAllElapsedUseCase>(),
      Get.find<GetRelationshipDatesUseCase>(),
      Get.find<PresentationStringsRepository>(),
    ),
  );

  Get.put<IAppRouterService>(
    AppNavigator(delegate: Get.find<AppRouterDelegate>()),
    permanent: true,
  );

  Get.lazyPut(
    () => NavigationController(appNavigator: Get.find<IAppRouterService>()),
  );

  Get.lazyPut(
    () => CategoriesController(
      getCategoriesUsecase: Get.find<GetCategoriesUsecase>(),
      dataStateRepository: Get.find<IDataStateRepository>(),
    ),
  );

  Get.lazyPut(
    () => TodayMessageController(
      getTodayMessageUsecase: Get.find<GetTodayMessageUsecase>(),
    ),
  );

  Get.lazyPut(
    () => ChangeReadStatusController(
      changeMessageReadStatusUseCase:
          Get.find<ChangeMessageReadStatusUseCase>(),
      strings: Get.find<PresentationStringsRepository>(),
    ),
  );

  Get.lazyPut(
    () => HistoryController(Get.find<PresentationStringsRepository>()),
  );

  Get.lazyPut(() => CardSwiperController());

  Get.lazyPut(() => HeartsAnimationController());
}
