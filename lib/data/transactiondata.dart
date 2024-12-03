class TransactionData {
  
  final String type; //type means income or expense
  final DateTime date; 
  final String source; 
  final String amount; 
  

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
    date: DateTime(2024,11,10),
    source: 'food',
    amount: '100',
  ),
  TransactionData(
   type: 'income',
    date: DateTime(2024,11,10),
    source: 'clothes',
    amount: '200',
  ),
  TransactionData(
   type: 'expense',
    date: DateTime(2024,11,10),
    source: 'food',
    amount: '100',
  ),
  TransactionData(
   type: 'income',
    date: DateTime(2024,11,10),
    source: 'clothes',
    amount: '200',
  ),
  TransactionData(
   type: 'expense',
    date: DateTime(2024,11,10),
    source: 'food',
    amount: '100',
  ),
  
];