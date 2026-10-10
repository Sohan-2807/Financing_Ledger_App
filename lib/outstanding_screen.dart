import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'finance_provider.dart';
import 'customer_loan_modules.dart';

class OutstandingScreen extends StatelessWidget {
  const OutstandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF070B14),
        title: const Text('Outstanding Loans', style: TextStyle(color: Color(0xFFEDF2FF))),
        iconTheme: const IconThemeData(color: Color(0xFF00E5A0)),
      ),
      body: Consumer<FinanceProvider>(builder: (ctx, fp, _) {
        final activeLoans = fp.loans.where((l) => l.status == 'Active').toList();
        final Map<String, List<Loan>> grouped = {};
        for (var l in activeLoans) {
          grouped.putIfAbsent(l.customerId, () => []).add(l);
        }

        if (grouped.isEmpty) {
          return const Center(
            child: Text('No outstanding loans found.', style: TextStyle(color: Color(0xFF7B8FAD))),
          );
        }

        final customerIds = grouped.keys.toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: customerIds.length,
          itemBuilder: (ctx, i) {
            final customerId = customerIds[i];
            final customer = fp.customerById(customerId);
            final customerLoans = grouped[customerId]!;

            // 👈 FIX: Changed remainingAmount to outstandingBalance
            final totalOutstanding = customerLoans.fold(0.0, (sum, l) => sum + l.outstandingBalance);

            return Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Card(
                color: const Color(0xFF141E2E),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ExpansionTile(
                  iconColor: const Color(0xFF00E5A0),
                  collapsedIconColor: const Color(0xFF7B8FAD),
                  title: Text(
                    customer?.fullName ?? 'Unknown Customer',
                    style: const TextStyle(color: Color(0xFFEDF2FF), fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    'Total Outstanding: ₹${totalOutstanding.toStringAsFixed(0)}',
                    style: const TextStyle(color: Color(0xFFFF6B6B), fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  children: customerLoans.map((loan) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: const Color(0xFF243050).withOpacity(0.5))),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 👈 FIX: Changed startDate to loanDate, and principalAmount to amountGiven
                              Text('Given: ${loan.loanDate}', style: const TextStyle(color: Color(0xFF7B8FAD), fontSize: 12)),
                              Text('Principal: ₹${loan.amountGiven.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF7B8FAD), fontSize: 12)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Remaining', style: TextStyle(color: Color(0xFF7B8FAD), fontSize: 10)),
                              Text('₹${loan.outstandingBalance.toStringAsFixed(0)}',
                                  style: const TextStyle(color: Color(0xFFFF6B6B), fontWeight: FontWeight.w700, fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}