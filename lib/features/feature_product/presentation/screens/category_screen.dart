import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/common/arguments/products_arguments.dart';
import 'package:shopping/common/widgets/dot_loading_widget.dart';
import 'package:shopping/features/feature_product/data/models/categories_model.dart';
import 'package:shopping/features/feature_product/presentation/bloc/category_cubit/category_cubit.dart';
import 'package:shopping/features/feature_product/presentation/bloc/category_cubit/category_data_status.dart';
import 'package:shopping/features/feature_product/presentation/screens/all_product_screen.dart';
import 'package:shopping/locator.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryCubit(locator())..loadCategoryEvent(),
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          /// loading
          if (state.categoryDataStatus is CategoryDataLoading) {
            return Center(child: DotLoadingWidget(size: 30));
          }

          /// completed
          if (state.categoryDataStatus is CategoryDataCompleted) {
            CategoryDataCompleted categoryDataCompleted =
                state.categoryDataStatus as CategoryDataCompleted;
            CategoriesModel categoriesModel =
                categoryDataCompleted.categoriesModel;
            return ListView.separated(
              padding: const EdgeInsets.only(top: 20),
              itemBuilder: (context, index) {
                Data categoryData = categoriesModel.data![index];
                final imageUrl = categoryData.icon ?? categoryData.img;

                /// text
                return GestureDetector(
                  onTap: () {
                    /// goto All products screen
                    Navigator.pushNamed(
                      context,
                      AllProductsScreen.routeName,
                      arguments: ProductsArguments(
                        categoryId: categoryData.id!,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        // boxShadow: const [
                        //   BoxShadow(
                        //       blurRadius: 10,
                        //       offset: Offset(5, 5),
                        //       color: Colors.grey
                        //   )
                        // ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: imageUrl == null
                                      ? const SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: Icon(Icons.category_outlined),
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                          useOldImageOnUrlChange: true,
                                          errorWidget: (_, __, ___) =>
                                              const Icon(
                                                Icons.error,
                                                color: Colors.black,
                                              ),
                                        ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  categoryData.title!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Vazir',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_back_ios_new,
                              size: 15,
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemCount: categoriesModel.data!.length,
            );
          }

          /// Error
          if (state.categoryDataStatus is CategoryDataError) {
            final CategoryDataError categoryDataError =
                state.categoryDataStatus as CategoryDataError;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    categoryDataError.errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Vazir',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade800,
                    ),
                    onPressed: () {
                      /// call all data again
                      BlocProvider.of<CategoryCubit>(
                        context,
                      ).loadCategoryEvent();
                    },
                    child: const Text("تلاش دوباره"),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
