class MapAsset {
  const MapAsset({
    required this.id,
    required this.name,
    required this.logicalMapName,
    required this.floorNumber,
    required this.imagePath,
    required this.width,
    required this.height,
  });

  final int id;
  final String name;
  final String logicalMapName;
  final int floorNumber;
  final String imagePath;
  final int width;
  final int height;

  String get floorLabel => 'Etage $floorNumber';

  String get displayName => '$logicalMapName • $floorLabel';

  MapAsset copyWith({
    int? id,
    String? name,
    String? logicalMapName,
    int? floorNumber,
    String? imagePath,
    int? width,
    int? height,
  }) {
    return MapAsset(
      id: id ?? this.id,
      name: name ?? this.name,
      logicalMapName: logicalMapName ?? this.logicalMapName,
      floorNumber: floorNumber ?? this.floorNumber,
      imagePath: imagePath ?? this.imagePath,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }
}
