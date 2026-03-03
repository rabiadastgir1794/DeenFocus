enum SubscriptionPlan {
  monthly('Monthly', 'Billed monthly'),
  yearly('Yearly', 'Most Popular', isPopular: true),
  lifetime('Lifetime', 'One-time');

  const SubscriptionPlan(this.label, this.subtitle, {this.isPopular = false});
  final String label;
  final String subtitle;
  final bool isPopular;
}
