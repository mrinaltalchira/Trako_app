

class TonerColors {
  final String modelId;
  final String color;

  TonerColors({required this.modelId, required this.color});

  factory TonerColors.fromJson(Map<String, dynamic> json) {
    return TonerColors(
      modelId: json['model_id'].toString(),
      color: json['color'],
    );
  }
}

