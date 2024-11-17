import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final GetIt locator = GetIt.instance;

final _logger = Logger();

// TODO test
/*
FutureBuilder<List<GroupConditionItem>> buildConditionsList(
    AppGroup group, AppListType listType) {
  return FutureBuilder<List<GroupAppItem>>(
    future: _fetchSavedApps(listType, group),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        _logger.e('Error loading apps: ${snapshot.error}');
        return Center(
            child: Text(
                '${AppLocalizations.of(context)!.error}: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text(AppLocalizations.of(context)!.noAppsFound));
      } else {
        final groupApps = snapshot.data!;
        return ListView.builder(
          itemCount: groupApps.length,
          itemBuilder: (context, index) {
            return groupApps[index];
          },
        );
      }
    },
  );
}

class GroupConditionItem extends StatefulWidget {
  final String conditionedGroupId;
  final String conditionedGroupName;
  final String conditionalGroupId;
  final String conditionalGroupName;
  final Duration usedTime;
  final int duringLastDays;

  const GroupConditionItem({
    required this.conditionedGroupId,
    required this.conditionedGroupName,
    required this.conditionalGroupId,
    required this.conditionalGroupName,
    required this.usedTime,
    required this.duringLastDays,
    super.key,
  });

  @override
  GroupAppItemState createState() => GroupAppItemState();
}

class GroupAppItemState extends State<GroupConditionItem> {
  final Logger _logger = Logger();

  bool _isSwitched = false;
  bool _isDisabled = false;
  final GroupConditionService _service = locator<GroupConditionService>();

  @override
  void initState() {
    super.initState();
    _loadSwitchValue();
  }

  Future<void> _loadSwitchValue() async {
    setState(() {
      _isSwitched = widget.listId == widget.listedApp.listId;
      _isDisabled = widget.listedApp.listId != null &&
          widget.listedApp.listId != widget.listId;
    });
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Building app item for ${widget.appInfo.name} with icon: '
        '${widget.appInfo.icon}');
    return ListTile(
      leading: Image.memory(
        widget.appInfo.icon!,
        errorBuilder: (context, error, stackTrace) {
          _logger.e(
              'Error loading image: $error - context: $context - stack trace: $stackTrace');
          return const Icon(Icons.apps);
        },
      ),
      title: Text(widget.appInfo.name),
      trailing: Switch(
        value: _isSwitched,
        onChanged: _isDisabled
            ? null
            : (value) async {
                setState(() {
                  _isSwitched = value;
                });
                final listId = value ? widget.listId : null;
                final listedApp = widget.listedApp.copyWith(
                  listId: listId,
                );
                await _service.updateListedApp(listedApp);
              },
      ),
    );
  }
}
*/
