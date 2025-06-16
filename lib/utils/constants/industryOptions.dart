const industryOptions = [
  {'value': "aerospace", 'label': "Aerospace"},
  {'value': "agri-tech", 'label': "Agri-tech"},
  {'value': "ai", 'label': "AI"},
  {'value': "advertising", 'label': "Advertising"},
  {'value': "aerotech", 'label': "Aerotech"},
  {'value': "art", 'label': "Art"},
  {
    'value': "automobiles_and_components",
    'label': "Automobiles and Components"
  },
  {'value': "banks", 'label': "Banks"},
  {'value': "beautification", 'label': "Beautification"},
  {'value': "biotech", 'label': "Biotech"},
  {'value': "blockchain", 'label': "Blockchain"},
  {'value': "business_industry", 'label': "Business Industry"},
  {'value': "buy_and_selling", 'label': "Buy and Selling"},
  {'value': "capital_goods", 'label': "Capital Goods"},
  {
    'value': "commercial_and_professional_services",
    'label': "Commercial and Professional Services",
  },
  {
    'value': "consumer_durables_and_apparel",
    'label': "Consumer Durables and Apparel",
  },
  {'value': "consumer_services", 'label': "Consumer Services"},
  {'value': "cryptocurrency", 'label': "Cryptocurrency"},
  {'value': "digital_marketing", 'label': "Digital Marketing"},
  {'value': "diversified_financials", 'label': "Diversified Financials"},
  {'value': "e-commerce", 'label': "E-commerce"},
  {'value': "edtech", 'label': "Edtech"},
  {'value': "education", 'label': "Education"},
  {'value': "energy", 'label': "Energy"},
  {'value': "fashion", 'label': "Fashion"},
  {'value': "fintech", 'label': "Fintech"},
  {
    'value': "food_and_staples_retailing",
    'label': "Food and Staples Retailing"
  },
  {
    'value': "food_beverage_and_tobacco",
    'label': "Food, Beverage, and Tobacco"
  },
  {'value': "finance", 'label': "Finance"},
  {
    'value': "health_care_equipment_and_services",
    'label': "Health Care Equipment and Services",
  },
  {'value': "health-tech", 'label': "Health-tech"},
  {'value': "healthcare", 'label': "Healthcare"},
  {'value': "hospitality", 'label': "Hospitality"},
  {
    'value': "household_and_personal_products",
    'label': "Household and UserModelal Products",
  },
  {'value': "insuretech", 'label': "Insuretech"},
  {'value': "insurance", 'label': "Insurance"},
  {'value': "legal", 'label': "Legal"},
  {'value': "manufacturing", 'label': "Manufacturing"},
  {'value': "materials", 'label': "Materials"},
  {'value': "media_and_entertainment", 'label': "Media and Entertainment"},
  {'value': "metaverse", 'label': "Metaverse"},
  {'value': "mining", 'label': "Mining"},
  {'value': "online_communities", 'label': "Online Communities"},
  {'value': "other", 'label': "Other"},
  {
    'value': "pharmaceuticals_biotechnology_and_life_sciences",
    'label': "Pharmaceuticals, Biotechnology, and Life Sciences",
  },
  {'value': "production", 'label': "Production"},
  {'value': "public_relations", 'label': "Public Relations"},
  {'value': "real_estate", 'label': "Real Estate"},
  {'value': "retailing", 'label': "Retailing"},
  {
    'value': "semiconductors_and_semiconductor_equipment",
    'label': "Semiconductors and Semiconductor Equipment",
  },
  {'value': "software_and_services", 'label': "Software and Services"},
  {
    'value': "telecommunication_services",
    'label': "Telecommunication Services"
  },
  {
    'value': "technology_hardware_and_equipment",
    'label': "Technology Hardware and Equipment",
  },
  {'value': "transportation", 'label': "Transportation"},
  {'value': "utilities", 'label': "Utilities"},
  {'value': "virtual_services", 'label': "Virtual Services"},
];

