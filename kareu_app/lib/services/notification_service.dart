// Serviço de notificações completamente simplificado
/// Serviço centralizado para tratamento de erros e notificações
class ErrorHandler {
  static void showError(BuildContext context, String message, {String? title}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppDesignSystem.errorColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message, {String? title}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppDesignSystem.successColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static void showInfo(BuildContext context, String message, {String? title}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppDesignSystem.infoColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static String getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return error.toString();
  }

  static void logError(String context, dynamic error, StackTrace? stackTrace) {
    // Em produção, isso seria enviado para um serviço de logging como Firebase Crashlytics
    debugPrint('ERROR in $context: $error');
    if (stackTrace != null) {
      debugPrint('StackTrace: $stackTrace');
    }
  }
}

class NotificationService {
  /// Mostra notificação local simples (simulada)
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    // Simular exibição de notificação
    print('Notificação mostrada: $title - $body');

    // Em um app real, você usaria flutter_local_notifications aqui
    // Mas como há problemas de compatibilidade, apenas simulamos
  }

  /// Salva notificação no Firestore (simulado)
  static Future<void> saveNotificationToFirestore({
    required String userId,
    required String title,
    required String body,
    String type = 'general',
  }) async {
    // Simular salvamento no Firestore
    print('Notificação salva no Firestore: $title para usuário $userId');
  }

  /// Agenda notificação local para lembrete (simulada)
  static Future<void> scheduleReminderNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // Simular agendamento de notificação
    print('Notificação agendada para ${scheduledTime.toString()}: $title');
  }

  /// Cancela notificação agendada (simulada)
  static Future<void> cancelScheduledNotification(int id) async {
    print('Notificação $id cancelada');
  }

  /// Obtém notificações não lidas do usuário (simulado)
  static Future<List<Map<String, dynamic>>> getUnreadNotifications(String userId) async {
    // Simular retorno de notificações não lidas
    return [
      {
        'id': 'notif_1',
        'title': 'Lembrete de agendamento',
        'body': 'Você tem um agendamento amanhã às 10:00',
        'type': 'appointment',
        'isRead': false,
        'createdAt': DateTime.now().toIso8601String(),
      }
    ];
  }
}
