import 'package:goodali/models/products_model.dart';

class PodcastState {
  const PodcastState(this.products, this.fetched);
  final List<Products> products;
  final bool fetched;
}
