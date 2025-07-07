import 'package:dio/dio.dart';
import 'package:mukai/constants.dart';
import 'package:mukai/utils/helper/helper_controller.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: '${EnvConstants.APP_API_ENDPOINT}',
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // You can show a loading indicator here
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // You can hide loading indicator here
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          _handleTimeout(error);
        } else if (error.type == DioExceptionType.badResponse) {
          _handleBadResponse(error);
        } else if (error.type == DioExceptionType.unknown) {
          _handleNetworkFailure(error);
        }
        return handler.next(error); // continue to let error propagate
      },
    ));
  }

  void _handleTimeout(DioException error) {
    // Handle timeout: show snackbar/dialog, log, etc
    print("Timeout occurred: ${error.message}");
  }

  void _handleNetworkFailure(DioException error) {
    // No internet, server unreachable, etc
    // Helper.successSnackBar(
    //     title: 'You are currently offline!',
    //     message: 'Check internet connection',
    //     duration: 10);
  }

  void _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    print("Server responded with $statusCode: ${error.response?.data}");
    // Helper.successSnackBar(
    //     title: 'Services Response',
    //     message: 'Server services did not complete. Retrying ...',
    //     duration: 10);
  }
}
