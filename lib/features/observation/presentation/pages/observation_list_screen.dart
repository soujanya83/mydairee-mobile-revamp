import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/cubit/globle_model/center_model.dart';
import 'package:mydiaree/core/cubit/globle_repository.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/observation/data/model/add_new_observation_response.dart'
    hide Center;
import 'package:mydiaree/features/observation/data/model/child_response.dart';
import 'package:mydiaree/features/observation/data/model/observation_api_response.dart';
import 'package:mydiaree/features/observation/data/model/staff_response.dart';
import 'package:mydiaree/features/observation/data/repositories/observation_repositories.dart';
import 'package:mydiaree/features/observation/presentation/pages/add_observation/add_observation_screen.dart';
import 'package:mydiaree/features/observation/presentation/pages/view_observation_screen.dart';
import 'package:mydiaree/features/observation/presentation/widget/observation_filter_dialog.dart';
import 'package:mydiaree/features/observation/presentation/widget/observation_list_custom_widgets.dart';
import 'package:mydiaree/core/services/user_type_helper.dart';
import 'package:mydiaree/main.dart';

class ObservationListScreen extends StatefulWidget {
  const ObservationListScreen({Key? key}) : super(key: key);

  @override
  State<ObservationListScreen> createState() => _ObservationListScreenState();
}

class _ObservationListScreenState extends State<ObservationListScreen> {
  final ObservationRepository _repository = ObservationRepository();
  final TextEditingController _searchController = TextEditingController();

  // State variables
  bool _isLoading = true;
  bool _isSearching = false;
  bool _isFiltering = false;
  bool _isLoadingMore = false; // for infinite scroll loader
  String _errorMessage = '';
  String _selectedCenterId = ''; // Default center ID

  // Data variables
  ObservationApiResponse? _observationsData;
  List<ChildObservationModel> _children = [];
  List<StaffModel> _staff = [];

  // Filter variables
  String _searchQuery = '';
  String _statusFilter = '';

  // For advanced filtering
  List<String> _authorIds = [];
  List<String> _childIds = [];
  String _fromDate = '';
  String _toDate = '';
  List<String> _statuses = [];

  // pagination variables
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void initState() {
    _selectedCenterId = globalSelectedCenterId??'';
    super.initState();
    initDataGet();
  }

  initDataGet() async {
    _currentPage = 1;
    _hasMore = true;
    await _fetchObservations(page: 1);
    await _fetchFilterData();
  }

