import 'package:flutter/material.dart';

class MapStyles {
  static Icon getNodeIcon(Map<String, String> tags, {double size = 24}) {
    if (tags.isEmpty) {
      return Icon(Icons.question_mark, color: Colors.black, size: size);
    }

    Color? color = Colors.black;

    if (tags["amenity"] != null) {
      color = Colors.orange;
      switch (tags["amenity"]) {
        case "atm":
          return createIcon(Icons.atm, color, size);
        case "bank":
          return createIcon(Icons.account_balance, color, size);
        case "bar":
          return createIcon(Icons.nightlife, color, size);
        case "bench":
          return createIcon(Icons.chair, color, size);
        case "bicycle_parking":
        case "bicycle_rental":
          return createIcon(Icons.pedal_bike, color, size);
        case "bus_station":
          return createIcon(Icons.directions_bus, color, size);
        case "cafe":
          return createIcon(Icons.local_cafe, color, size);
        case "car_wash":
          return createIcon(Icons.local_car_wash, color, size);
        case "charging_station":
          return createIcon(Icons.ev_station, color, size);
        case "clinic":
        case "dentist":
        case "doctors":
        case "hospital":
          return createIcon(Icons.emergency, color, size);
        case "college":
        case "school":
        case "university":
          return createIcon(Icons.school, color, size);
        case "community_centre":
          return createIcon(Icons.group_work, color, size);
        case "drinking_water":
        case "fountain":
          return createIcon(Icons.water_drop, color, size);
        case "fast_food":
          return createIcon(Icons.fastfood, color, size);
        case "fire_station":
          return createIcon(Icons.local_fire_department, color, size);
        case "fuel":
          return createIcon(Icons.local_gas_station, color, size);
        case "hunting_stand":
        case "veterinary":
          return createIcon(Icons.pets, color, size);
        case "ice_cream":
          return createIcon(Icons.icecream, color, size);
        case "kindergarten":
          return createIcon(Icons.child_care, color, size);
        case "library":
          return createIcon(Icons.local_library, color, size);
        case "marketplace":
          return createIcon(Icons.storefront, color, size);
        case "parking":
        case "parking_entrance":
        case "parking_space":
          return createIcon(Icons.local_parking, color, size);
        case "pharmacy":
          return createIcon(Icons.local_pharmacy, color, size);
        case "place_of_worship":
          return createIcon(Icons.church, color, size);
        case "police":
          return createIcon(Icons.local_police, color, size);
        case "post_office":
        case "post_box":
          return createIcon(Icons.local_post_office, color, size);
        case "pub":
          return createIcon(Icons.sports_bar, color, size);
        case "public_building":
        case "townhall":
          return createIcon(Icons.house, color, size);
        case "recycling":
        case "waste_disposal":
          return createIcon(Icons.recycling, color, size);
        case "restaurant":
          return createIcon(Icons.restaurant, color, size);
        case "shelter":
          return createIcon(Icons.night_shelter, color, size);
        case "social_facility":
          return createIcon(Icons.groups, color, size);
        case "taxi":
          return createIcon(Icons.local_taxi, color, size);
        case "telephone":
          return createIcon(Icons.phone, color, size);
        case "theatre":
          return createIcon(Icons.theater_comedy, color, size);
        case "toilets":
          return createIcon(Icons.wc, color, size);
        case "vending_machine":
          return createIcon(Icons.kitchen, color, size);
        case "waste_basket":
          return createIcon(Icons.delete_outline, color, size);
      }
    }
    if (tags["aeroway"] != null) {
      return createIcon(Icons.flight, color, size);
    }
    if (tags["crop"] != null) {
      return createIcon(Icons.eco, Colors.green, size);
    }
    if (tags["cuisine"] != null) {
      return createIcon(Icons.restaurant, color, size);
    }
    if (tags["historic"] != null) {
      return createIcon(Icons.museum, Colors.brown, size);
    }
    if (tags["leisure"] != null) {
      color = Colors.lightGreen;
      switch (tags["leisure"]) {
        case "adult_gaming_centre":
        case "amusement_arcade":
          return createIcon(Icons.sports_esports, color, size);
        case "bandstand":
          return createIcon(Icons.music_note, color, size);
        case "bird_hide":
          return createIcon(Icons.flutter_dash, color, size);
        case "bowling_alley":
          return createIcon(Icons.sports_bar, color, size);
        case "climbing":
          return createIcon(Icons.landscape, color, size);
        case "common":
        case "trampoline_park":
        case "water_park":
          return createIcon(Icons.attractions, color, size);
        case "dance":
          return createIcon(Icons.nightlife, color, size);
        case "disc_golf_course":
        case "golf_course":
        case "miniature_golf":
          return createIcon(Icons.golf_course, color, size);
        case "dog_park":
          return createIcon(Icons.pets, color, size);
        case "escape_game":
          return createIcon(Icons.meeting_room, color, size);
        case "fire_pit":
          return createIcon(Icons.fireplace, color, size);
        case "fishing":
          return createIcon(Icons.phishing, color, size);
        case "fitness_centre":
        case "fitness_station":
          return createIcon(Icons.fitness_center, color, size);
        case "garden":
          return createIcon(Icons.yard, color, size);
        case "hackerspace":
          return createIcon(Icons.developer_board, color, size);
        case "horse_riding":
          return createIcon(Icons.bedroom_baby, color, size);
        case "ice_rink":
          return createIcon(Icons.snowshoeing, color, size);
        case "marina":
          return createIcon(Icons.sailing, color, size);
        case "nature_reserve":
          return createIcon(Icons.nature, color, size);
        case "outdoor_seating":
        case "picnic_table":
          return createIcon(Icons.deck, color, size);
        case "park":
          return createIcon(Icons.nature_people, color, size);
        case "pitch":
        case "recreation_ground":
        case "sport":
          return createIcon(Icons.sports, color, size);
        case "playground":
        case "schoolyard":
          return createIcon(Icons.child_friendly, color, size);
        case "resort":
          return createIcon(Icons.hotel_class, color, size);
        case "sauna":
          return createIcon(Icons.spa, color, size);
        case "slipway":
          return createIcon(Icons.directions_boat, color, size);
        case "sports_centre":
          return createIcon(Icons.fitness_center, color, size);
        case "stadium":
        case "sports_hall":
          return createIcon(Icons.stadium, color, size);
        case "summer_camp":
          return createIcon(Icons.holiday_village, color, size);
        case "swimming_area":
        case "swimming_pool":
          return createIcon(Icons.pool, color, size);
        case "tanning_salon":
          return createIcon(Icons.beach_access, color, size);
        case "track":
          return createIcon(Icons.directions_run, color, size);
        case "wildlife_hide":
          return createIcon(Icons.pets, color, size);
      }
    }

    if (tags["man_made"] != null) {
      return createIcon(Icons.construction, Colors.yellow, size);
    }

    if (tags["natural"] != null) {
      return createIcon(Icons.forest, Colors.green.shade700, size);
    }
    if (tags["man_made"] != null) {
      return createIcon(Icons.construction, Colors.yellow, size);
    }
    if (tags["place"] != null) {
      return createIcon(Icons.star, Colors.grey.shade700, size);
    }
    if (tags["power"] != null) {
      return createIcon(Icons.bolt, Colors.yellow, size);
    }
    if (tags["public_transport"] != null) {
      return createIcon(Icons.directions, Colors.yellow, size);
    }
    if (tags["religion"] != null) {
      return createIcon(Icons.church, Colors.brown, size);
    }

    if (tags["shop"] != null) {
      return createIcon(Icons.shopping_cart, Colors.blue.shade800, size);
    }

    if (tags["sport"] != null) {
      color = Colors.deepOrangeAccent;
      switch (tags["sport"]) {
        case "10pin":
        case "billiards":
          return createIcon(Icons.sports_bar, color, size);
        case "american_football":
          return createIcon(Icons.sports_football, color, size);
        case "athletics":
        case "gymnastics":
        case "yoga":
          return createIcon(Icons.sports_gymnastics, color, size);
        case "badminton":
        case "table_tennis":
        case "tennis":
          return createIcon(Icons.sports_tennis, color, size);
        case "baseball":
          return createIcon(Icons.sports_baseball, color, size);
        case "basketball":
        case "pelota":
          return createIcon(Icons.sports_basketball, color, size);
        case "volleyball":
        case "beachvolleyball":
        case "softball":
          return createIcon(Icons.sports_volleyball, color, size);
        case "bmx":
        case "cycling":
          return createIcon(Icons.pedal_bike, color, size);
        case "handball":
        case "boules":
        case "bowls":
        case "netball":
          return createIcon(Icons.sports_handball, color, size);
        case "canoe":
        case "padel":
          return createIcon(Icons.kayaking, color, size);
        case "chess":
          return createIcon(Icons.grid_on, color, size);
        case "climbing":
          return createIcon(Icons.landscape, color, size);
        case "cricket":
          return createIcon(Icons.sports_cricket, color, size);
        case "disc_golf":
        case "golf":
          return createIcon(Icons.sports_golf, color, size);
        case "exercise":
        case "fitness":
        case "multi":
          return createIcon(Icons.fitness_center, color, size);
        case "field_hockey":
        case "hockey":
        case "ice_hockey":
          return createIcon(Icons.sports_hockey, color, size);
        case "football":
        case "futsal":
        case "soccer":
          return createIcon(Icons.sports_soccer, color, size);
        case "free_flying":
          return createIcon(Icons.paragliding, color, size);
        case "rugby":
        case "rugby_league":
        case "rugby_union":
        case "gaelic_games":
          return createIcon(Icons.sports_rugby, color, size);
        case "karting":
        case "motocross":
        case "motor":
          return createIcon(Icons.sports_motorsports, color, size);
        case "running":
          return createIcon(Icons.directions_run, color, size);
        case "scuba_diving":
          return createIcon(Icons.scuba_diving, color, size);
        case "skateboard":
          return createIcon(Icons.skateboarding, color, size);
        case "skiing":
          return createIcon(Icons.downhill_skiing, color, size);
        case "swimming":
          return createIcon(Icons.pool, color, size);
      }
    }

    if (tags["tourism"] != null) {
      color = Colors.blueAccent.shade700;
      switch (tags["tourism"]) {
        case "apartment":
          return createIcon(Icons.apartment, color, size);
        case "aquarium":
          return createIcon(Icons.water, color, size);
        case "artwork":
        case "gallery":
          return createIcon(Icons.account_box, color, size);
        case "attraction":
        case "theme_park":
          return createIcon(Icons.attractions, color, size);
        case "cabin":
        case "camp_pitch":
        case "camp_site":
        case "caravan_site":
        case "guest_house":
        case "wilderness_hut":
          return createIcon(Icons.cabin, color, size);
        case "chalet":
          return createIcon(Icons.chalet, color, size);
        case "hostel":
        case "motel":
          return createIcon(Icons.hotel, color, size);
        case "hotel":
          return createIcon(Icons.king_bed, color, size);
        case "information":
          return createIcon(Icons.info, color, size);
        case "museum":
          return createIcon(Icons.museum, color, size);
        case "picnic_site":
        case "picnic_table":
          return createIcon(Icons.deck, color, size);
        case "resort":
          return createIcon(Icons.holiday_village, color, size);
        case "trail_riding_station":
          return createIcon(Icons.hiking, color, size);
        case "wine_cellar":
          return createIcon(Icons.wine_bar, color, size);
        case "zoo":
          return createIcon(Icons.pets, color, size);
      }
    }

    return createIcon(Icons.circle, color, size);
  }

