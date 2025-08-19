import 'package:flutter/material.dart';
import 'package:mydiaree/core/services/user_type_helper.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/reflection/data/model/reflection_list_model.dart' hide Center;
import 'package:mydiaree/features/reflection/data/repositories/reflection_repository.dart';
import 'package:mydiaree/features/reflection/presentation/pages/add_reflection_screen.dart';
import 'package:mydiaree/features/reflection/presentation/widget/reflection_list_custom_widgets.dart';

class ReflectionListScreen extends StatefulWidget {
  const ReflectionListScreen({Key? key}) : super(key: key);

  @override
  _ReflectionListScreenState createState() => _ReflectionListScreenState();
}

class _ReflectionListScreenState extends State<ReflectionListScreen> {
  final _repo = ReflectionRepository();

  String _selectedCenterId = '1';
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _errorMessage;

  int _currentPage = 1;
  bool _hasMore = true;
  List<Reflection> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchPage();
  }

  Future<void> _fetchPage({int page = 1}) async {
    if (page == 1) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    } else {
      setState(() => _isLoadingMore = true);
    }

    final response = await _repo.getReflections(
      centerId: _selectedCenterId,
      page: page,
    );

    if (response.success && response.data?.data?.reflection?.data != null) {
      final newData = response.data!.data!.reflection!.data!;
      setState(() {
        if (page == 1) {
          _items = newData;
        } else {
          _items.addAll(newData);
        }
        _currentPage = page;
        _hasMore = newData.isNotEmpty;
        _isLoading = false;
        _isLoadingMore = false;
      });
    } else {
      setState(() {
        _errorMessage = response.message;
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _deleteReflection(String id) async {
    setState(() => _isLoading = true);
    final resp = await _repo.deleteReflection(id);
    if (resp.success) {
      _fetchPage(page: 1);
    } else {
      setState(() {
        _errorMessage = resp.message;
        _isLoading = false;
      });
    }
  }

  String _formatDate(String? iso) {
    if (iso == null) return '';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    return "${dt.month}/${dt.day}/${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Reflection'),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                UIHelpers.addButton( 
                  ontap: () async {
                    // Await for result from AddReflectionScreen
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddReflectionScreen(
                          centerId: _selectedCenterId,
                          screenType: 'add',
                        ),
                      ),
                    );
                    // If result is not null (i.e., reflection was added/edited), reload list
                    if (result != null) {
                      _fetchPage(page: 1);
                    }
                  }, context: context,
                ),
              ],
            ),
            const SizedBox(height: 20,),
            CenterDropdown(
                selectedCenterId: _selectedCenterId,
                onChanged: (c) {
                  setState(() {
                    _selectedCenterId = c.id;
                    });
                    _fetchPage(page: 1);
                  },
                ),
            const SizedBox(height: 12),
            if (_isLoading && _currentPage == 1)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_errorMessage != null)
              Expanded(child: Center(child: Text(_errorMessage!)))
            else if (_items.isEmpty)
              const Expanded(child: Center(child: Text('No reflections found')))
            else
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (_hasMore &&
                        !_isLoadingMore &&
                        scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent) {
                      _fetchPage(page: _currentPage + 1);
                    }
                    return true;
                  },
                  child: ListView.builder(
                    itemCount: _items.length + (_isLoadingMore ? 1 : 0),
                    itemBuilder: (ctx, i) {
                      if (i >= _items.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final r = _items[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ReflectionCard(
                          images: r.media?.map((m) => m.mediaUrl ?? '').toList() ?? [],
                          title: r.title ?? '',
                          date: _formatDate(r.createdAt?.toString()),
                          children: r.children
                                  ?.map((c) => ChildrenModel(
                                      name: c.child?.name ?? '',
                                      imageUrl: c.child?.imageUrl ?? ''))
                                  .toList() ??
                              [],
                          educators: r.staff
                                  ?.map((s) => EducatorModel(
                                      name: s.staff?.name ?? '',
                                      imageUrl: s.staff?.imageUrl ?? ''))
                                  .toList() ??
                              [],
                          permissionUpdate: (!UserTypeHelper.isParent),
                          permissionDelete: (!UserTypeHelper.isParent),
                          onEditPressed: () async {
                            // navigate to edit and reload list on return
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddReflectionScreen(
                                  centerId: _selectedCenterId,
                                  id: r.id.toString(),
                                  screenType: 'edit',
                                ),
                              ),
                            );
                            if (result != null) {
                              _fetchPage(page: 1);
                            }
                          },
                          onDeletePressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                content: const Text('Delete this reflection?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _deleteReflection(r.id.toString());
                                    },
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('No'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
