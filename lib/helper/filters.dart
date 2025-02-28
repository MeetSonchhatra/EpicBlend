import 'package:photo_editor/model/filter.dart';

class Filters {
  List<Filter> list() {
    return <Filter>[
      Filter(
        'Original', 
        [
          1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 0, 1, 0, 0,
          0, 0, 0, 1, 0,
        ],
      ),
      Filter(
        'Royal Violet', 
        [
          1, -0.2, 0, 0, 0,
          0, 1, 0, -0.1, 0,
          0, 1.2, 1, 0.1, 0,
          0, 0, 1.7, 1, 0,
        ],
      ),
      Filter(
        'Golden Hour', 
        [
          1, 0, 0, 0, 0,
          -0.2, 1.0, 0.3, 0.1, 0,
          -0.1, 0, 1, 0, 0,
          0, 0, 0, 1, 0,
        ],
      ),
      Filter(
        'Aqua Glow', 
        [
          1, 0, 0, 1.9, -2.2,
          0, 1, 0, 0.0, 0.3,
          0, 0, 1, 0, 0.5,
          0, 0, 0, 1, 0.2,
        ],
      ),
      Filter(
        'Monochrome', 
        [
          0, 1, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 1, 0, 1, 0,
        ],
      ),
      Filter(
        'Vintage Vibes', 
        [
          1, 0, 0, 0, 0,
          -0.4, 1.3, -0.4, 0.2, -0.1,
          0, 0, 1, 0, 0,
          0, 0, 0, 1, 0,
        ],
      ),
      Filter(
        'Icy Blue', 
        [
          1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          -0.2, 0.2, 0.1, 0.4, 0,
          0, 0, 0, 1, 0,
        ],
      ),
      Filter(
        'Sepia Dream', 
        [
          1.3, -0.3, 1.1, 0, 0,
          0, 1.3, 0.2, 0, 0,
          0, 0, 0.8, 0.2, 0,
          0, 0, 0, 1, 0,
        ],
      ),
      Filter(
        'Soft Glow', 
        [
          0, 1.0, 0, 0, 0,
          0, 1.0, 0, 0, 0,
          0, 0.6, 1, 0, 0,
          0, 0, 0, 1, 0,
        ],
      ),
      Filter(
        'Sunset Haze', 
        [
          1.2, 0.1, 0.1, 0, 0,
          0.1, 1.1, 0.1, 0, 0,
          0.1, 0.1, 0.9, 0, 0,
          0, 0, 0, 1, 0,
        ],
      ),
      Filter(
        'Deep Shadows', 
        [
          1.5, -0.5, -0.5, 0, 0,
          -0.5, 1.5, -0.5, 0, 0,
          -0.5, -0.5, 1.5, 0, 0,
          0, 0, 0, 1, 0,
        ],
      ),
      Filter(
        'Cyberpunk', 
        [
          1.3, 0, 0, 0, 0,
          0, 0.8, 1.2, 0, 0,
          0, 1.3, 1.3, 0, 0,
          0, 0, 0, 1, 0,
        ],
      ),
      Filter(
        'Retro Film', 
        [
          1.1, -0.1, -0.1, 0, 0,
          -0.1, 1.1, -0.1, 0, 0,
          -0.1, -0.1, 1.1, 0, 0,
          0, 0, 0, 1, 0.2,
        ],
      ),
    ];
  }
}