  static Icon createIcon(IconData? icon, Color? color, double? size) {
    return Icon(icon, color: color, size: size);
  }

  static Color getNodeColor(Map<String, String> tags, {Color color = Colors.yellow}) {
    return color;
  }

  //refs haben ways ohne tags als ihre unter ways!
  static getElementColor(Map<String, String> tags, {Color color = Colors.pinkAccent}) {
    //TODO rel ways können auch nur zb note:de haben
    if (tags.isEmpty) {
      //höchstwahrscheinlich teil einer relation!
      return Colors.transparent;
    }
    if (tags["natural"] != null) {
      switch (tags["natural"]) {
        case "water":
          return Colors.blue;
        case "wetland":
          return Colors.teal.shade400;
        case "sand":
          return Colors.orange.shade100;
        case "scrub":
          return Colors.green.shade900;
        case "wood":
          return Colors.green.shade700;
        case "grassland":
          return Colors.lightGreen.shade300;
        case "heath":
          return Colors.lightGreen.shade600;
      }
    } else if (tags["highway"] != null) {
      switch (tags["highway"]) {
        case "trunk":
          return Colors.orange.shade900;
        case "primary":
          return Colors.orangeAccent.shade700;
        case "secondary":
          return Colors.orangeAccent.shade400;
        case "path":
          return Colors.grey.shade500;
        case "track":
          return Colors.brown.shade400;
      }
      color = Colors.grey.shade500;
    } else if (tags["waterway"] != null) {
      switch (tags["waterway"]) {
        case "river":
        case "stream":
          return Colors.blueAccent.shade700;
        case "canal":
          return Colors.blueAccent.shade200;
        case "ditch":
          return Colors.lightBlue.shade400;
      }
      color = Colors.grey.shade500;
    } else if (tags["building"] != null) {
      switch (tags["building"]) {
        case "kindergarten":
          return Colors.pink.shade100;
        case "yes":
        default:
          return Colors.brown.shade300;
      }
    } else if (tags["landuse"] != null) {
      switch (tags["landuse"]) {
        case "residential":
          return Colors.white;
        case "farmyard":
          return Colors.brown;
        case "farmland":
          return Colors.limeAccent.shade700;
        case "construction":
          return Colors.orange;
        case "industrial":
          return Colors.deepOrangeAccent.shade400;
        case "railway":
          return Colors.pinkAccent.shade100;
        case "allotments": //kleingarten
          return Colors.lightGreen;
        case "plant_nursery":
        case "greenhouse_horticulture":
          return Colors.green.shade400;
        case "forest":
          return Colors.green;
        case "meadow":
          return Colors.green.shade400;
        case "grass":
          return Colors.green.shade300;
        case "commercial":
          return Colors.orange;
        case "military":
          return Colors.red;
      }
    } else if (tags["tourism"] != null) {
      switch (tags["tourism"]) {
        case "camp_site":
          return Colors.lightGreen;
      }
    } else if (tags["railway"] != null) {
      switch (tags["railway"]) {
        case "rail":
          return Colors.black;
        case "abandoned":
          return Colors.black26;
      }
    } else if (tags["leisure"] != null) {
      switch (tags["leisure"]) {
        case "pitch":
          return Colors.yellow.shade700;
        case "playground":
          return Colors.limeAccent.shade200;
        case "park":
          return Colors.lightGreen;
        case "garden":
          return Colors.lightGreen.shade600;
      }
    } else if (tags["amenity"] != null) {
      switch (tags["amenity"]) {
        case "parking":
          return Colors.grey.shade500;
        case "hospital":
          return Colors.yellow.shade200;
      }
    } else if (tags["aeroway"] != null) {
      switch (tags["aeroway"]) {
        case "aerodrome":
          return Colors.grey.shade500;
        case "runway":
          return Colors.blueGrey;
      }
    } else if (tags["power"] != null) {
      switch (tags["power"]) {
        case "line":
          return Colors.yellow.shade600;
      }
    } else if (tags.containsKey("building")) {
      color = Colors.brown.shade200;
    } else if (tags["golf"] != null) {
      return Colors.green;
    }

    return color;
  }
}
