class College {
  final String id;
  final String name;
  final String location;
  final String degree;
  final int studentCount;
  final bool isPartner;
  final bool isUserCollege;
  final String? iconPath;

  College({
    required this.id,
    required this.name,
    required this.location,
    required this.degree,
    required this.studentCount,
    required this.isPartner,
    required this.isUserCollege,
    this.iconPath,
  });

  static List<College> getColleges() {
    return [
      College(
        id: '1',
        name: 'Engineering College, Barpeta',
        location: 'Barpeta',
        degree: 'B.Tech - Computer Science',
        studentCount: 0,
        isPartner: true,
        isUserCollege: true,
      ),
      College(
        id: '2',
        name: 'Cotton University',
        location: 'Guwahati, Assam',
        degree: '',
        studentCount: 8500,
        isPartner: true,
        isUserCollege: false,
      ),
      College(
        id: '3',
        name: 'Gauhati University',
        location: 'Guwahati, Assam',
        degree: '',
        studentCount: 12000,
        isPartner: true,
        isUserCollege: false,
      ),
      College(
        id: '4',
        name: 'Dibrugarh University',
        location: 'Dibrugarh, Assam',
        degree: '',
        studentCount: 6800,
        isPartner: true,
        isUserCollege: false,
      ),
      College(
        id: '5',
        name: 'Tezpur University',
        location: 'Tezpur, Assam',
        degree: '',
        studentCount: 5500,
        isPartner: false,
        isUserCollege: false,
      ),
      College(
        id: '6',
        name: 'Assam Engineering College',
        location: 'Guwahati, Assam',
        degree: '',
        studentCount: 10000,
        isPartner: true,
        isUserCollege: false,
      ),
      College(
        id: '7',
        name: 'National Institute of Technology (NIT)',
        location: 'Silchar, Assam',
        degree: '',
        studentCount: 7200,
        isPartner: true,
        isUserCollege: false,
      ),
      College(
        id: '8',
        name: 'Indian Institute of Technology (IIT)',
        location: 'Guwahati, Assam',
        degree: '',
        studentCount: 9000,
        isPartner: true,
        isUserCollege: false,
      ),
    ];
  }
}
