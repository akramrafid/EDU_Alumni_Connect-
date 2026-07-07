class MockEvent {
  final String id;
  final String tag;
  final String date;
  final String time;
  final String title;
  final String location;
  final int attendees;
  final int maxAttendees;
  final String description;
  final String image;

  const MockEvent({
    required this.id,
    required this.tag,
    required this.date,
    required this.time,
    required this.title,
    required this.location,
    required this.attendees,
    required this.maxAttendees,
    required this.description,
    required this.image,
  });
}

final List<MockEvent> mockEvents = [
  const MockEvent(
    id: 'ai-hackathon',
    tag: 'COMPUTER CLUB',
    date: 'OCT 12',
    time: '9:00 AM',
    title: 'AI Hackathon',
    location: 'Colosseum, East Delta University',
    attendees: 85,
    maxAttendees: 100,
    description: 'Join the annual AI Hackathon organized by the East Delta University Computer Club. Build cutting-edge AI solutions, collaborate with peers, and showcase your skills to industry mentors.',
    image: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
  ),
  const MockEvent(
    id: 'programming-contest',
    tag: 'COMPUTER CLUB',
    date: 'OCT 15',
    time: '2:00 PM',
    title: 'Competitive Programming Contest',
    location: 'Amphitheatre, East Delta University',
    attendees: 120,
    maxAttendees: 150,
    description: 'Test your coding speed and problem-solving skills at our Competitive Programming Contest. Compete against top students and stand a chance to win exciting prizes and internships.',
    image: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
  ),
  const MockEvent(
    id: 'nlp-workshop',
    tag: 'COMPUTER CLUB',
    date: 'OCT 18',
    time: '10:00 AM',
    title: 'NLP Workshop',
    location: 'Main Lobby, East Delta University',
    attendees: 60,
    maxAttendees: 60,
    description: 'Dive deep into Natural Language Processing with our hands-on NLP Workshop. Learn about text preprocessing, sentiment analysis, and transformer models from alumni experts.',
    image: 'https://images.unsplash.com/photo-1515187029135-18ee286d815b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
  ),
  const MockEvent(
    id: 'sqa-workshop',
    tag: 'COMPUTER CLUB',
    date: 'OCT 20',
    time: '11:30 AM',
    title: 'SQA Workshop',
    location: 'Colosseum, East Delta University',
    attendees: 45,
    maxAttendees: 50,
    description: 'Learn the industry standards of Software Quality Assurance. This SQA Workshop covers manual testing, automated testing with Selenium, and writing clean test cases.',
    image: 'https://images.unsplash.com/photo-1531482615713-2afd69097998?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
  ),
  const MockEvent(
    id: 'alumni-gala',
    tag: 'NETWORKING',
    date: 'OCT 24',
    time: '6:00 PM',
    title: 'Annual Alumni Gala & Charity Dinner',
    location: 'Main Lobby, East Delta University',
    attendees: 120,
    maxAttendees: 150,
    description: 'The Annual Alumni Gala & Charity Dinner at East Delta University. Reconnect with fellow graduates, enjoy a curated multi-course dinner, and participate in our scholarship charity drive.',
    image: 'https://images.unsplash.com/photo-1511578314322-379afb476865?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
  ),
  const MockEvent(
    id: 'tech-leadership',
    tag: 'WEBINAR',
    date: 'OCT 26',
    time: '7:00 PM',
    title: 'Tech Leadership Future 2026',
    location: 'Amphitheatre, East Delta University',
    attendees: 85,
    maxAttendees: 200,
    description: 'Join our distinguished panel of alumni leaders discussing the future of tech leadership, global remote work opportunities, and upcoming industry trends.',
    image: 'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
  ),
];
