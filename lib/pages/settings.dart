import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/models/profile.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/storage.dart';
import 'package:treehole/services/user.dart';
import 'package:treehole/utils/constants.dart';
import 'package:treehole/utils/validator.dart';
import 'package:treehole/utils/ui.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static const String route = '/settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BackHeader(title: 'Settings'),
            Expanded(
              child: Column(
                children: [
                  SubPageListItem(
                    title: 'Change username',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ChangeUsernameDialog();
                        },
                      );
                    },
                  ),
                  const Divider(height: 2, indent: 12, endIndent: 12),
                  SubPageListItem(
                    title: 'Change avatar',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ChangeAvatarDialog();
                        },
                      );
                    },
                  ),
                  const Divider(height: 2, indent: 12, endIndent: 12),
                  SubPageListItem(
                    title: 'Change password',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ChangePasswordDialog();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubPageListItem extends StatelessWidget {
  const SubPageListItem({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChangeUsernameDialog extends StatefulWidget {
  const ChangeUsernameDialog({Key? key}) : super(key: key);

  @override
  _ChangeUsernameDialogState createState() => _ChangeUsernameDialogState();
}

class _ChangeUsernameDialogState extends State<ChangeUsernameDialog> {
  String? _newUsername;

  void _closeDialog() {
    Navigator.of(context).pop();
  }

  void _save(Profile profile) async {
    final newUsername = _newUsername;
    if (newUsername != null) {
      try {
        await BlocProvider.of<UserCubit>(context).saveProfile(
          username: newUsername,
          avatarUrl: profile.avatarUrl,
        );
        Navigator.of(context).pop();
        context.showSnackbar('Successfully changed username');
      } on PlatformException catch (e) {
        context.showErrorSnackbar(e.message ?? 'Error change username');
      } catch (e) {
        context.showErrorSnackbar('Error change username');
      }
    } else {
      context.showSnackbar(
        'New username can\'t be same with the original username.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      if (state is UserLoaded) {
        return AlertDialog(
          title: const Text('Change username'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _newUsername = value;
                  });
                },
                initialValue: state.profile.username,
                decoration: const InputDecoration(labelText: 'New username'),
                validator: Validator.username,
              ),
            ],
          ),
          actions: [
            TextButton(
              style:
                  TextButton.styleFrom(primary: Theme.of(context).errorColor),
              child: const Text('Cancel'),
              onPressed: _closeDialog,
            ),
            TextButton(
              child: const Text('Done'),
              onPressed: () => _save(state.profile),
            ),
          ],
        );
      } else {
        throw Exception('panic: must been loged in.');
      }
    });
  }
}

class ChangeAvatarDialog extends StatefulWidget {
  const ChangeAvatarDialog({Key? key}) : super(key: key);

  @override
  _ChangeAvatarDialogState createState() => _ChangeAvatarDialogState();
}

class _ChangeAvatarDialogState extends State<ChangeAvatarDialog> {
  String? _newAvatar;

  void _closeDialog() {
    Navigator.of(context).pop();
  }

  void _uploadNewAvatar() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) {
      return;
    }
    final userId =
        RepositoryProvider.of<AuthenticationRepository>(context).userId();
    final url = await RepositoryProvider.of<StorageRepository>(context)
        .uploadAvatar(userId, img);
    setState(() {
      _newAvatar = url;
    });
  }

  void _save(Profile profile, String? newAvatar) async {
    try {
      await BlocProvider.of<UserCubit>(context).saveProfile(
        username: profile.username,
        avatarUrl: newAvatar ?? defaultAvatarUrl,
      );
      _closeDialog();
      context.showSnackbar('Successfully changed avatar');
    } on PlatformException catch (e) {
      context.showErrorSnackbar(e.message ?? 'Error change avatar');
    } catch (e) {
      context.showErrorSnackbar('Error change avatar');
    }
  }

  void _saveNoDefault(Profile profile, String? newAvatar) {
    if (newAvatar == null) {
      context.showSnackbar('New avatar can\'t be empty');
      return;
    }
    return _save(profile, newAvatar);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      if (state is UserLoaded) {
        return AlertDialog(
          title: const Text('Change avatar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _uploadNewAvatar,
                child: CircleAvatar(
                  radius: 102 / 2,
                  child: CircleAvatar(
                    radius: 96 / 2,
                    backgroundColor: Theme.of(context).backgroundColor,
                    backgroundImage: NetworkImage(
                      _newAvatar ?? state.profile.avatarUrl ?? defaultAvatarUrl,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary),
              child: const Text('Use default'),
              onPressed: () => _save(state.profile, _newAvatar),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.error),
              child: const Text('Cancel'),
              onPressed: _closeDialog,
            ),
            TextButton(
              child: const Text('Done'),
              onPressed: () => _saveNoDefault(state.profile, _newAvatar),
            ),
          ],
        );
      } else {
        throw Exception('panic: must been loged in.');
      }
    });
  }
}

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({Key? key}) : super(key: key);

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  String? _newPassword;
  String? _confirmPassword;

  void _closeDialog() {
    Navigator.of(context).pop();
  }

  void _save(Profile profile) async {
    if (_newPassword != _confirmPassword) {
      context.showSnackbar('Confirm password is different with new password.');
      return;
    }

    final newPassword = _newPassword;
    if (newPassword != null) {
      try {
        await RepositoryProvider.of<AuthenticationRepository>(context)
            .resetPassword(newPassword);
        Navigator.of(context).pop();
        context.showSnackbar('Successfully changed password');
      } on PlatformException catch (e) {
        context.showErrorSnackbar(e.message ?? 'Error change password');
      } catch (e) {
        context.showErrorSnackbar('Error change password');
      }
    } else {
      context.showSnackbar(
        'New password can\'t be empty.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      if (state is UserLoaded) {
        return AlertDialog(
          title: const Text('Change password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _newPassword = value;
                  });
                },
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New password'),
                validator: Validator.password,
              ),
              const SizedBox(height: 12),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _confirmPassword = value;
                  });
                },
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Confirm password'),
                validator: (val) {
                  final valid = Validator.password(val);
                  if (valid != null) return valid;
                  if (val != _newPassword) {
                    return 'Password is not matching.';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              style:
                  TextButton.styleFrom(primary: Theme.of(context).errorColor),
              child: const Text('Cancel'),
              onPressed: _closeDialog,
            ),
            TextButton(
              child: const Text('Done'),
              onPressed: () => _save(state.profile),
            ),
          ],
        );
      } else {
        throw Exception('panic: must been loged in.');
      }
    });
  }
}
