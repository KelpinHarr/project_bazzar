String formatCurrency(int amount) {
  return 'Rp${amount.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (Match match) => '${match[1]}.',
  )}';
}