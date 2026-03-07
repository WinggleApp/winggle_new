import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/pdf_upload_service.dart';
import '../services/subject_service.dart';
import '../services/semester_service.dart';
import '../models/subject.dart';
import '../models/semester.dart';

class PdfUploadTestScreen extends StatefulWidget {
  const PdfUploadTestScreen({super.key});

  @override
  State<PdfUploadTestScreen> createState() => _PdfUploadTestScreenState();
}

class _PdfUploadTestScreenState extends State<PdfUploadTestScreen> {
  final PdfUploadService _pdfService = PdfUploadService();
  final SubjectService _subjectService = SubjectService();
  final SemesterService _semesterService = SemesterService();
  
  final _titleController = TextEditingController();
  final _tagsController = TextEditingController();
  
  String? _selectedSubjectId;
  String? _selectedSemesterId;
  bool _isPublic = false;
  bool _isLoading = false;
  
  List<Semester> _semesters = [];
  List<Subject> _subjects = [];
  List<Map<String, dynamic>> _userPdfs = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        _semesterService.getAllSemesters(),
        _subjectService.getAllSubjects(),
        _pdfService.getUserPdfs(),
      ]);

      setState(() {
        _semesters = results[0] as List<Semester>;
        _subjects = results[1] as List<Subject>;
        _userPdfs = results[2] as List<Map<String, dynamic>>;
        
        // Select first semester and subject by default
        if (_semesters.isNotEmpty) {
          _selectedSemesterId = _semesters.first.id;
        }
        if (_subjects.isNotEmpty) {
          _selectedSubjectId = _subjects.first.id;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  Future<void> _uploadPdf() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    if (_selectedSubjectId == null || _selectedSemesterId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select subject and semester')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      List<String> tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      String? downloadUrl = await _pdfService.pickAndUploadPdf(
        title: _titleController.text.trim(),
        subjectId: _selectedSubjectId!,
        semesterId: _selectedSemesterId!,
        tags: tags,
        isPublic: _isPublic,
      );

      if (downloadUrl != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear form and refresh data
        _titleController.clear();
        _tagsController.clear();
        _loadData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Upload Test'),
        backgroundColor: const Color(0xFF10b981),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUploadForm(),
            const SizedBox(height: 30),
            _buildUserPdfsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload PDF',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Title field
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Note Title',
                border: OutlineInputBorder(),
                hintText: 'Enter a descriptive title',
              ),
            ),
            const SizedBox(height: 16),
            
            // Semester dropdown
            DropdownButtonFormField<String>(
              value: _selectedSemesterId,
              decoration: const InputDecoration(
                labelText: 'Semester',
                border: OutlineInputBorder(),
              ),
              items: _semesters.map((semester) {
                return DropdownMenuItem(
                  value: semester.id,
                  child: Text(semester.displayName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedSemesterId = value);
              },
            ),
            const SizedBox(height: 16),
            
            // Subject dropdown
            DropdownButtonFormField<String>(
              value: _selectedSubjectId,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
              items: _subjects.map((subject) {
                return DropdownMenuItem(
                  value: subject.id,
                  child: Text('${subject.name} (${subject.code})'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedSubjectId = value);
              },
            ),
            const SizedBox(height: 16),
            
            // Tags field
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags (comma separated)',
                border: OutlineInputBorder(),
                hintText: 'math, calculus, important',
              ),
            ),
            const SizedBox(height: 16),
            
            // Public checkbox
            CheckboxListTile(
              value: _isPublic,
              onChanged: (value) => setState(() => _isPublic = value ?? false),
              title: const Text('Make this note public'),
              subtitle: const Text('Other users can see this note'),
            ),
            
            const SizedBox(height: 20),
            
            // Upload button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _uploadPdf,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10b981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(width: 16),
                          Text('Uploading...'),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file),
                          SizedBox(width: 8),
                          Text('Select and Upload PDF'),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserPdfsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Uploaded PDFs',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_userPdfs.length} files',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_userPdfs.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.picture_as_pdf, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No PDFs uploaded yet'),
                      Text('Upload your first PDF above'),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _userPdfs.length,
                itemBuilder: (context, index) {
                  final pdf = _userPdfs[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                      title: Text(pdf['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pdf['fileName']),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${pdf['createdAt'].toString().split(' ')[0]}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 16),
                              Icon(Icons.favorite, size: 14, color: Colors.red),
                              const SizedBox(width: 4),
                              Text(
                                '${pdf['likes']} likes',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          if (pdf['tags'] != null)
                            ...pdf['tags'].take(2).map<Widget>((tag) => Chip(
                              label: Text(tag, style: const TextStyle(fontSize: 10)),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            )),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
