# Statistics Reference

InvenioILS exposes statistics through REST API endpoints for analyzing library operations.

Several record types (loans, acquisition orders, document requests) share a common [histogram endpoint](histogram.md) pattern for flexible aggregation queries.

## Available Statistics

- [Histogram Endpoints](histogram.md) - Flexible aggregation queries for loans, orders, and document requests
- [Loan Statistics](loan_stats.md) - Loan histogram aggregations and transition tracking
- [Acquisition Order Statistics](acquisition_orders.md) - Purchase order timing and workflow metrics
- [Document Request Statistics](document_requests.md) - Literature request fulfillment metrics
- [Record Changes](record_changes.md) - Track insertions, updates, and deletions per record type
