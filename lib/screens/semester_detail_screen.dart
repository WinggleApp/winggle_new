import 'package:flutter/material.dart';
import '../services/subject_service.dart';
import '../services/pdf_upload_service.dart';
import '../services/note_service.dart';
import '../models/semester.dart';
import '../models/subject.dart';
import '../models/note.dart';

class SemesterDetailScreen extends StatefulWidget {
  final Semester semester;

  const SemesterDetailScreen({super.key, required this.semester});

  @override
  State<SemesterDetailScreen> createState() => _SemesterDetailScreenState();
}

class _SemesterDetailScreenState extends State<SemesterDetailScreen> {
  final SubjectService _subjectService = SubjectService();
  final NoteService _noteService = NoteService();
  final PdfUploadService _pdfService = PdfUploadService();
  
  List<Subject> _subjects = [];
  List<Note> _notes = [];
  bool _isLoading = true;
  Map<String, int> _subjectNoteCounts = {};

  @override
  void initState() {
    super.initState();
    _loadSemesterData();
  }

  Future<void> _loadSemesterData() async {
    try {
      // Get subjects for this semester
      List<Subject> subjects = await _subjectService.getSemesterSubjects(widget.semester.id);
      
      // Get all notes for this semester
      List<Note> notes = await _noteService.getSemesterNotes(widget.semester.id);
      
      // Count notes per subject
      Map<String, int> noteCounts = {};
      for (Subject subject in subjects) {
        noteCounts[subject.id] = notes.where((note) => note.subjectId == subject.id).length;
      }

      setState(() {
        _subjects = subjects;
        _notes = notes;
        _subjectNoteCounts = noteCounts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  Future<void> _uploadPdfForSubject(Subject subject) async {
    try {
      String? downloadUrl = await _pdfService.pickAndUploadPdf(
        title: '${subject.name} - Study Material',
        subjectId: subject.id,
        semesterId: widget.semester.id,
        tags: [subject.code, subject.name, widget.semester.displayName],
        isPublic: false, // Default to private
      );

      if (downloadUrl != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Refresh data to show updated note count
        _loadSemesterData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSubjectDetails(Subject subject) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF10b981),
                      child: Text(
                        subject.code.substring(0, 2),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${subject.code} • ${subject.credits} credits',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Upload section
                      Card(
                        color: const Color(0xFF10b981).withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Upload Study Material',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Share your PDF notes, assignments, or study materials for this subject.',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _uploadPdfForSubject(subject);
                                  },
                                  icon: const Icon(Icons.upload_file),
                                  label: const Text('Upload PDF'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF10b981),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Subject info
                      const Text(
                        'Subject Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      _buildInfoRow('Description', subject.description),
                      _buildInfoRow('Faculty', subject.faculty),
                      _buildInfoRow('Department', subject.department),
                      
                      const SizedBox(height: 20),
                      
                      // Topics
                      if (subject.topics.isNotEmpty) ...[
                        const Text(
                          'Topics Covered',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: subject.topics.map((topic) => Chip(
                            label: Text(topic),
                            backgroundColor: const Color(0xFF10b981).withOpacity(0.1),
                          )).toList(),
                        ),
                      ],
                      
                      const SizedBox(height: 20),
                      
                      // Recent notes
                      Text(
                        'Recent Notes (${_subjectNoteCounts[subject.id] ?? 0})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Show recent notes for this subject
                      ...(_notes.where((note) => note.subjectId == subject.id).take(3).map((note) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.note, color: Color(0xFF10b981)),
                          title: Text(note.title),
                          subtitle: Text(
                            note.content.length > 50
                                ? '${note.content.substring(0, 50)}...'
                                : note.content,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (note.tags.contains('PDF'))
                                const Icon(Icons.picture_as_pdf, color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              Text('${note.likes}'),
                              const SizedBox(width: 4),
                              const Icon(Icons.favorite, color: Colors.red, size: 16),
                            ],
                          ),
                        ),
                      ))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.semester.displayName),
        backgroundColor: const Color(0xFF10b981),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadSemesterData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Semester info card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  widget.semester.isActive ? Icons.check_circle : Icons.circle_outlined,
                                  color: widget.semester.isActive ? Colors.green : Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.semester.isActive ? 'Active Semester' : 'Inactive Semester',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: widget.semester.isActive ? Colors.green : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Academic Year: ${widget.semester.academicYear}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            Text(
                              'Branch: ${widget.semester.branch}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            Text(
                              'Department: ${widget.semester.department}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Subjects section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subjects (${_subjects.length})',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_notes.length} total notes',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Subject cards with upload functionality
                    if (_subjects.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(Icons.school, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('No subjects found for this semester'),
                            ],
                          ),
                        ),
                      )
                    else
                      ..._subjects.map((subject) => Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: const Color(0xFF10b981),
                                    child: Text(
                                      subject.code.substring(0, 2),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          subject.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${subject.code} • ${subject.credits} credits • ${subject.faculty}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${_subjectNoteCounts[subject.id] ?? 0} notes',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Action buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _showSubjectDetails(subject),
                                      icon: const Icon(Icons.info_outline, size: 16),
                                      label: const Text('Details'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF10b981),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _uploadPdfForSubject(subject),
                                      icon: const Icon(Icons.upload_file, size: 16),
                                      label: const Text('Upload PDF'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF10b981),
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )),
                  ],
                ),
              ),
            ),
    );
  }
}