const serviceCategories = [
  {'value': "auto-accessories", 'label': "Auto Accessories"},
  {'value': "auto-dealers-new", 'label': "Auto Dealers – New"},
  {'value': "auto-dealers-used", 'label': "Auto Dealers – Used"},
  {'value': "detail-carwash", 'label': "Detail & Carwash"},
  {'value': "gas-stations", 'label': "Gas Stations"},
  {'value': "motorcycle-sales-repair", 'label': "Motorcycle Sales & Repair"},
  {'value': "rental-leasing", 'label': "Rental & Leasing"},
  {'value': "service-repair-parts", 'label': "Service Repair & Parts"},
  {'value': "towing", 'label': "Towing"},
  {'value': "consultants", 'label': "Consultants"},
  {'value': "employment-agency", 'label': "Employment Agency"},
  {'value': "marketing-communications", 'label': "Marketing & Communications"},
  {'value': "office-supplies", 'label': "Office Supplies"},
  {'value': "printing-publishing", 'label': "Printing & Publishing"},
  {
    'value': "computer-programming-support",
    'label': "Computer Programming & Support"
  },
  {
    'value': "consumer-electronics-accessories",
    'label': "Consumer Electronics & Accessories"
  },
  {
    'value': "architects-landscape-architects-engineers-surveyors",
    'label': "Architects Landscape Architects Engineers & Surveyors"
  },
  {'value': "blasting-demolition", 'label': "Blasting & Demolition"},
  {
    'value': "building-materials-supplies",
    'label': "Building Materials & Supplies"
  },
  {'value': "construction-companies", 'label': "Construction Companies"},
  {'value': "electricians", 'label': "Electricians"},
  {'value': "engineer-survey", 'label': "Engineer Survey"},
  {'value': "environmental-assessments", 'label': "Environmental Assessments"},
  {'value': "inspectors", 'label': "Inspectors"},
  {'value': "plaster-concrete", 'label': "Plaster & Concrete"},
  {'value': "plumbers", 'label': "Plumbers"},
  {'value': "roofers", 'label': "Roofers"},
  {
    'value': "adult-continuing-education",
    'label': "Adult & Continuing Education"
  },
  {'value': "early-childhood-education", 'label': "Early Childhood Education"},
  {'value': "educational-resources", 'label': "Educational Resources"},
  {'value': "other-educational", 'label': "Other Educational"},
  {
    'value': "desserts-catering-supplies",
    'label': "Desserts Catering & Supplies"
  },
  {'value': "fast-food-carry-out", 'label': "Fast Food & Carry Out"},
  {'value': "grocery-beverage-tobacco", 'label': "Grocery Beverage & Tobacco"},
  {'value': "restaurants", 'label': "Restaurants"},
  {'value': "acupuncture", 'label': "Acupuncture"},
  {
    'value': "assisted-living-home-health-care",
    'label': "Assisted Living & Home Health Care"
  },
  {'value': "audiologist", 'label': "Audiologist"},
  {'value': "chiropractic", 'label': "Chiropractic"},
  {'value': "clinics-medical-centers", 'label': "Clinics & Medical Centers"},
  {'value': "dental", 'label': "Dental"},
  {'value': "diet-nutrition", 'label': "Diet & Nutrition"},
  {'value': "animal-hospital", 'label': "Animal Hospital"},
  {
    'value': "veterinary-animal-surgeons",
    'label': "Veterinary & Animal Surgeons"
  },
  {'value': "antiques-collectibles", 'label': "Antiques & Collectibles"},
  {'value': "home-furnishings", 'label': "Home Furnishings"},
  {'value': "home-goods", 'label': "Home Goods"},
  {
    'value': "home-improvements-repairs",
    'label': "Home Improvements & Repairs"
  },
  {'value': "landscape-lawn-service", 'label': "Landscape & Lawn Service"},
  {'value': "pest-control", 'label': "Pest Control"},
  {'value': "accountants", 'label': "Accountants"},
  {'value': "attorneys", 'label': "Attorneys"},
  {'value': "financial-institutions", 'label': "Financial Institutions"},
  {'value': "insurance", 'label': "Insurance"},
  {'value': "manufacturing", 'label': "Manufacturing"},
  {'value': "wholesale", 'label': "Wholesale"},
  {'value': "cards-gifts", 'label': "Cards & Gifts"},
  {'value': "clothing-accessories", 'label': "Clothing & Accessories"},
  {'value': "jewelry", 'label': "Jewelry"},
  {'value': "animal-care-supplies", 'label': "Animal Care & Supplies"},
  {'value': "barber-beauty-salons", 'label': "Barber & Beauty Salons"},
  {'value': "beauty-supplies", 'label': "Beauty Supplies"},
  {'value': "exercise-fitness", 'label': "Exercise & Fitness"},
  {'value': "massage-body-works", 'label': "Massage & Body Works"},
  {'value': "nail-salons", 'label': "Nail Salons"},
  {'value': "shoe-repairs", 'label': "Shoe Repairs"},
  {'value': "agencies-brokerage", 'label': "Agencies & Brokerage"},
  {
    'value': "hotel-motel-extended-stay",
    'label': "Hotel Motel & Extended Stay"
  },
  {'value': "moving-storage", 'label': "Moving & Storage"},
  {'value': "packaging-shipping", 'label': "Packaging & Shipping"},
  {'value': "transportation", 'label': "Transportation"},
  {'value': "travel-tourism", 'label': "Travel & Tourism"},
];
