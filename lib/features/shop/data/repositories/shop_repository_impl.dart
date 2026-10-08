import 'package:fpdart/fpdart.dart';
import '../../../../core/data/hive_database.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/shop.dart';
import '../../domain/repositories/shop_repository.dart';
import '../models/shop_model.dart';

class ShopRepositoryImpl implements ShopRepository {
  static const String shopKey = 'shop_details';

  @override
  Future<Either<Failure, Shop>> getShop() async {
    try {
      final box = HiveDatabase.shopBox;
      final shop = box.get(shopKey);
      if (shop != null) {
        return Right(shop);
      } else {
        // Return default shop if not found
        return const Right(Shop(
            name: 'متجر التجزئة',
            addressLine1: 'شارع التحرير، وسط البلد',
            addressLine2: 'القاهرة',
            phoneNumber: '01000000000',
            upiId: '',
            footerText: 'شكراً لزيارتكم، نراكم قريباً'));
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateShop(Shop shop) async {
    try {
      final box = HiveDatabase.shopBox;
      final model = ShopModel.fromEntity(shop);
      await box.put(shopKey, model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
