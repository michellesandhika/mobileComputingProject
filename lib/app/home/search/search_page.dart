import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/app/home/job_entries/edit_job_entries.dart';
import 'package:starter_architecture_flutter_firebase/app/home/sells/add_sells_page.dart';
import 'package:starter_architecture_flutter_firebase/app/home/sells/job_list_tile.dart';
import 'package:starter_architecture_flutter_firebase/app/home/sells/list_items_builder.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/job.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:starter_architecture_flutter_firebase/app/top_level_providers.dart';
import 'package:starter_architecture_flutter_firebase/constants/strings.dart';
import 'package:pedantic/pedantic.dart';
import 'package:starter_architecture_flutter_firebase/services/firestore_database.dart';

final jobsStreamProvider = StreamProvider.autoDispose<List<Job>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.jobsStream();
});

// watch database
class SearchPage extends ConsumerWidget {
  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = context.read<FirestoreDatabase>(databaseProvider);
      await database.deleteJob(job);
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: 'Operation failed',
        exception: e,
      ));
    }
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.search)
      ),
      body: _buildContents(context, watch),
    );
  }

  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final jobsAsyncValue = watch(jobsStreamProvider);
    return ListItemsBuilder<Job>(
      data: jobsAsyncValue,
      itemBuilder: (context, job) => Dismissible(
        key: Key('job-${job.id}'),
        background: Container(color: Colors.red),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => _delete(context, job),
        child: JobListTile(
          job: job,
          onTap: () => JobEntriesPage.show(context, job),
        ),
      ),
    );
  }
}
