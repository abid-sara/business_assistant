class TransactionData {
  
  final String type; //type means income or expense
  final DateTime date; 
  final String source; 
  final double amount; 
  

 TransactionData(
  {
    required this.type,
    required this.date,
    required this.source,
    required this.amount,
    
  }
 );
  
}
List <TransactionData> Transactionlist = [
  TransactionData(
   type: 'expense',
    date: DateTime(2024,12,10),
    source: 'buying',
    amount: 10000.00,
  ),
   TransactionData(
   type: 'expense',
    date: DateTime(2024,12,11),
    source: 'buying',
    amount: 10000.00,
  ),
   TransactionData(
   type: 'expense',
    date: DateTime(2024,12,12),
    source: 'buying',
    amount: 10000.00,
  ),
   TransactionData(
   type: 'expense',
    date: DateTime(2024,12,13),
    source: 'buying',
    amount: 10000.00,
  ),
   TransactionData(
   type: 'expense',
    date: DateTime(2024,12,14),
    source: 'buying',
    amount: 10000.00,
  ),
   TransactionData(
   type: 'expense',
    date: DateTime(2024,12,15),
    source: 'buying',
    amount: 10000.00,
  ),

  TransactionData(
   type: 'income',
    date: DateTime(2024,12,10),
    source: 'Order',
    amount: 20000.00,
  ),

  TransactionData(
   type: 'expense',
    date: DateTime(2024,11,16),
    source: 'shopping',
    amount: 59000.00,
  ),
  TransactionData(
   type: 'income',
    date: DateTime(2024,11,12),
    source: 'Order',
    amount: 30000.00,
  ),
  TransactionData(
   type: 'income',
    date: DateTime(2024,11,1112),
    source: 'Order',
    amount: 30000.00,
  ),
  TransactionData(
   type: 'income',
    date: DateTime(2024,11,12),
    source: 'Order',
    amount: 30000.00,
  ),
  TransactionData(
   type: 'expense',
    date: DateTime(2024,11,17),
    source: 'shopping',
    amount: 36000.00,
  ),
  TransactionData(
   type: 'income',
    date: DateTime(2024,11,13),
    source: 'Order',
    amount: 30000.00,
  ),
  TransactionData(
   type: 'income',
    date: DateTime(2024,11,14),
    source: 'Order',
    amount: 30000.00,
  ),
  TransactionData(
   type: 'income',
    date: DateTime(2024,11,15),
    source: 'Order',
    amount: 78000.00,
  ),
  TransactionData(
   type: 'income',
    date: DateTime(2024,11,16),
    source: 'Order',
    amount:65000.00,
  ),
  
];