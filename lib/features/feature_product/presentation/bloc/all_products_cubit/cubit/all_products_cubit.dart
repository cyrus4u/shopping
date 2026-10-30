import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shopping/common/params/products_params.dart';
import 'package:shopping/common/resources/data_state.dart';
import 'package:shopping/config/app_logger.dart';
import 'package:shopping/features/feature_product/data/models/all_products_model.dart';
import 'package:shopping/features/feature_product/repositories/all_products_repository.dart';



part 'all_products_state.dart';
part 'products_data_status.dart';

class AllProductsCubit extends Cubit<AllProductsState> {
  AllProductsRepository allProductsRepository;
  AllProductsCubit(this.allProductsRepository) : super(AllProductsState(
      productsDataStatus: ProductsDataLoading(),
      allProducts: [],
      nextStart: 0,
      isLoadingPaging: false
  ));


  Future<void> loadProductsData(ProductsParams productsParams) async {
  // Ignore extra scroll events while a page is already loading.
  if (state.isLoadingPaging) return;

  if (state.nextStart == 0) {
    emit(state.copyWith(newProductsDataStatus: ProductsDataLoading()));
  } else {
    emit(state.copyWith(newIsLoadingPaging: true));
  }

  productsParams.start = state.nextStart;

  try {
    final DataState<AllProductsModel> dataState =
        await allProductsRepository.fetchAllProductsData(productsParams);

    if (isClosed) return;

    if (dataState is DataSuccess<AllProductsModel>) {
      final model = dataState.data!;
      final page = model.data?.firstOrNull;
      final newProducts = page?.products ?? const <Products>[];

      emit(state.copyWith(
        newProductsDataStatus: ProductsDataCompleted(model),
        newAllProducts: [...state.allProducts, ...newProducts], // new list
        newNextStart: page?.nextStart ?? state.nextStart,
        newIsLoadingPaging: false,
      ));
    } else if (dataState is DataFailed<AllProductsModel>) {
      emit(state.copyWith(
        newProductsDataStatus: ProductsDataError(dataState.error!),
        newIsLoadingPaging: false,
      ));
    }
  } catch (e, st) {
    AppLogger.error(
      'loadProductsData failed',
      error: e,
      stackTrace: st,
      name: 'AllProductsCubit',
    );
    if (!isClosed) {
      emit(state.copyWith(
        newProductsDataStatus: ProductsDataError('Something went wrong.'),
        newIsLoadingPaging: false,
      ));
    }
  }
}
}