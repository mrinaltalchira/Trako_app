import 'package:flutter/material.dart';

class ActionConfirmationDialog extends StatelessWidget {
  /// The action being performed (e.g., "Delete", "Logout", "Reset")
  final String actionType;

  /// The item or context of the action (e.g., "Notification", "Account")
  final String? itemName;

  /// The text for the confirmation button
  final String confirmButtonText;

  /// Custom message to display
  final String message;

  /// Custom icon to display
  final IconData icon;

  /// Primary color for the dialog accents and confirm button
  final Color accentColor;

  /// Whether the action is destructive (affects button styling)
  final bool isDestructive;

  /// Callback when action is confirmed
  final VoidCallback onConfirm;

  /// Text for the cancel button
  final String cancelButtonText;

  /// Optional callback when action is canceled
  final VoidCallback? onCancel;

  const ActionConfirmationDialog({
    Key? key,
    required this.actionType,
    this.itemName,
    this.confirmButtonText = 'Confirm',
    required this.message,
    required this.icon,
    required this.accentColor,
    this.isDestructive = false,
    required this.onConfirm,
    this.cancelButtonText = 'Cancel',
    this.onCancel,
  }) : super(key: key);

  /// Shows the confirmation dialog
  static Future<bool> show({
    required BuildContext context,
    required String actionType,
    String? itemName,
    String? confirmButtonText,
    required String message,
    required IconData icon,
    required Color accentColor,
    bool isDestructive = false,
    required VoidCallback onConfirm,
    String cancelButtonText = 'Cancel',
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) async {
    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ActionConfirmationDialog(
          actionType: actionType,
          itemName: itemName,
          confirmButtonText: confirmButtonText ?? (isDestructive ? actionType : 'Confirm'),
          message: message,
          icon: icon,
          accentColor: accentColor,
          isDestructive: isDestructive,
          onConfirm: onConfirm,
          cancelButtonText: cancelButtonText,
          onCancel: onCancel,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          ),
        );
      },
    );

    return result ?? false;
  }

  /// Convenience method for creating a delete confirmation
  static Future<bool> showDelete({
    required BuildContext context,
    required String itemName,
    String? message,
    required VoidCallback onConfirm,
    Color accentColor = Colors.red,
  }) {
    return show(
      context: context,
      actionType: 'Delete',
      itemName: itemName,
      message: message ?? 'Are you sure you want to delete this $itemName? This action cannot be undone.',
      icon: Icons.delete_outline_rounded,
      accentColor: accentColor,
      isDestructive: true,
      confirmButtonText: 'Delete',
      onConfirm: onConfirm,
    );
  }

  /// Convenience method for creating a logout confirmation
  static Future<bool> showLogout({
    required BuildContext context,
    required VoidCallback onConfirm,
    String? message,
    Color accentColor = Colors.blue,
  }) {
    return show(
      context: context,
      actionType: 'Logout',
      message: message ?? 'Are you sure you want to log out? You will need to sign in again next time.',
      icon: Icons.logout_rounded,
      accentColor: accentColor,
      confirmButtonText: 'Logout',
      onConfirm: onConfirm,
    );
  }

  /// Convenience method for creating a reset confirmation
  static Future<bool> showReset({
    required BuildContext context,
    required String itemName,
    String? message,
    required VoidCallback onConfirm,
    Color accentColor = Colors.orange,
  }) {
    return show(
      context: context,
      actionType: 'Reset',
      itemName: itemName,
      message: message ?? 'Are you sure you want to reset $itemName to default settings?',
      icon: Icons.restart_alt_rounded,
      accentColor: accentColor,
      confirmButtonText: 'Reset',
      onConfirm: onConfirm,
    );
  }

  /// Convenience method for creating a discard confirmation
  static Future<bool> showDiscard({
    required BuildContext context,
    required String itemName,
    String? message,
    required VoidCallback onConfirm,
    Color accentColor = Colors.amber,
  }) {
    return show(
      context: context,
      actionType: 'Discard',
      itemName: itemName,
      message: message ?? 'Are you sure you want to discard this $itemName? Your changes will be lost.',
      icon: Icons.delete_sweep_rounded,
      accentColor: accentColor,
      isDestructive: true,
      confirmButtonText: 'Discard',
      onConfirm: onConfirm,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String title = itemName != null ? '$actionType $itemName?' : '$actionType?';

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 16,
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with accent color and icon
                Container(
                  color: accentColor.withOpacity(0.1),
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 48,
                      color: accentColor,
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Title
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      // Message
                      Text(
                        message,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // Action buttons
                      Row(
                        children: [
                          // Cancel button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                if (onCancel != null) onCancel!();
                                Navigator.of(context).pop(false);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: theme.textTheme.bodyLarge?.color,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(
                                  color: theme.dividerColor,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(cancelButtonText),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Confirm button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                onConfirm();
                                Navigator.of(context).pop(true);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(confirmButtonText),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Example usage:
void examples(BuildContext context) {
  // 1. Delete notification example
  ActionConfirmationDialog.showDelete(
    context: context,
    itemName: 'Notification',
    onConfirm: () {
      // Handle deletion logic
    },
  );

  // 2. Logout example
  ActionConfirmationDialog.showLogout(
    context: context,
    onConfirm: () {
      // Handle logout logic
    },
  );

  // 3. Reset settings example
  ActionConfirmationDialog.showReset(
    context: context,
    itemName: 'Settings',
    onConfirm: () {
      // Handle settings reset
    },
  );

  // 4. Discard changes example
  ActionConfirmationDialog.showDiscard(
    context: context,
    itemName: 'Draft',
    onConfirm: () {
      // Handle discard logic
    },
  );

  // 5. Custom action example
  ActionConfirmationDialog.show(
    context: context,
    actionType: 'Archive',
    itemName: 'Project',
    icon: Icons.archive_outlined,
    accentColor: Colors.teal,
    message: 'This project will be moved to archives and won\'t appear in your active projects.',
    confirmButtonText: 'Archive',
    onConfirm: () {
      // Handle archive logic
    },
  );
}