import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/common/widgets/dot_loading_widget.dart';
import 'package:shopping/features/feature_home/data/models/home_model.dart';
import 'package:shopping/features/feature_home/presentation/bloc/cubit/home_cubit.dart';
import 'package:shopping/features/feature_home/presentation/bloc/cubit/home_data_status.dart';
import 'package:shopping/locator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(locator()),
      child: Builder(
        builder: (context) {
          BlocProvider.of<HomeCubit>(context).callHomeDataEvent();
          return BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) {
              if (previous.homeDataStatus == current.homeDataStatus) {
                return false;
              }
              return true;
            },
            builder: (context, state) {
              /// loading
              if (state.homeDataStatus is HomeDataLoading) {
                return const Center(child: DotLoadingWidget(size: 30));
              }
              // completed
              if (state.homeDataStatus is HomeDataCompleted) {
                HomeDataCompleted homeDataCompleted =
                    state.homeDataStatus as HomeDataCompleted;
                HomeModel homeModel = homeDataCompleted.homeModel;
                return Center(
                  child: Text(
                    homeModel.data!.banners![0].image ?? '',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }

              /// error
              if (state.homeDataStatus is HomeDataError) {
                final HomeDataError homeDataError =
                    state.homeDataStatus as HomeDataError;

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        homeDataError.errorMessage,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     primary: Colors.amber.shade800,
                      //   ),
                      //   onPressed: () {
                      //     /// call all data again
                      //     BlocProvider.of<HomeCubit>(
                      //       context,
                      //     ).callHomeDataEvent(lat, lon);
                      //   },
                      //   child: const Text("تلاش دوباره"),
                      // ),
                    ],
                  ),
                );
              }
              return Container();
            },
          );
        },
      ),
    );
  }
}
