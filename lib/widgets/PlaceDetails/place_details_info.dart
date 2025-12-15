import 'package:flutter/material.dart';
import '../../models/Lieu.dart';
import 'place_details_user_review_card.dart';
import 'place_details_image_card.dart';
import 'place_details_contact_card.dart';
import 'place_details_additional_info_card.dart';

class PlaceDetailsInfo extends StatelessWidget {
  final Lieu lieu;

  const PlaceDetailsInfo({super.key, required this.lieu});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Note et Commentaire
        if (lieu.rating != null || (lieu.note != null && lieu.note!.isNotEmpty))
          placeDetailsUserReviewCard(isDark, lieu),

        // Image
        if (lieu.tags["image"] != null) placeDetailsImageCard(isDark, lieu),

        // Les infos de contact
        placeDetailsContactCard(isDark, lieu),

        // infos supplémentaires que j'ai trouvé en regardant les réponses d'API
        if (placeDetailsHasAdditionalInfo()) placeDetailsAdditionalInfoCard(isDark, lieu),
      ],
    );
  }

  bool placeDetailsHasAdditionalInfo() {
    return lieu.tags.containsKey("network") ||
        lieu.tags.containsKey("operator") ||
        lieu.tags.containsKey("opening_hours") ||
        lieu.tags.containsKey("cuisine");
  }
}
