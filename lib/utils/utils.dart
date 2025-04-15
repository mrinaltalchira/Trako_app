import 'package:Trako/color/colors.dart';
import 'package:flutter/material.dart';

class LocationSelectDialog extends StatefulWidget {
  final String? selectedState;
  final String? selectedCity;

  const LocationSelectDialog(
      {super.key, this.selectedState, this.selectedCity});

  @override
  _LocationSelectDialogState createState() => _LocationSelectDialogState();
}

class _LocationSelectDialogState extends State<LocationSelectDialog> {
  String? _selectedState;
  String? _selectedCity;

  List<String> _states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi',
    'Puducherry',
    'Jammu and Kashmir'
  ];
  Map<String, List<String>> _cities = {
    'Andaman and Nicobar Islands': ['Port Blair'],
    'Andhra Pradesh': [
      'Adoni',
      'Amaravati',
      'Anantapur',
      'Chandragiri',
      'Chittoor',
      'Dowlaiswaram',
      'Eluru',
      'Guntur',
      'Kadapa',
      'Kakinada',
      'Kurnool',
      'Machilipatnam',
      'Nagarjunakoṇḍa',
      'Rajahmundry',
      'Srikakulam',
      'Tirupati',
      'Vijayawada',
      'Visakhapatnam',
      'Vizianagaram',
      'Yemmiganur'
    ],
    'Arunachal Pradesh': ['Itanagar'],
    'Assam': [
      'Dhuburi',
      'Dibrugarh',
      'Dispur',
      'Guwahati',
      'Jorhat',
      'Nagaon',
      'Sivasagar',
      'Silchar',
      'Tezpur',
      'Tinsukia'
    ],
    'Bihar': [
      'Ara',
      'Barauni',
      'Begusarai',
      'Bettiah',
      'Bhagalpur',
      'Bihar Sharif',
      'Bodh Gaya',
      'Buxar',
      'Chapra',
      'Darbhanga',
      'Dehri',
      'Dinapur Nizamat',
      'Gaya',
      'Hajipur',
      'Jamalpur',
      'Katihar',
      'Madhubani',
      'Motihari',
      'Munger',
      'Muzaffarpur',
      'Patna',
      'Purnia',
      'Pusa',
      'Saharsa',
      'Samastipur',
      'Sasaram',
      'Sitamarhi',
      'Siwan'
    ],
    'Chandigarh': ['Chandigarh'],
    'Chhattisgarh': [
      'Ambikapur',
      'Bhilai',
      'Bilaspur',
      'Dhamtari',
      'Durg',
      'Jagdalpur',
      'Raipur',
      'Rajnandgaon'
    ],
    'Dadra and Nagar Haveli and Daman and Diu': ['Daman', 'Diu', 'Silvassa'],
    'Delhi': ['Delhi', 'New Delhi'],
    'Goa': ['Madgaon', 'Panaji'],
    'Gujarat': [
      'Ahmedabad',
      'Amreli',
      'Bharuch',
      'Bhavnagar',
      'Bhuj',
      'Dwarka',
      'Gandhinagar',
      'Godhra',
      'Jamnagar',
      'Junagadh',
      'Kandla',
      'Khambhat',
      'Kheda',
      'Mahesana',
      'Morbi',
      'Nadiad',
      'Navsari',
      'Okha',
      'Palanpur',
      'Patan',
      'Porbandar',
      'Rajkot',
      'Surat',
      'Surendranagar',
      'Valsad',
      'Veraval'
    ],
    'Haryana': [
      'Ambala',
      'Bhiwani',
      'Chandigarh',
      'Faridabad',
      'Firozpur Jhirka',
      'Gurugram',
      'Hansi',
      'Hisar',
      'Jind',
      'Kaithal',
      'Karnal',
      'Kurukshetra',
      'Panipat',
      'Pehowa',
      'Rewari',
      'Rohtak',
      'Sirsa',
      'Sonipat'
    ],
    'Himachal Pradesh': [
      'Bilaspur',
      'Chamba',
      'Dalhousie',
      'Dharmshala',
      'Hamirpur',
      'Kangra',
      'Kullu',
      'Mandi',
      'Nahan',
      'Shimla',
      'Una'
    ],
    'Jammu and Kashmir': [
      'Anantnag',
      'Baramula',
      'Doda',
      'Gulmarg',
      'Jammu',
      'Kathua',
      'Punch',
      'Rajouri',
      'Srinagar',
      'Udhampur'
    ],
    'Jharkhand': [
      'Bokaro',
      'Chaibasa',
      'Deoghar',
      'Dhanbad',
      'Dumka',
      'Giridih',
      'Hazaribag',
      'Jamshedpur',
      'Jharia',
      'Rajmahal',
      'Ranchi',
      'Saraikela'
    ],
    'Karnataka': [
      'Badami',
      'Ballari',
      'Bengaluru',
      'Belagavi',
      'Bhadravati',
      'Bidar',
      'Chikkamagaluru',
      'Chitradurga',
      'Davangere',
      'Halebid',
      'Hassan',
      'Hubballi-Dharwad',
      'Kalaburagi',
      'Kolar',
      'Madikeri',
      'Mandya',
      'Mangaluru',
      'Mysuru',
      'Raichur',
      'Shivamogga',
      'Shravanabelagola',
      'Shrirangapattana',
      'Tumakuru',
      'Vijayapura'
    ],
    'Kerala': [
      'Alappuzha',
      'Vatakara',
      'Idukki',
      'Kannur',
      'Kochi',
      'Kollam',
      'Kottayam',
      'Kozhikode',
      'Mattancheri',
      'Palakkad',
      'Thalassery',
      'Thiruvananthapuram',
      'Thrissur'
    ],
    'Madhya Pradesh': [
      'Balaghat',
      'Barwani',
      'Betul',
      'Bharhut',
      'Bhind',
      'Bhojpur',
      'Bhopal',
      'Burhanpur',
      'Chhatarpur',
      'Chhindwara',
      'Damoh',
      'Datia',
      'Dewas',
      'Dhar',
      'Dr. Ambedkar Nagar',
      'Guna',
      'Gwalior',
      'Hoshangabad',
      'Indore',
      'Itarsi',
      'Jabalpur',
      'Jhabua',
      'Khajuraho',
      'Khandwa',
      'Khargone',
      'Maheshwar',
      'Mandla',
      'Mandsaur',
      'Morena',
      'Murwara',
      'Narsimhapur',
      'Narsinghgarh',
      'Neemuch',
      'Orchha',
      'Panna',
      'Raisen',
      'Rajgarh',
      'Ratlam',
      'Rewa',
      'Sagar',
      'Satna',
      'Sehore',
      'Seoni',
      'Shahdol',
      'Shajapur',
      'Sheopur',
      'Shivpuri',
      'Ujjain',
      'Vidisha'
    ],
    'Maharashtra': [
      'Ahmadnagar',
      'Akola',
      'Amravati',
      'Aurangabad',
      'Bhandara',
      'Bhusawal',
      'Bid',
      'Buldhana',
      'Chandrapur',
      'Daulatabad',
      'Dhule',
      'Jalgaon',
      'Kalyan',
      'Karli',
      'Kolhapur',
      'Mahabaleshwar',
      'Malegaon',
      'Matheran',
      'Mumbai',
      'Nagpur',
      'Nanded',
      'Nashik',
      'Osmanabad',
      'Pandharpur',
      'Parbhani',
      'Pune',
      'Ratnagiri',
      'Sangli',
      'Satara',
      'Sevagram',
      'Solapur',
      'Thane',
      'Ulhasnagar',
      'Vasai-Virar',
      'Wardha',
      'Yavatmal'
    ],
    'Manipur': ['Imphal'],
    'Meghalaya': ['Cherrapunji', 'Shillong'],
    'Mizoram': ['Aizawl', 'Lunglei'],
    'Nagaland': ['Kohima', 'Mon', 'Phek', 'Wokha', 'Zunheboto'],
    'Odisha': [
      'Balangir',
      'Baleshwar',
      'Baripada',
      'Bhubaneshwar',
      'Brahmapur',
      'Cuttack',
      'Dhenkanal',
      'Kendujhar',
      'Konark',
      'Koraput',
      'Paradip',
      'Phulabani',
      'Puri',
      'Sambalpur',
      'Udayagiri'
    ],
    'Puducherry': ['Karaikal', 'Mahe', 'Puducherry', 'Yanam'],
    'Punjab': [
      'Amritsar',
      'Batala',
      'Chandigarh',
      'Faridkot',
      'Firozpur',
      'Gurdaspur',
      'Hoshiarpur',
      'Jalandhar',
      'Kapurthala',
      'Ludhiana',
      'Nabha',
      'Patiala',
      'Rupnagar',
      'Sangrur'
    ],
    'Rajasthan': [
      'Abu',
      'Ajmer',
      'Alwar',
      'Amer',
      'Barmer',
      'Beawar',
      'Bharatpur',
      'Bhilwara',
      'Bikaner',
      'Bundi',
      'Chittaurgarh',
      'Churu',
      'Dhaulpur',
      'Dungarpur',
      'Ganganagar',
      'Hanumangarh',
      'Jaipur',
      'Jaisalmer',
      'Jalor',
      'Jhalawar',
      'Jhunjhunu',
      'Jodhpur',
      'Kishangarh',
      'Kota',
      'Merta',
      'Nagaur',
      'Nathdwara',
      'Pali',
      'Phalodi',
      'Pushkar',
      'Sawai Madhopur',
      'Shahpura',
      'Sikar',
      'Sirohi',
      'Tonk',
      'Udaipur'
    ],
    'Sikkim': ['Gangtok', 'Gyalshing', 'Lachung', 'Mangan'],
    'Tamil Nadu': [
      'Arcot',
      'Chengalpattu',
      'Chennai',
      'Chidambaram',
      'Coimbatore',
      'Cuddalore',
      'Dharmapuri',
      'Dindigul',
      'Erode',
      'Kanchipuram',
      'Kanniyakumari',
      'Kodaikanal',
      'Kumbakonam',
      'Madurai',
      'Mamallapuram',
      'Nagappattinam',
      'Nagercoil',
      'Palayamkottai',
      'Pudukkottai',
      'Rajapalayam',
      'Ramanathapuram',
      'Salem',
      'Thanjavur',
      'Tiruchchirappalli',
      'Tirunelveli',
      'Tiruppur',
      'Thoothukudi',
      'Udhagamandalam',
      'Vellore'
    ],
    'Telangana': [
      'Hyderabad',
      'Karimnagar',
      'Khammam',
      'Mahbubnagar',
      'Nizamabad',
      'Sangareddi',
      'Warangal'
    ],
    'Tripura': ['Agartala'],
    'Uttar Pradesh': [
      'Agra',
      'Aligarh',
      'Amroha',
      'Ayodhya',
      'Azamgarh',
      'Bahraich',
      'Ballia',
      'Banda',
      'Bara Banki',
      'Bareilly',
      'Basti',
      'Bijnor',
      'Bithur',
      'Budaun',
      'Bulandshahr',
      'Deoria',
      'Etah',
      'Etawah',
      'Faizabad',
      'Farrukhabad',
      'Fatehpur',
      'Ghaziabad',
      'Ghazipur',
      'Gonda',
      'Gorakhpur',
      'Hamirpur',
      'Hardoi',
      'Hathras',
      'Jalaun',
      'Jaunpur',
      'Jhansi',
      'Kannauj',
      'Kanpur',
      'Lakhimpur',
      'Lalitpur',
      'Lucknow',
      'Mainpuri',
      'Mathura',
      'Meerut',
      'Mirzapur',
      'Moradabad',
      'Muzaffarnagar',
      'Partapgarh',
      'Pilibhit',
      'Prayagraj',
      'Rae Bareli',
      'Rampur',
      'Saharanpur',
      'Sambhal',
      'Shahjahanpur',
      'Sitapur',
      'Sultanpur',
      'Tehri',
      'Varanasi'
    ],
    'Uttarakhand': [
      'Almora',
      'Dehra Dun',
      'Haridwar',
      'Mussoorie',
      'Nainital',
      'Pithoragarh'
    ],
    'West Bengal': [
      'Alipore',
      'Alipur Duar',
      'Asansol',
      'Baharampur',
      'Bally',
      'Balurghat',
      'Bankura',
      'Baranagar',
      'Barasat',
      'Barrackpore',
      'Basirhat',
      'Bhatpara',
      'Bishnupur',
      'Budge Budge',
      'Burdwan',
      'Chandernagore',
      'Darjeeling',
      'Diamond Harbour',
      'Dum Dum',
      'Durgapur',
      'Halisahar',
      'Haora',
      'Hugli',
      'Ingraj Bazar',
      'Jalpaiguri',
      'Kalimpong',
      'Kamarhati',
      'Kanchrapara',
      'Kharagpur',
      'Cooch Behar',
      'Kolkata',
      'Krishnanagar',
      'Malda',
      'Midnapore',
      'Murshidabad',
      'Nabadwip',
      'Palashi',
      'Panihati',
      'Purulia',
      'Raiganj',
      'Santipur',
      'Shantiniketan',
      'Shrirampur',
      'Siliguri',
      'Siuri',
      'Tamluk',
      'Titagarh'
    ]
  };
  @override
  void initState() {
    super.initState();
    _selectedState = widget.selectedState;
    _selectedCity = widget.selectedCity;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                'Select Your Location',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.0),

              // State Selection
              buildLocationSelector(
                title: 'State',
                selectedValue: _selectedState,
                items: _states,
                hint: 'Select State',
                onChanged: (value) {
                  setState(() {
                    _selectedState = value;
                    _selectedCity = null; // Reset city when state changes
                  });
                },
                onClear: () {
                  setState(() {
                    _selectedState = null;
                    _selectedCity = null;
                  });
                },
              ),

              SizedBox(height: 16.0),

              // City Selection (only show if state is selected)
              if (_selectedState != null)
                buildLocationSelector(
                  title: 'City',
                  selectedValue: _selectedCity,
                  items: _cities[_selectedState] ?? [],
                  hint: 'Select City',
                  onChanged: (value) {
                    setState(() {
                      _selectedCity = value;
                    });
                  },
                  onClear: () {
                    setState(() {
                      _selectedCity = null;
                    });
                  },
                ),

              SizedBox(height: 24.0),

              // Confirm Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'state': _selectedState,
                    'city': _selectedCity,
                  });
                } ,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: colorFirstGrad,
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'Confirm Location',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom widget to reduce code duplication
  Widget buildLocationSelector({
    required String title,
    required String? selectedValue,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
    required VoidCallback onClear,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row with title and clear button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (selectedValue != null)
              GestureDetector(
                onTap: onClear,
                child: Text(
                  'Clear',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8.0),

        // Dropdown
        DropdownButtonFormField<String>(
          value: selectedValue,
          isExpanded: true, // This helps prevent overflow
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0
            ),
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          dropdownColor: Colors.white,
          style: TextStyle(color: Colors.black87),
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}