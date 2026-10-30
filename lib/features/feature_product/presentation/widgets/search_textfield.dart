import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shopping/common/blocs/bottom_nav_cubit/searchbox_cubit.dart';
import 'package:shopping/features/feature_product/repositories/all_products_repository.dart';

import '../../../../common/params/products_params.dart';
import '../../data/models/all_products_model.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final AllProductsRepository allProductsRepository;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.allProductsRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchboxCubit(),
      child: Builder(
        builder: (context) {
          return Material(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                /// text field
                SizedBox(
                  height: 40,
                  child: TypeAheadField<Products>(
                    controller: controller,
                    suggestionsCallback: (String prefix) {
                      return allProductsRepository.fetchAllProductsDataSearch(
                        ProductsParams(step: 6, search: prefix),
                      );
                    },
                    itemBuilder: (context, Products model) {
                      return ListTile(
                        title: Text(
                          model.name ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    },
                    onSelected: (Products product) {
                      controller.text = product.name ?? '';
                    },
                    emptyBuilder: (context) => const ListTile(
                      title: Text('محصولی یافت نشد.'),
                    ),
                    // Optional: gives the suggestion list a card look.
                    decorationBuilder: (context, child) => Material(
                      type: MaterialType.card,
                      elevation: 4,
                      borderRadius: BorderRadius.circular(12),
                      child: child,
                    ),
                    builder: (context, textController, focusNode) {
                      return TextField(
                        controller: textController,
                        focusNode: focusNode,
                        onTap: () {
                          context.read<SearchboxCubit>().changeVisibility(false);

                          // Old hack kept: make sure the text ends with a space.
                          // The isNotEmpty check avoids a RangeError on empty text.
                          final text = textController.text;
                          if (text.isNotEmpty && !text.endsWith(' ')) {
                            textController.text = '$text ';
                          }
                        },
                        onSubmitted: (String prefix) {
                          // Navigator.pushNamed(
                          //   context,
                          //   AllProductsScreen.routeName,
                          //   arguments: ProductsArguments(searchTxt: prefix),
                          // );
                        },
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          contentPadding: const EdgeInsets.all(3),
                          prefixIcon: IconButton(
                            icon: const Icon(Icons.search, color: Colors.grey),
                            onPressed: () {
                              // Navigator.pushNamed(
                              //   context,
                              //   AllProductsScreen.routeName,
                              //   arguments: ProductsArguments(
                              //     searchTxt: textController.text,
                              //   ),
                              // );
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 0.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 0.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// hint text and logo
                IgnorePointer(
                  child: BlocBuilder<SearchboxCubit, bool>(
                    builder: (context, state) {
                      return Visibility(
                        visible: state,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 50.0),
                          child: Row(
                            children: [
                              const Text(
                                'جستوجو در',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Yekan',
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                              ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.grey.shade800,
                                  BlendMode.srcIn,
                                ),
                                child: Image.asset(
                                  'assets/images/bs_logo_textfield.png',
                                  height: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}