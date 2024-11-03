class ServiceRequest {
  final String personName;
  final String taskName;
  final String serviceDescription;
  final String location;
  final int review;
  final DateTime dateOfRequest;
  final String category;
  final String contactInfo;
  final String statusLevel;
  final int id;

  ServiceRequest({
    required this.personName,
    required this.taskName,
    required this.serviceDescription,
    required this.location,
    required this.review,
    required this.dateOfRequest,
    required this.contactInfo,
    required this.statusLevel,
    required this.category,
    required this.id,
  });
}

List<ServiceRequest> serviceAdded = [
  ServiceRequest(
    id: 1,
    personName: 'Dileep Kumar Sharma',
    taskName: 'Painting a room',
    serviceDescription:
        'Assist with painting a small bedroom with blue and white colors.',
    location: '123 Main St',
    review: 5,
    dateOfRequest: DateTime.now().subtract(const Duration(days: 2)),
    contactInfo: 'dileep@gmail.com',
    statusLevel: 'Open',
    category: 'home_help',
  )
];

List<ServiceRequest> fakeServiceRequests = [
  ServiceRequest(
    id: 1,
    personName: 'John Doe',
    taskName: 'Moving furniture',
    serviceDescription:
        'Assist with moving heavy furniture including a couch and a dining table.',
    location: '123 Main St',
    review: 5,
    dateOfRequest: DateTime.now().subtract(const Duration(days: 2)),
    contactInfo: 'john.doe@example.com',
    statusLevel: 'Completed',
    category: 'home_help',
  ),
  ServiceRequest(
    id: 2,
    personName: 'Jane Smith',
    taskName: 'Math tutoring',
    serviceDescription:
        'Provide tutoring for high school algebra and geometry.',
    location: '456 Elm St',
    review: 4,
    dateOfRequest: DateTime.now().subtract(const Duration(days: 5)),
    contactInfo: 'jane.smith@example.com',
    statusLevel: 'Pending',
    category: 'education_help',
  ),
  ServiceRequest(
    id: 3,
    personName: 'Alice Johnson',
    taskName: 'Conversation partner',
    serviceDescription:
        'Offer companionship and meaningful conversation for someone feeling lonely.',
    location: '789 Oak St',
    review: 4,
    dateOfRequest: DateTime.now().subtract(const Duration(days: 10)),
    contactInfo: 'alice.johnson@example.com',
    statusLevel: 'In Progress',
    category: 'emotional_help',
  ),
  ServiceRequest(
    id: 4,
    personName: 'Bob Brown',
    taskName: 'Community event organization',
    serviceDescription:
        'Help plan and organize a local community gathering, including logistics and attendee coordination.',
    location: '321 Pine St',
    review: 4,
    dateOfRequest: DateTime.now().subtract(const Duration(days: 1)),
    contactInfo: 'bob.brown@example.com',
    statusLevel: 'Completed',
    category: 'other',
  ),
  ServiceRequest(
    id: 5,
    personName: 'Charlie Davis',
    taskName: 'Grocery shopping',
    serviceDescription:
        'Assist with purchasing groceries for a household of four.',
    location: '654 Maple St',
    review: 5,
    dateOfRequest: DateTime.now().subtract(const Duration(days: 3)),
    contactInfo: 'charlie.davis@example.com',
    statusLevel: 'Pending',
    category: 'home_help',
  ),
  ServiceRequest(
    id: 6,
    personName: 'Diana Evans',
    taskName: 'Jogging partner',
    serviceDescription:
        'Join someone for morning jogs to provide motivation and company.',
    location: '987 Birch St',
    review: 3,
    dateOfRequest: DateTime.now().subtract(const Duration(days: 7)),
    contactInfo: 'diana.evans@example.com',
    statusLevel: 'In Progress',
    category: 'emotional_help',
  ),
  ServiceRequest(
    id: 7,
    personName: 'Fiona Green',
    taskName: 'Pet sitting',
    serviceDescription:
        'Care for a small dog, including feeding and walking, while the owner is away.',
    location: '753 Willow St',
    review: 5,
    dateOfRequest: DateTime.now().subtract(const Duration(days: 8)),
    contactInfo: 'fiona.green@example.com',
    statusLevel: 'Pending',
    category: 'home_help',
  ),
];
