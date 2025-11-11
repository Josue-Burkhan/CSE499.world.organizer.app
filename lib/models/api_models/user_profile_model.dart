class UserProfile {
  final AccountData accountData;
  final List<WorldSummary> worlds;

  UserProfile({required this.accountData, required this.worlds});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    var worldsList = json['worlds'] as List;
    List<WorldSummary> worlds = worldsList.map((i) => WorldSummary.fromJson(i)).toList();
    return UserProfile(
      accountData: AccountData.fromJson(json['accountData']),
      worlds: worlds,
    );
  }
}

class AccountData {
  final String userId;
  final String email;
  final String accountFirstname;
  final String? accountPlan;
  final String? accountPlanType;
  final DateTime? accountPlanExpiresAt;
  final DateTime? accountPlanCycleStartedAt;
  final String? accountScheduledPlan;
  final bool? accountAutoRenew;
  final String? lang;
  final String? picture;
  final String? description; // Added description field

  AccountData({
    required this.userId,
    required this.email,
    required this.accountFirstname,
    this.accountPlan,
    this.accountPlanType,
    this.accountPlanExpiresAt,
    this.accountPlanCycleStartedAt,
    this.accountScheduledPlan,
    this.accountAutoRenew,
    this.lang,
    this.picture,
    this.description, // Added description to constructor
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
      userId: json['userId'],
      email: json['email'],
      accountFirstname: json['account_firstname'],
      accountPlan: json['account_plan'],
      accountPlanType: json['account_plan_type'],
      accountPlanExpiresAt: json['account_plan_expires_at'] != null ? DateTime.parse(json['account_plan_expires_at']) : null,
      accountPlanCycleStartedAt: json['account_plan_cycle_started_at'] != null ? DateTime.parse(json['account_plan_cycle_started_at']) : null,
      accountScheduledPlan: json['account_scheduled_plan'],
      accountAutoRenew: json['account_auto_renew'],
      lang: json['lang'],
      picture: json['picture'],
      description: json['description'], // Added description to fromJson
    );
  }
}

class WorldSummary {
  final String id;
  final String name;

  WorldSummary({required this.id, required this.name});

  factory WorldSummary.fromJson(Map<String, dynamic> json) {
    return WorldSummary(
      id: json['_id'],
      name: json['name'],
    );
  }
}
