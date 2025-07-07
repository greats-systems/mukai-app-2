import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mukai/brick/models/financial-article.model.dart';
import 'package:mukai/constants.dart';

class FinancialArticleController extends GetxController {
  final dio = Dio();
  final isLoading = false.obs;
  final selectedArticle = FinancialArticle().obs;
  final articles = <FinancialArticle>[].obs;

  Future<void> createArticle() async {
    isLoading.value = true;
    try {
      final response = await dio.post(
        '${EnvConstants.APP_API_ENDPOINT}/financial_articles',
        data: selectedArticle.value.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'apikey': GetStorage().read('accessToken'),
            'Authorization': 'Bearer ${GetStorage().read('accessToken')}',
          },
        ),
      );
      if (response.statusCode == 201) {
        articles.add(FinancialArticle.fromJson(response.data));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create article: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<FinancialArticle>?> getArticles() async {
    isLoading.value = true;
    try {
      final response = await dio.get(
        '${EnvConstants.APP_API_ENDPOINT}/financial_articles',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'apikey': GetStorage().read('accessToken'),
            'Authorization': 'Bearer ${GetStorage().read('accessToken')}',
          },
        ),
      );
      if (response.statusCode == 200) {
        articles.value = (response.data as List)
            .map((item) => FinancialArticle.fromJson(item))
            .toList();
        return articles;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch articles: $e');
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<FinancialArticle?> getArticleById(String id) async {
    isLoading.value = true;
    try {
      final response = await dio.get(
        '${EnvConstants.APP_API_ENDPOINT}/financial_articles/$id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'apikey': GetStorage().read('accessToken'),
            'Authorization': 'Bearer ${GetStorage().read('accessToken')}',
          },
        ),
      );
      if (response.statusCode == 200) {
        selectedArticle.value = FinancialArticle.fromJson(response.data);
        return selectedArticle.value;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch article: $e');
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<void> updateArticle(String id) async {
    isLoading.value = true;
    try {
      final response = await dio.patch(
        '${EnvConstants.APP_API_ENDPOINT}/financial_articles/$id',
        data: selectedArticle.value.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'apikey': GetStorage().read('accessToken'),
            'Authorization': 'Bearer ${GetStorage().read('accessToken')}',
          },
        ),
      );
      if (response.statusCode == 200) {
        int index = articles.indexWhere((article) => article.id == id);
        if (index != -1) {
          articles[index] = FinancialArticle.fromJson(response.data);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update article: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
