enum TagKeys {
  any([]),
  aeroway([
    "aerodrome",
    "airstrip",
    "apron",
    "gate",
    "hangar",
    "helipad",
    "heliport",
    "holding_position",
    "navigationaid",
    "parking_position",
    "runway",
    "stopway",
    "taxilane",
    "taxiway",
    "terminal",
    "tower",
    "windsock",
  ]),
  amenity([
    "atm",
    "bank",
    "bar",
    "bench",
    "bicycle_parking",
    "bicycle_rental",
    "bus_station",
    "cafe",
    "car_wash",
    "charging_station",
    "clinic",
    "college",
    "community_centre",
    "dentist",
    "doctors",
    "drinking_water",
    "fast_food",
    "fire_station",
    "fountain",
    "fuel",
    "grave_yard",
    "hospital",
    "hunting_stand",
    "ice_cream",
    "kindergarten",
    "library",
    "marketplace",
    "parking",
    "parking_entrance",
    "parking_space",
    "pharmacy",
    "place_of_worship",
    "police",
    "post_box",
    "post_office",
    "pub",
    "public_building",
    "recycling",
    "restaurant",
    "school",
    "shelter",
    "social_facility",
    "taxi",
    "telephone",
    "theatre",
    "toilets",
    "townhall",
    "university",
    "vending_machine",
    "veterinary",
    "waste_basket",
    "waste_disposal",
  ]),
  crop([
    "cereal",
    "corn",
    "grape",
    "grass",
    "hop",
    "rice",
    "soy",
    "sugarcane",
    "tea",
    "vegetable",
    "wheat",
  ]),
  cuisine([
    "african",
    "american",
    "arab",
    "asian",
    "bagel",
    "barbeque",
    "beef_bowl",
    "breakfast",
    "bubble_tea",
    "burger",
    "cake",
    "chicken",
    "chinese",
    "coffee_shop",
    "crepe",
    "donut",
    "fish",
    "fish_and_chips",
    "french",
    "friture",
    "georgian",
    "german",
    "greek",
    "grill",
    "hot_dog",
    "ice_cream",
    "indian",
    "indonesian",
    "international",
    "italian",
    "japanese",
    "juice",
    "kebab",
    "korean",
    "lebanese",
    "mediterranean",
    "mexican",
    "noodle",
    "pizza",
    "portuguese",
    "ramen",
    "regional",
    "russian",
    "sandwich",
    "seafood",
    "spanish",
    "steak_house",
    "sushi",
    "tapas",
    "tex-mex",
    "thai",
    "turkish",
    "vietnamese",
    "wings",
  ]),
  historic([
    "archaeological_site",
    "bomb_crater",
    "boundary_stone",
    "building",
    "castle",
    "charcoal_pile",
    "church",
    "city_gate",
    "citywalls",
    "farm",
    "fort",
    "heritage",
    "memorial",
    "milestone",
    "mine",
    "mine_shaft",
    "monument",
    "ruins",
    "shieling",
    "tomb",
    "wayside_cross",
    "wayside_shrine",
  ]),
  landuse([
    "allotments",
    "animal_keeping",
    "apiary",
    "aquaculture",
    "basin",
    "brownfield",
    "cemetery",
    "churchyard",
    "commercial",
    "conservation",
    "construction",
    "depot",
    "education",
    "farm",
    "farmland",
    "farmyard",
    "flowerbed",
    "forest",
    "garages",
    "grass",
    "greenery",
    "greenfield",
    "greenhouse_horticulture",
    "harbour",
    "highway",
    "industrial",
    "landfill",
    "livestock",
    "logging",
    "meadow",
    "military",
    "orchard",
    "plant_nursery",
    "plantation",
    "quarry",
    "railway",
    "recreation_ground",
    "religious",
    "reservoir",
    "reservoir_watershed",
    "residential",
    "retail",
    "salt_pond",
    "school",
    "traffic_island",
    "village_green",
    "vineyard",
    "wasteland",
    "winter_sports",
  ]),
  leisure([
    "adult_gaming_centre",
    "amusement_arcade",
    "bandstand",
    "beach_resort",
    "bird_hide",
    "bleachers",
    "bowling_alley",
    "climbing",
    "common",
    "dance",
    "disc_golf_course",
    "dog_park",
    "escape_game",
    "firepit",
    "fishing",
    "fitness_centre",
    "fitness_station",
    "garden",
    "golf_course",
    "hackerspace",
    "horse_riding",
    "ice_rink",
    "marina",
    "miniature_golf",
    "nature_reserve",
    "outdoor_seating",
    "park",
    "picnic_table",
    "pitch",
    "playground",
    "recreation_ground",
    "resort",
    "sauna",
    "schoolyard",
    "slipway",
    "sport",
    "sports_centre",
    "sports_hall",
    "stadium",
    "summer_camp",
    "swimming_area",
    "swimming_pool",
    "tanning_salon",
    "track",
    "trampoline_park",
    "water_park",
    "wildlife_hide",
  ]),
  man_made([
    "adit",
    "advertising",
    "antenna",
    "avalanche_protection",
    "beacon",
    "beam",
    "beehive",
    "breakwater",
    "bridge",
    "bunker_silo",
    "cairn",
    "chimney",
    "clearcut",
    "cooling",
    "courtyard",
    "crane",
    "cross",
    "cutline",
    "dolphin",
    "dovecote",
    "dyke",
    "embankment",
    "excavation",
    "flagpole",
    "flare",
    "gantry",
    "gasometer",
    "geoglyph",
    "goods_conveyor",
    "groyne",
    "kiln",
    "lamp",
    "lighthouse",
    "manhole",
    "mast",
    "mine",
    "mineshaft",
    "monitoring_station",
    "observatory",
    "offshore_platform",
    "petroleum_well",
    "pier",
    "pipeline",
    "planter",
    "pumping_rig",
    "pumping_station",
    "quay",
    "reservoir",
    "reservoir_covered",
    "silo",
    "snow_cannon",
    "snow_fence",
    "spoil_heap",
    "storage_tank",
    "street_cabinet",
    "surveillance",
    "survey_point",
    "tank",
    "tar_kiln",
    "telephone_office",
    "telescope",
    "torii",
    "tower",
    "utility_pole",
    "wastewater_plant",
    "water_tank",
    "water_tap",
    "water_tower",
    "water_well",
    "water_works",
    "watermill",
    "wildlife_crossing",
    "windmill",
    "works",
  ]),
  natural([
    "bare_rock",
    "bay",
    "beach",
    "cape",
    "cave_entrance",
    "cliff",
    "coastline",
    "crevasse",
    "glacier",
    "grassland",
    "heath",
    "hill",
    "land",
    "mud",
    "peak",
    "reef",
    "ridge",
    "rock",
    "sand",
    "scree",
    "scrub",
    "shingle",
    "shrub",
    "sinkhole",
    "spring",
    "stone",
    "tree",
    "tree_row",
    "valley",
    "water",
    "wetland",
    "wood",
  ]),
  place([
    "allotments",
    "archipelago",
    "block",
    "borough",
    "city",
    "city_block",
    "county",
    "district",
    "farm",
    "hamlet",
    "island",
    "islet",
    "isolated_dwelling",
    "locality",
    "municipality",
    "neighbourhood",
    "plot",
    "quarter",
    "region",
    "square",
    "state",
    "suburb",
    "town",
    "village",
  ]),
  power([
    "cable",
    "cable_distribution",
    "catenary_mast",
    "compensator",
    "generator",
    "heliostat",
    "insulator",
    "line",
    "minor_line",
    "plant",
    "pole",
    "portal",
    "substation",
    "switch",
    "switchgear",
    "terminal",
    "tower",
    "transformer",
  ]),
  public_transport([
    "platform",
    "pole",
    "station",
    "stop_area",
    "stop_position",
  ]),
  religion([
    "buddhist",
    "christian",
    "hindu",
    "jewish",
    "multifaith",
    "muslim",
    "none",
    "shinto",
    "sikh",
    "spiritualist",
    "taoist",
  ]),
  shop([
    "agrarian",
    "alcohol",
    "antiques",
    "appliance",
    "art",
    "baby_goods",
    "bag",
    "bakery",
    "bathroom_furnishing",
    "beauty",
    "bed",
    "beverages",
    "bicycle",
    "boat",
    "bookmaker",
    "books",
    "boutique",
    "butcher",
    "cannabis",
    "car",
    "car_parts",
    "car_repair",
    "carpet",
    "charity",
    "cheese",
    "chemist",
    "chocolate",
    "clothes",
    "coffee",
    "computer",
    "confectionery",
    "convenience",
    "copyshop",
    "cosmetics",
    "craft",
    "curtain",
    "dairy",
    "deli",
    "department_store",
    "doityourself",
    "dry_cleaning",
    "e-cigarette",
    "electrical",
    "electronics",
    "erotic",
    "estate_agent",
    "fabric",
    "farm",
    "fashion_accessories",
    "fishing",
    "flooring",
    "florist",
    "food",
    "frame",
    "frozen_food",
    "funeral_directors",
    "furniture",
    "garden_centre",
    "gas",
    "general",
    "gift",
    "greengrocer",
    "grocery",
    "hairdresser",
    "hairdresser_supply",
    "hardware",
    "health_food",
    "hearing_aids",
    "herbalist",
    "hifi",
    "houseware",
    "ice_cream",
    "interior_decoration",
    "jewelry",
    "kiosk",
    "kitchen",
    "laundry",
    "leather",
    "lighting",
    "locksmith",
    "lottery",
    "mall",
    "massage",
    "medical_supply",
    "mobile_phone",
    "money_lender",
    "motorcycle",
    "motorcycle_repair",
    "music",
    "musical_instrument",
    "newsagent",
    "nutrition_supplements",
    "optician",
    "outdoor",
    "outpost",
    "paint",
    "party",
    "pastry",
    "pawnbroker",
    "perfumery",
    "pet",
    "pet_grooming",
    "photo",
    "radiotechnics",
    "religion",
    "rental",
    "scuba_diving",
    "seafood",
    "second_hand",
    "sewing",
    "shoe_repair",
    "shoes",
    "sports",
    "stationery",
    "storage_rental",
    "supermarket",
    "tailor",
    "tattoo",
    "tea",
    "ticket",
    "tiles",
    "tobacco",
    "toys",
    "trade",
    "travel_agency",
    "tyres",
    "vacant",
    "variety_store",
    "video",
    "video_games",
    "watches",
    "water",
    "wholesale",
    "wine",
  ]),
  sport([
    "10pin",
    "american_football",
    "archery",
    "athletics",
    "badminton",
    "baseball",
    "basketball",
    "beachvolleyball",
    "billiards",
    "bmx",
    "boules",
    "bowls",
    "canoe",
    "chess",
    "climbing",
    "cricket",
    "cycling",
    "disc_golf",
    "equestrian",
    "exercise",
    "field_hockey",
    "fitness",
    "football",
    "free_flying",
    "futsal",
    "gaelic_games",
    "golf",
    "gymnastics",
    "handball",
    "hockey",
    "horse_racing",
    "horseshoes",
    "ice_hockey",
    "ice_skating",
    "karting",
    "model_aerodrome",
    "motocross",
    "motor",
    "multi",
    "netball",
    "padel",
    "pelota",
    "rugby",
    "rugby_league",
    "rugby_union",
    "running",
    "scuba_diving",
    "shooting",
    "skateboard",
    "skiing",
    "soccer",
    "softball",
    "swimming",
    "table_tennis",
    "tennis",
    "volleyball",
    "yoga",
  ]),
  tourism([
    "alpine_hut",
    "apartment",
    "aquarium",
    "artwork",
    "attraction",
    "cabin",
    "camp_pitch",
    "camp_site",
    "caravan_site",
    "chalet",
    "gallery",
    "guest_house",
    "hostel",
    "hotel",
    "information",
    "motel",
    "museum",
    "picnic_site",
    "picnic_table",
    "resort",
    "theme_park",
    "trail_riding_station",
    "viewpoint",
    "wilderness_hut",
    "wine_cellar",
    "zoo",
  ]),
  fixme([]),
  ;

  final List<String> vals;

  const TagKeys(this.vals);
}
