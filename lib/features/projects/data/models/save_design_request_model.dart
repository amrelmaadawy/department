class SaveDesignRequestModel {
  final int finishingOrderId;
  final String imageUrl;

  const SaveDesignRequestModel({
    required this.finishingOrderId,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'finishing_order_id': finishingOrderId,
      'image_url': imageUrl,
    };
  }
}
