# Histogram Endpoints

Several record types in InvenioILS expose a `/stats` endpoint for flexible aggregation queries. These endpoints provide real-time aggregation of records from their respective indices, allowing flexible grouping by any field and computation of statistical metrics on numeric fields.

Each response returns the count for the records matching the filter and grouping criteria under the field `doc_count` and the requested aggregated metrics.

## Available Endpoints

| Endpoint                         | Description                     |
| -------------------------------- | ------------------------------- |
| `/api/circulation/loans/stats`   | Loan aggregations               |
| `/api/acquisition/stats`         | Purchase order aggregations     |
| `/api/document-requests/stats`   | Literature request aggregations |

## Parameters

| Name       | Type       | Location | Required | Description                                                                                                                                                                   |
| ---------- | ---------- | -------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `group_by` | JSON array | query    | ✓        | Array of grouping definitions. Each item is an object with `field` (required) and `interval` (required for date fields). See [format details below](#group_by-field-format). |
| `metrics`  | JSON array | query    | ✗        | Array of metric definitions. Each item is an object with `field` (required) and `aggregation` (required). See [format details below](#metrics-field-format).                  |
| `q`        | string     | query    | ✗        | Search query string for filtering records (uses standard search syntax).                                                                                                      |

### `group_by` Field Format

Each grouping object can be:

- **Term field**: `{"field": "field_name"}` - Groups by exact values (e.g., `state`, `patron_pid`)
- **Date field**: `{"field": "date_field", "interval": "time_interval"}` - Groups by time intervals
    - Available intervals for date fields: `1d` (day), `1w` (week), `1M` (month), `1q` (quarter), `1y` (year)

### `metrics` Field Format

Each metrics object is:

- `{"field": "field_name", "aggregation": "aggregation_type"}`
    - Available aggregation types: `avg` (average), `sum` (total), `min` (minimum), `max` (maximum), `median` (50th percentile)

## Example

Group by month with an average metric:

```shell
curl --get \
  --url 'https://127.0.0.1:5000/api/circulation/loans/stats' \
  --data-urlencode 'group_by=[{"field":"start_date","interval":"1M"}]' \
  --data-urlencode 'metrics=[{"field":"extension_count","aggregation":"avg"}]' \
  --header 'content-type: application/json' \
  --header 'authorization: Bearer <auth token>'
```
