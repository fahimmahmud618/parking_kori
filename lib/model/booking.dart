class Booking {
  String booking_id;
  String vehicle_type;
  String registration_number;
  String in_time;
  String out_time;
  bool isPresent;

  Booking(
      {required this.booking_id,
      required this.vehicle_type,
      required this.registration_number,
      required this.in_time,
      required this.out_time,
      required this.isPresent});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      booking_id: json['booking_id'].toString(),
      vehicle_type: json['vehicle_type'],
      registration_number: json['registration_number'],
      in_time: json['in_time'],
      out_time: json['out_time'],
      isPresent: json['isPresent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': booking_id,
      'vehicle_type': vehicle_type,
      'registration_number': registration_number,
      'in_time': in_time,
      'out_time': out_time,
      'isPresent': isPresent,
    };
  }
}
