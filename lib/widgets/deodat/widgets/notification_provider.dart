// import 'package:flutter/foundation.dart';
// import 'package:eventflow/widgets/deodat/widgets/welcome_notification.dart';

// class NotificationProvider extends ChangeNotifier {
//   int _nombreNotificationsNonLues = 0;
//   final List<WelcomeNotification> _notifications = [];

//   int get nombreNotificationsNonLues => _nombreNotificationsNonLues;

//   List<WelcomeNotification> get notifications => _notifications;

//   void ajouterNotification(WelcomeNotification notification) {
//     _notifications.add(notification);
//     _nombreNotificationsNonLues++;
//     Future.delayed(Duration.zero, () {
//       notifyListeners();
//     });
//   }

//   void marquerToutesCommeLues() {
//     _nombreNotificationsNonLues = 0;
//     notifyListeners();
//   }

//    void marquerNotificationCommeLue(WelcomeNotification notification) {
//     notification.isRead = true;
//     notifyListeners();
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:eventflow/widgets/deodat/widgets/welcome_notification.dart';
import 'package:eventflow/Model/event.dart';



class NotificationProvider extends ChangeNotifier {
  int _nombreNotificationsNonLues = 0;
  final List<WelcomeNotification> _notifications = [];

  int get nombreNotificationsNonLues => _nombreNotificationsNonLues;

  List<WelcomeNotification> get notifications => _notifications;

  void ajouterNotification(WelcomeNotification notification) {
    _notifications.add(notification);
    _nombreNotificationsNonLues++;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }
//   void ajouterNotification(WelcomeNotification notification) {
//   _notifications.add(notification);
//   _nombreNotificationsNonLues++;
//   notifyListeners();
// }

  void marquerToutesCommeLues() {
    _nombreNotificationsNonLues = 0;
    notifyListeners();
  }

   void marquerNotificationCommeLue(WelcomeNotification notification) {
    notification.isRead = true;
    notifyListeners();
  }

  // void ajouterNotificationPaiementEffectue() {
  //   final notification = WelcomeNotification(
  //     titre: 'Nouveau paiement',
  //     message: 'Votre paiement a été effectué avec succès.',
  //   );
  //   ajouterNotification(notification);
  // }
}
