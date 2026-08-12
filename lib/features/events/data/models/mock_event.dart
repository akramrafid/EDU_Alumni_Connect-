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
    id: 'latex-workshop',
    tag: 'TECH WORKSHOPS',
    date: 'OCT 28',
    time: '10:00 AM',
    title: 'Workshop 6: LaTeX: The Art and Science of Academic Typesetting',
    location: 'Auditorium, East Delta University',
    attendees: 65,
    maxAttendees: 80,
    description: 'Master the art and science of academic typesetting with LaTeX. Learn paper formatting, mathematical equation rendering, and thesis structure for international publications.',
    image: 'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
  ),
  const MockEvent(
    id: 'cp-bootcamp',
    tag: 'HACKATHONS',
    date: 'NOV 02',
    time: '3:00 PM',
    title: 'Competitive Programming Bootcamp',
    location: 'Computer Lab 3, East Delta University',
    attendees: 95,
    maxAttendees: 100,
    description: 'Intensive competitive programming bootcamp focusing on advanced data structures, dynamic programming, graph algorithms, and contest strategy.',
    image: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
  ),
  const MockEvent(
    id: 'future-proofing-ai',
    tag: 'ALUMNI TALKS',
    date: 'NOV 05',
    time: '4:00 PM',
    title: 'Future-Proofing Your Career: Surviving and Thriving in the AI Era',
    location: 'Amphitheatre, East Delta University',
    attendees: 140,
    maxAttendees: 150,
    description: 'An inspiring session by senior alumni on navigating career shifts, mastering AI workflows, and staying competitive in the rapidly evolving tech market.',
    image: 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
  ),
  const MockEvent(
    id: 'code-to-chips',
    tag: 'TECH WORKSHOPS',
    date: 'NOV 08',
    time: '11:00 AM',
    title: 'From Code to Chips: How C++ Powers Modern Software and Semiconductor Engineering',
    location: 'Colosseum, East Delta University',
    attendees: 80,
    maxAttendees: 100,
    description: 'Explore high-performance systems engineering, memory management, and how modern C++ powers low-level firmware and semiconductor design.',
    image: 'https://images.unsplash.com/photo-1518770660439-4636190af475?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
  ),
  const MockEvent(
    id: 'transformers-nlp',
    tag: 'WEBINAR',
    date: 'NOV 12',
    time: '6:00 PM',
    title: 'Transformers: NLP and the Reason Behind Its Current Evolution',
    location: 'Online Zoom Webinar',
    attendees: 180,
    maxAttendees: 200,
    description: 'Unpack the architecture of Transformer models, attention mechanisms, and the breakthrough innovations behind modern LLMs and ChatGPT.',
    image: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
  ),
  const MockEvent(
    id: 'edu-ai-hackathon',
    tag: 'HACKATHONS',
    date: 'NOV 18',
    time: '9:00 AM',
    title: 'EDU AI Engineering Hackathon – Season 01',
    location: 'Colosseum, East Delta University',
    attendees: 110,
    maxAttendees: 120,
    description: 'Season 01 of the flagship EDU AI Engineering Hackathon! Form teams, build AI agents and innovative web apps, and pitch to top tech investors.',
    image: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
  ),
  const MockEvent(
    id: 'edu-iupc-2026',
    tag: 'COMPUTER CLUB',
    date: 'NOV 25',
    time: '2:00 PM',
    title: 'EDU Intra University Programming Contest - Summer 2026',
    location: 'Amphitheatre, East Delta University',
    attendees: 135,
    maxAttendees: 150,
    description: 'The annual flagship intra-university programming contest at East Delta University. Solve algorithmic challenges and win certificates & awards.',
    image: 'https://images.unsplash.com/photo-1531482615713-2afd69097998?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
  ),
];
