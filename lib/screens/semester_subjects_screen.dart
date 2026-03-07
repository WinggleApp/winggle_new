import 'package:flutter/material.dart';
import '../services/subject_service.dart';
import '../services/pdf_upload_service.dart';
import '../services/note_service.dart';
import '../services/database_init_service.dart';
import '../utils/auto_database_initializer.dart';
import '../models/subject.dart';
import '../models/note.dart';

class SemesterSubjectsScreen extends StatefulWidget {
  final String departmentName;
  final String departmentShort;
  final Color departmentColor;
  final int semester;
  final int year;

  const SemesterSubjectsScreen({
    super.key,
    required this.departmentName,
    required this.departmentShort,
    required this.departmentColor,
    required this.semester,
    required this.year,
  });

  @override
  State<SemesterSubjectsScreen> createState() => _SemesterSubjectsScreenState();
}

class _SemesterSubjectsScreenState extends State<SemesterSubjectsScreen> {
  final SubjectService _subjectService = SubjectService();
  final NoteService _noteService = NoteService();
  final PdfUploadService _pdfService = PdfUploadService();
  final DatabaseInitService _dbInit = DatabaseInitService();
  
  List<Subject> _subjects = [];
  List<Note> _notes = [];
  bool _isLoading = true;
  bool _isInitializing = false;
  Map<String, int> _subjectNoteCounts = {};

  @override
  void initState() {
    super.initState();
    _loadSemesterData();
    // Also ensure database is initialized in background
    AutoDatabaseInitializer.ensureInitialized();
    
    // Set up a periodic check to reload data if database gets initialized
    _periodicDataCheck();
  }

  void _periodicDataCheck() {
    // Check every 2 seconds for the first 10 seconds if database gets initialized
    int checks = 0;
    const maxChecks = 5;
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && checks < maxChecks) {
        if (_subjects.isEmpty && AutoDatabaseInitializer.isInitialized) {
          _loadSemesterData(); // Reload data if database was just initialized
        } else if (_subjects.isEmpty) {
          _periodicDataCheck(); // Continue checking
        }
        checks++;
      }
    });
  }

  Future<void> _loadSemesterData() async {
    try {
      // Get semester ID based on semester number
      String semesterId = 'sem_${widget.semester}';
      print('Loading data for semester: $semesterId');
      
      // Get subjects for this semester
      List<Subject> subjects = await _subjectService.getSemesterSubjects(semesterId);
      print('Found ${subjects.length} subjects');
      
      // Get all notes for this semester
      List<Note> notes = await _noteService.getSemesterNotes(semesterId);
      print('Found ${notes.length} notes');
      
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
      print('Error in _loadSemesterData: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  Future<void> _initializeDatabase() async {
    setState(() => _isInitializing = true);
    
    try {
      await _dbInit.initializeDatabase();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Database initialized successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Reload data after initialization
      _loadSemesterData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to initialize database: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isInitializing = false);
    }
  }

  Future<void> _uploadPdfForSubject(Subject subject) async {
    try {
      String? downloadUrl = await _pdfService.pickAndUploadPdf(
        title: '${subject.name} - Study Material',
        subjectId: subject.id,
        semesterId: 'sem_${widget.semester}',
        tags: [subject.code, subject.name, 'Semester ${widget.semester}'],
        isPublic: false,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF064e3b)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Semester ${widget.semester}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF064e3b),
              ),
            ),
            Text(
              '${widget.departmentShort} - Year ${widget.year}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFf0fdf4), Color(0xFFecfdf5), Colors.white],
          ),
        ),
        child: Column(
          children: [
            _buildSemesterHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadSemesterData,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (_subjects.isEmpty)
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Column(
                                  children: [
                                    Icon(Icons.school, size: 64, color: Colors.grey),
                                    SizedBox(height: 16),
                                    Text('No subjects found for this semester'),
                                    Text('Database might not be initialized yet'),
                                    SizedBox(height: 24),
                                    if (_isInitializing)
                                      Column(
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(height: 16),
                                          Text('Initializing database...'),
                                        ],
                                      )
                                    else
                                      ElevatedButton.icon(
                                        onPressed: _initializeDatabase,
                                        icon: const Icon(Icons.cloud_download),
                                        label: const Text('Initialize Database'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: widget.departmentColor,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ..._subjects.map((subject) => _buildSubjectCard(subject)),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSemesterHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: widget.departmentColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: widget.departmentColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildHeaderStat(_subjects.length.toString(), 'Subjects', Icons.book),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          _buildHeaderStat('${_notes.length}', 'Notes', Icons.description),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          _buildHeaderStat('${_subjects.length * 4}+', 'Credits', Icons.star),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: widget.departmentColor, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF064e3b),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectCard(Subject subject) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.departmentColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: widget.departmentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.book,
                    color: widget.departmentColor,
                    size: 24,
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
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF064e3b),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subject.code,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: widget.departmentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${subject.credits} Credits',
                    style: TextStyle(
                      fontSize: 11,
                      color: widget.departmentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(Icons.description, '${_subjectNoteCounts[subject.id] ?? 0} Notes', Colors.blue),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.person, subject.faculty, Colors.purple),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.tag, '${subject.topics.length} Topics', Colors.orange),
              ],
            ),
            const SizedBox(height: 12),
            // Upload buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Show subject details modal
                      _showSubjectDetails(subject);
                    },
                    icon: const Icon(Icons.info_outline, size: 16),
                    label: const Text('Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: widget.departmentColor,
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
                      backgroundColor: widget.departmentColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showSubjectDetails(Subject subject) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
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
                      backgroundColor: widget.departmentColor,
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
                        color: widget.departmentColor.withOpacity(0.1),
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
                                    backgroundColor: widget.departmentColor,
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
                            backgroundColor: widget.departmentColor.withOpacity(0.1),
                          )).toList(),
                        ),
                      ],
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
}
