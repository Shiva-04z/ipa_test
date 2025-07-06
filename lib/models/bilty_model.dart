
class BiltyCategory {
  final String quality;
  final String category;
  final String variety;
  final String size;
  final int piecesPerBox;
  final double avgWeight;
  final double avgBoxWeight;
  final int boxCount;
  final double totalWeight;
  final String? imagePath;
  final double pricePerKg;
  final double boxValue;
  final double totalPrice;
  final String? videoPath;

  BiltyCategory({
    required this.quality,
    required this.category,
    required this.size,
    required this.piecesPerBox,
    required this.avgWeight,
    required this.avgBoxWeight,
    required this.boxCount,
    required this.totalWeight,
    required this.variety,
    this.imagePath,
    required this.pricePerKg,
    required this.boxValue,
    required this.totalPrice,
    this.videoPath,
  });

  // Create a copy of this object with some fields updated
  BiltyCategory copyWith({
    String? quality,
    String? category,
    String? variety,
    String? size,
    int? piecesPerBox,
    double? avgWeight,
    double? avgBoxWeight,
    int? boxCount,
    double? totalWeight,
    String? imagePath,
    double? pricePerKg,
    double? boxValue,
    double? totalPrice,
    String? videoPath,
  }) {
    return BiltyCategory(
      quality: quality ?? this.quality,
      category: category ?? this.category,
      size: size ?? this.size,
      piecesPerBox: piecesPerBox ?? this.piecesPerBox,
      avgWeight: avgWeight ?? this.avgWeight,
      avgBoxWeight: avgBoxWeight ?? this.avgBoxWeight,
      boxCount: boxCount ?? this.boxCount,
      totalWeight: totalWeight ?? this.totalWeight,
      imagePath: imagePath ?? this.imagePath,
      pricePerKg: pricePerKg ?? this.pricePerKg,
      boxValue: boxValue ?? this.boxValue,
      totalPrice: totalPrice ?? this.totalPrice,
      videoPath: videoPath ?? this.videoPath,
      variety: variety?? this.variety
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'quality': quality,
      'category': category,
      'size': size,
      'piecesPerBox': piecesPerBox,
      'avgWeight': avgWeight,
      'avgBoxWeight': avgBoxWeight,
      'boxCount': boxCount,
      'totalWeight': totalWeight,
      'imagePath': imagePath,
      'pricePerKg': pricePerKg,
      'boxValue': boxValue,
      'totalPrice': totalPrice,
      'videoPath': videoPath,
      'variety': variety
    };
  }

  // Create from Map
  factory BiltyCategory.fromMap(Map<String, dynamic> map) {
    return BiltyCategory(
      quality: map['quality'] as String,
      category: map['category'] as String,
      variety:  map['variety'] as String,
      size: map['size'] as String,
      piecesPerBox: map['piecesPerBox'] as int,
      avgWeight: (map['avgWeight'] as num).toDouble(),
      avgBoxWeight: (map['avgBoxWeight'] as num).toDouble(),
      boxCount: map['boxCount'] as int,
      totalWeight: (map['totalWeight'] as num).toDouble(),
      imagePath: map['imagePath'] as String?,
      pricePerKg: (map['pricePerKg'] as num).toDouble(),
      boxValue: (map['boxValue'] as num).toDouble(),
      totalPrice: (map['totalPrice'] as num).toDouble(),
      videoPath: map['videoPath'] as String?,
    );
  }
}

class Bilty {
 String? id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<BiltyCategory> categories;
  final double totalBoxes;
  final double totalWeight;
  final double totalValue;
  final String? videoPath;


  Bilty({
    this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.categories,
    required this.totalBoxes,
    required this.totalWeight,
    required this.totalValue,
    this.videoPath,
  });

