import 'package:flutter/material.dart';

class TermsOfService extends StatefulWidget {
  @override
  _TermsOfServiceState createState() => _TermsOfServiceState();
}

class _TermsOfServiceState extends State<TermsOfService> {
  bool acceptTerms = false;
  bool acceptPrivacyPolicy = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Checkbox(
              value: acceptTerms,
              onChanged: (value) {
                setState(() {
                  acceptTerms = value!;
                });
              },
              activeColor: Colors.blue, // Couleur lorsque cochée
            ),
            const Text(
              "I agree",
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4), // Espace horizontal entre le texte et la case à cocher
            GestureDetector(
              child: const Text(
                "to the terms o service.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // Ouvrir la page des conditions d'utilisation dans un navigateur
              },
            ),
          ],
        ),
      ],
    );
  }
}
