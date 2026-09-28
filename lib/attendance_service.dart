import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> checkIn({
    required String studentId,
    required String academyId,
  }) async {
    await _supabase.from('attendance').insert({
      'student_id': studentId,
      'academy_id': academyId,
      'check_in': DateTime.now().toIso8601String(),
    });
  }

  Future<void> checkOut({
    required String studentId,
  }) async {
    await _supabase
        .from('attendance')
        .update({
          'check_out': DateTime.now().toIso8601String(),
        })
        .eq('student_id', studentId)
        .isFilter('check_out', null)
        .order('check_in', ascending: false)
        .limit(1);
  }
}