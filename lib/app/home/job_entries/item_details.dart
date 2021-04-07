import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/job.dart';
import 'package:starter_architecture_flutter_firebase/routing/cupertino_tab_view_router.dart';
import 'package:starter_architecture_flutter_firebase/app/top_level_providers.dart';
import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:flutter/material.dart';

final jobStreamProvider =
StreamProvider.autoDispose.family<Job, String>((ref, jobId) {
  final database = ref.watch(databaseProvider);
  return database.jobStream(jobId: jobId);
});

class JobEntriesAppBarTitle extends ConsumerWidget {
  const JobEntriesAppBarTitle({required this.job});
  final Job job;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final jobAsyncValue = watch(jobStreamProvider(job.id));
    return jobAsyncValue.when(
      data: (job) => Text(job.name),
      loading: () => Container(),
      error: (_, __) => Container(),
    );
  }
}

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({required this.job});

  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    await Navigator.of(context).pushNamed(
      CupertinoTabViewRoutes.jobEntriesPage,
      arguments: job,
    );
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = context.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser!;
    return Scaffold(
      appBar: AppBar(
          title: JobEntriesAppBarTitle(job: job)
      ),
      body: _buildItemDetails(job, context),

    );
  }

  Widget _buildItemDetails(Job job, BuildContext context) {
    return Column(
      children: [
        Text(
          'Name: ${job.name}',
          style: const TextStyle(color: Colors.black),
        ),
        Text(
          job.price.toString(),
          style: const TextStyle(color: Colors.black),
        ),
        Text(
          job.description,
          style: const TextStyle(color: Colors.black),
        ),
        Text(
          job.category,
          style: const TextStyle(color: Colors.black),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: RaisedButton(
              onPressed: () => showAlertDialog(
                context: context,
                title: 'Item Bought',
                content: 'Item is bought! We will inform the seller that you have bought the item',
                defaultActionText: 'OK',
              ),
              child: const Text('Buy!', style: TextStyle(fontSize: 20)),
              color: Colors.blue,
              textColor: Colors.white,
              elevation: 5
          ),
        )
      ],
    );
  }
  // Widget _buyAction(BuildContext context) {
  //
  // }
}