  // Create a new Bilty with default categories
  factory Bilty.createDefault() {
    final categories = [
      BiltyCategory(
        quality: 'GP',
        category: 'Large',
        size: '>75mm-<80mm',
        variety: 'Delicious',
        piecesPerBox: 40,
        avgWeight: 200,
        avgBoxWeight: 10,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'GP',
        category: 'Medium',
        variety: 'Delicious',
        size: '>70mm-<75mm',
        piecesPerBox: 50,
        avgWeight: 160,
        avgBoxWeight: 10,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'GP',
        category: 'Small',
        variety: 'Delicious',
        size: '>65mm-<70mm',
        piecesPerBox: 60,
        avgWeight: 133,
        avgBoxWeight: 12,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'GP',
        category: 'Extra Small',
        size: '>60mm-<65mm',
        variety: 'Delicious',
        piecesPerBox: 70,
        avgWeight: 116,
        avgBoxWeight: 15,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'AAA',
        category: 'Extra Large',
        size: '>80mm',
        variety: 'Delicious',
        piecesPerBox: 80,
        avgWeight: 250,
        avgBoxWeight: 20,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'AAA',
        category: 'Large',
        size: '>75mm-<80mm',
        variety: 'Delicious',
        piecesPerBox: 100,
        avgWeight: 200,
        avgBoxWeight: 15,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'AAA',
        category: 'Medium',
        size: '>70mm-<75mm',
        variety: 'Delicious',
        piecesPerBox: 125,
        avgWeight: 250,
        avgBoxWeight: 31.25,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'AAA',
        category: 'Small',
        size: '>65mm-<70mm',
        variety: 'Delicious',
        piecesPerBox: 150,
        avgWeight: 250,
        avgBoxWeight: 37.5,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'AAA',
        category: 'Extra Small',
        size: '>60mm-<65mm',
        variety: 'Delicious',
        piecesPerBox: 175,
        avgWeight: 250,
        avgBoxWeight: 43.75,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'AAA',
        category: 'E Extra Small',
        size: '>55mm-<60mm',
        variety: 'Delicious',
        piecesPerBox: 200,
        avgWeight: 250,
        avgBoxWeight: 50,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'AAA',
        category: '240 Count',
        size: '>50mm-<55mm',
        variety: 'Delicious',
        piecesPerBox: 240,
        avgWeight: 250,
        avgBoxWeight: 60,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'AAA',
        category: 'Pittu',
        size: '>45mm-<50mm',
        variety: 'Delicious',
        piecesPerBox: 270,
        avgWeight: 250,
        avgBoxWeight: 20,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'AAA',
        category: 'Seprator',
        size: '>40mm-<45mm',
        variety: 'Delicious',
        piecesPerBox: 300,
        avgWeight: 65,
        avgBoxWeight: 20,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'AA',
        category: 'Extra Large',
        size: '>80mm',
        variety: 'Delicious',
        piecesPerBox: 80,
        avgWeight: 250,
        avgBoxWeight: 20,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'AA',
        category: 'Large',
        size: '>75mm-<80mm',
        variety: 'Delicious',
        piecesPerBox: 100,
        avgWeight: 200,
        avgBoxWeight: 20,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'AA',
        category: 'Medium',
        size: '>70mm-<75mm',
        variety: 'Delicious',
        piecesPerBox: 125,
        avgWeight: 160,
        avgBoxWeight: 20,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'AA',
        category: 'Small',
        size: '>65mm-<70mm',
        variety: 'Delicious',
        piecesPerBox: 150,
        avgWeight: 133,
        avgBoxWeight: 20,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'AA',
        category: 'Extra Small',
        size: '>60mm-<65mm',
        variety: 'Delicious',
        piecesPerBox: 175,
        avgWeight: 116,
        avgBoxWeight: 20,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'AA',
        category: 'E Extra Small',
        size: '>55mm-<60mm',
        variety: 'Delicious',
        piecesPerBox: 200,
        avgWeight: 98,
        avgBoxWeight: 20,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'AA',
        category: '240 Count',
        size: '>50mm-<55mm',
        variety: 'Delicious',
        piecesPerBox: 240,
        avgWeight: 75,
        avgBoxWeight: 20,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'AA',
        category: 'Pittu',
        size: '>45mm-<50mm',
        variety: 'Delicious',
        piecesPerBox: 270,
        avgWeight: 70,
        avgBoxWeight: 20,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'AA',
        category: 'Seprator',
        size: '>40mm-<45mm',
        variety: 'Delicious',
        piecesPerBox: 300,
        avgWeight: 65,
        avgBoxWeight: 20,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
      BiltyCategory(
        quality: 'Mix/Pear',
        category: 'Mix & Pears',
        variety: 'Delicious',
        size: 'All Sizes',
        piecesPerBox: 80,
        avgWeight: 0,
        avgBoxWeight: 20,
        boxCount: 0,
        totalWeight: 0,
        pricePerKg: 0,
        boxValue: 0,
        totalPrice: 0,
      ),
    ];

    return Bilty(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      categories: categories,
      totalBoxes: 0,
      totalWeight: 0,
      totalValue: 0,
    );
  }

  // Create a copy of this object with some fields updated
  Bilty copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<BiltyCategory>? categories,
    double? totalBoxes,
    double? totalWeight,
    double? totalValue,
    String? videoPath,
  }) {
    return Bilty(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      categories: categories ?? this.categories,
      totalBoxes: totalBoxes ?? this.totalBoxes,
      totalWeight: totalWeight ?? this.totalWeight,
      totalValue: totalValue ?? this.totalValue,
      videoPath: videoPath ?? this.videoPath,
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'categories': categories.map((x) => x.toMap()).toList(),
      'totalBoxes': totalBoxes,
      'totalWeight': totalWeight,
      'totalValue': totalValue,
      'videoPath': videoPath,
    };
  }

  // Create from Map
  factory Bilty.fromMap(Map<String, dynamic> map) {
    return Bilty(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      categories: List<BiltyCategory>.from(
        (map['categories'] as List).map(
          (x) => BiltyCategory.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalBoxes: (map['totalBoxes'] as num).toDouble(),
      totalWeight: (map['totalWeight'] as num).toDouble(),
      totalValue: (map['totalValue'] as num).toDouble(),
      videoPath: map['videoPath'] as String?,
    );
  }

  // Calculate totals
  void calculateTotals() {
    double totalBoxes = 0;
    double totalWeight = 0;
    double totalValue = 0;

    for (var category in categories) {
      totalBoxes += category.boxCount;
      totalWeight += category.totalWeight;
      totalValue += category.totalPrice;
    }
  }

  // Get category by quality and category name
  BiltyCategory? getCategory(String quality, String category) {
    return categories.firstWhere(
      (c) => c.quality == quality && c.category == category,
      orElse: () => throw Exception('Category not found'),
    );
  }

  // Update category
  Bilty updateCategory(
      String quality, String category, BiltyCategory updatedCategory) {
    final index = categories.indexWhere(
      (c) => c.quality == quality && c.category == category,
    );

    if (index == -1) {
      throw Exception('Category not found');
    }

    final updatedCategories = List<BiltyCategory>.from(categories);
    updatedCategories[index] = updatedCategory;

    return copyWith(
      categories: updatedCategories,
      updatedAt: DateTime.now(),
    );
  }

  factory Bilty.fromJson(Map<String, dynamic> json) {
    return Bilty(
      id: json['_id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      categories: (json['categories'] as List<dynamic>)
          .map((cat) => BiltyCategory.fromMap(cat as Map<String, dynamic>))
          .toList(),
      totalBoxes: (json['totalBoxes'] as num).toDouble(),
      totalWeight: (json['totalWeight'] as num).toDouble(),
      totalValue: (json['totalValue'] as num).toDouble(),
      videoPath: json['videoPath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'categories': categories.map((cat) => cat.toMap()).toList(),
      'totalBoxes': totalBoxes,
      'totalWeight': totalWeight,
      'totalValue': totalValue,
      'videoPath': videoPath,
    };
  }
}
