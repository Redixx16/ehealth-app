class UpdateAppointmentDto {
  final String? status;
  final String? recommendations;
  UpdateAppointmentDto({this.status, this.recommendations});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (status != null) data['status'] = status;
    if (recommendations != null) data['recommendations'] = recommendations;
    return data;
  }
}