  // Fetch initial observations
  Future<void> _fetchObservations({
    int page = 1,
    String searchQuery = '',
    String statusFilter = '',
  }) async {
    if (mounted) {
      setState(() {
        if (page == 1) _isLoading = true;
        _errorMessage = '';
      });
    }

    try {
      final response = await _repository.getObservations(
        centerId: _selectedCenterId,
        page: page,
        searchQuery: searchQuery,
        statusFilter: statusFilter,
      );

      if (response.success && response.data != null) {
        setState(() {
          _currentPage = page;
          _hasMore = (response.data!.observations.isNotEmpty);
          if (page == 1) {
            _observationsData = response.data;
          } else {
            _observationsData?.observations.addAll(response.data!.observations);
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load observations: $e';
        _isLoading = false;
      });
    }
  }

  // Search observations
  Future<void> _searchObservations(String query) async {
    setState(() {
      _isSearching = true;
      _searchQuery = query;

      // Reset advanced filter variables when searching
      _authorIds = [];
      _childIds = [];
      _fromDate = '';
      _toDate = '';
      _statuses = [];
    });

    try {
      final response = await _repository.getObservations(
        centerId: _selectedCenterId,
        searchQuery: query,
        statusFilter: _statusFilter,
      );

      if (response.success && response.data != null) {
        setState(() {
          _observationsData = response.data;
          _isSearching = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message;
          _isSearching = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to search observations: $e';
        _isSearching = false;
      });
    }
  }

  // Apply status filter
  // Future<void> _filterObservations(String statusFilter) async {
  //   setState(() {
  //     _isFiltering = true;
  //     _statusFilter = statusFilter;

  //     // Reset advanced filter variables when using simple status filter
  //     _authorIds = [];
  //     _childIds = [];
  //     _fromDate = '';
  //     _toDate = '';
  //     _statuses = [];
  //   });

  //   try {
  //     final response = await _repository.getObservations(
  //       centerId: _selectedCenterId, // Use selected center
  //       searchQuery: _searchQuery,
  //       statusFilter: statusFilter,
  //     );

  //     if (response.success && response.data != null) {
  //       setState(() {
  //         _observationsData = response.data;
  //         _isFiltering = false;
  //       });
  //     } else {
  //       setState(() {
  //         _errorMessage = response.message;
  //         _isFiltering = false;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _errorMessage = 'Failed to filter observations: $e';
  //       _isFiltering = false;
  //     });
  //   }
  // }

  // Apply advanced filters
  Future<void> _applyAdvancedFilters(
    List<String> authorIds,
    List<String> childIds,
    String fromDate,
    String toDate,
    List<String> statuses,
  ) async {
    setState(() {
      _isFiltering = true;
      _authorIds = authorIds;
      _childIds = childIds;
      _fromDate = fromDate;
      _toDate = toDate;
      _statuses = statuses;
    });

    try {
      final response = await _repository.filterObservations(
        centerId: _selectedCenterId, // Use selected center
        authorIds: authorIds,
        childIds: childIds,
        fromDate: fromDate,
        toDate: toDate,
        statuses: statuses,
      );

      if (response.success && response.data != null) {
        setState(() {
          _observationsData = response.data;
          _isFiltering = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message;
          _isFiltering = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to apply advanced filters: $e';
        _isFiltering = false;
      });
    }
  }

  // Fetch children and staff for filtering based on selected center
  Future<void> _fetchFilterData() async {
    try {
      // Fetch children
      final childrenResponse = await _repository.getChildren(
        centerId: _selectedCenterId,
      );

      if (childrenResponse.success && childrenResponse.data != null) {
        setState(() {
          _children = childrenResponse.data!.children;
        });
      }

      // Fetch staff
      final staffResponse = await _repository.getStaff(
        centerId: _selectedCenterId,
      );

      if (staffResponse.success && staffResponse.data != null) {
        setState(() {
          _staff = staffResponse.data!.staff;
        });
      }
    } catch (e) {
      print('Failed to load filter data: $e');
    }
  }

  // Handle center selection change
  void _onCenterChanged(Datum selectedCenter) {
    setState(() {
      _isLoading = true;
      _selectedCenterId = selectedCenter.id.toString();

      // Reset ALL filter variables when center changes
      _searchQuery = '';
      _statusFilter = '';
      _searchController.clear();

      // Also reset advanced filter variables
      _authorIds = [];
      _childIds = [];
      _fromDate = '';
      _toDate = '';
      _statuses = [];
    });

    _fetchObservations().then((_) {
      // _fetchFilterData().then((_) {
      //   setState(() {
      //     _isLoading = false; // Hide loading when both operations complete
      //   });
      // }).catchError((error) {
      //   setState(() {
      //     _isLoading = false; // Also hide loading on error
      //     _errorMessage = 'Failed to load filter data: $error';
      //   });
      // });
    }).catchError((error) {
      setState(() {
        _isLoading = false; // Also hide loading on error
        _errorMessage = 'Failed to load observations: $error';
      });
    });
  }

  void _handleStatusFilter(String status) {
    setState(() {
      _statusFilter = status;
    });
    if (_statusFilter == status) {
      _applyAdvancedFilters(
        _authorIds,
        _childIds,
        _fromDate,
        _toDate,
        [status],
      );
      // _filterObservations(status);
    } else {
      _applyAdvancedFilters(
        _authorIds,
        _childIds,
        _fromDate,
        _toDate,
        [status],
      );
      // _filterObservations(status);
    }
  }

  void _showAdvancedFilterDialog() {
    final childrenForFilter = _children
        .map((child) => {
              'id': child.id.toString(),
              'name': '${child.name} ${child.lastname}',
              'imageUrl': child.imageUrl.isNotEmpty
                  ? '${AppUrls.baseUrl}/${child.imageUrl}'
                  : '',
            })
        .toList();

    final authorsForFilter = _staff
        .map((author) => {
              'id': author.id.toString(),
              'name': author.name,
              'imageUrl': author.imageUrl.isNotEmpty
                  ? '${AppUrls.baseUrl}/${author.imageUrl}'
                  : '',
            })
        .toList();
    showDialog(
      context: context,
      builder: (context) => ObservationFilterDialog(
        children: childrenForFilter,
        authors: authorsForFilter,
        initialAuthorIds: _authorIds,
        initialChildIds: _childIds,
        initialFromDate: _fromDate,
        initialToDate: _toDate,
        initialStatuses: _statuses,

        onApplyFilters: (authorIds, childIds, fromDate, toDate, statuses) {
          _applyAdvancedFilters(
            authorIds ?? [],
            childIds ?? [],
            fromDate ?? '',
            toDate ?? '',
            statuses ?? [],
          );
        },
      ),
    );
  }

  // View observation details
  void _viewObservation(int observationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewObservationScreen(
          id: observationId.toString(),
        ),
      ),
    );
  }

  // Add this function to your _ObservationListScreenState class
  String _cleanHtmlContent(String? htmlString) {
    if (htmlString == null || htmlString.isEmpty) {
      return 'No Title';
    }

    // Remove HTML tags
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String result = htmlString.replaceAll(exp, '');

    // Decode HTML entities
    result = result
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('</p>', "'")
        .replaceAll('<p>', "'")
        .replaceAll("'", "");

    // Trim whitespace and limit length if needed
    result = result.trim();
    if (result.isEmpty) {
      return 'No Title';
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Observations',
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final observations = _observationsData?.observations ?? [];

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (_hasMore &&
            scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent &&
            !_isLoadingMore &&
            !_isLoading) {
          setState(() => _isLoadingMore = true);
          _fetchObservations(
            page: _currentPage + 1,
            searchQuery: _searchQuery,
            statusFilter: _statusFilter,
          ).whenComplete(() {
            if (mounted) setState(() => _isLoadingMore = false);
          });
        }
        return true;
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        GlobalRepository().getCenters();
                      },
                      child: Text(
                        'Observations',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              color: AppColors.primaryColor,
                            ),
                      ),
                    ),
                    if (!UserTypeHelper.isParent)
                      UIHelpers.addButton(
                        context: context,
                        ontap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddObservationScreen(
                                        type: 'add',
                                        centerId: _selectedCenterId,
                                      )));
                        },
                      ),
                  ],
                ),
              ),

              // center dropdown
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: CenterDropdown(
                  selectedCenterId: _selectedCenterId,
                  onChanged: _onCenterChanged,
                ),
              ),

              // Search field using custom text field
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 16.0),
              //   child: CustomTextFormWidget(
              //     controller: _searchController,
              //     hintText: 'Search observations...',
              //     prefixWidget: const Icon(Icons.search),
              //     suffixWidget: _searchController.text.isNotEmpty
              //         ? IconButton(
              //             icon: const Icon(Icons.clear),
              //             onPressed: () {
              //               _searchController.clear();
              //               _searchObservations('');
              //             },
              //           )
              //         : null,
              //     onFieldSubmitted: (value) {
              //       _searchObservations(value);
              //     },
              //     onChanged: (value) {
              //       // if (value?.isEmpty ?? true) {
              //       //   _searchObservations('');
              //       // }
              //     },
              //     borderSide: const BorderSide(
              //       color: Colors.grey,
              //       width: 1,
              //     ),
              //     contentpadding: const EdgeInsets.symmetric(
              //       vertical: 12,
              //       horizontal: 16,
              //     ),
              //   ),
              // ),

              // Filter options
              if(!UserTypeHelper.isParent)
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                           if(!UserTypeHelper.isParent)
                          _buildFilterChip(
                            'All',
                            _statusFilter.isEmpty,
                            () {
                              setState(() {
                                _statusFilter = '';
                              });
                              _applyAdvancedFilters([], [], '', '', []);
                            },
                          ),
                          if (!UserTypeHelper.isParent)
                            _buildFilterChip(
                              'Draft',
                              _statusFilter == 'draft',
                              () => _handleStatusFilter('draft'),
                            ),
                           if(!UserTypeHelper.isParent)
                          _buildFilterChip(
                            'Published',
                            _statusFilter == 'published',
                            () => _handleStatusFilter('published'),
                          ),
                          if (!UserTypeHelper.isParent)
                            _buildFilterChip(
                              'Pending',
                              _statusFilter == 'pending',
                              () => _handleStatusFilter('pending'),
                            ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: _showAdvancedFilterDialog,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Observation count
              // Text(
              //   'Found ${observations.length} observations',
              //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
              //         fontWeight: FontWeight.w500,
              //       ),
              // ),
              // const SizedBox(height: 16),

              // **List area**: only this part reacts to _isLoading / error
              if (_isLoading)
                Padding(
                  padding: EdgeInsetsGeometry.only(top: screenHeight*.3),
                  child: const Center(child: CircularProgressIndicator()))
              else if (_errorMessage.isNotEmpty)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Retry',
                        ontap: () => _fetchObservations(),
                      ),
                    ],
                  ),
                )
              else if (observations.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'No observations found',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: observations.length,
                  itemBuilder: (context, index) {
                    final observation = observations[index];

                    // Prepare image URL if available
                    String? mediaUrl;
                    if (observation.media.isNotEmpty) {
                      mediaUrl =
                          '${AppUrls.baseUrl}/${observation.media[0].mediaUrl}';
                    }
                    if(UserTypeHelper.isParent && observation.status.toLowerCase()=='draft' ){
                      return SizedBox();
                    }

                    // Replace the existing ObservationCard creation in ListView.builder's itemBuilder
                    return ObservationCard(
                      title: _cleanHtmlContent(observation.title),
                      dateAdded: observation.date_added,
                      status: observation.status,
                      mediaUrl: mediaUrl,
                      onTap: () => _viewObservation(observation.id),
                      author: observation.user?.name ?? 'Unknown',
                      approvedBy:
                          observation.approver != null ? 'Admin' : 'Pending',
                    );
                  },
                ),
            if (_isLoadingMore)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
              // if still in search/filter mode, lightly dim & show spinner
              if (_isSearching || _isFiltering)
                Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
