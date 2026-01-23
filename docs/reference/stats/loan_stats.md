# Loan Statistics

InvenioILS provides two complementary endpoints for analyzing loan data:

1. **Loan Histogram**: A flexible aggregation endpoint for analyzing the current state of loans with custom grouping and metrics
2. **Loan Transitions**: An event-based tracking system for monitoring the number of loan state changes


## Loan Histogram

See [Histogram Endpoints](histogram.md) for general parameter documentation.

```
GET /api/circulation/loans/stats
```

### Stats Fields

The following fields are added to loans specifically for statistics. They require [`ILS_EXTEND_INDICES_WITH_STATS_ENABLED`](../../customize/configure.md#ils_extend_indices_with_stats_enabled-truefalse) to be enabled.

| Field                                            | Description                                                     |
| ------------------------------------------------ | --------------------------------------------------------------- |
| `extra_data.stats.available_items_during_request` | Whether loanable items were available when the loan was requested. |
| `extra_data.stats.loan_duration`                  | Duration of the loan in days (for completed loans).             |
| `extra_data.stats.waiting_time`                   | Days between request creation and checkout.                     |

### Examples

#### Group by loan state

```shell
curl --get \
  --url 'https://127.0.0.1:5000/api/circulation/loans/stats' \
  --data-urlencode 'group_by=[{"field":"state"}]' \
  --header 'content-type: application/json' \
  --header 'authorization: Bearer <auth token>'
```

#### Group by month with average extension count

```shell
curl --get \
  --url 'https://127.0.0.1:5000/api/circulation/loans/stats' \
  --data-urlencode 'group_by=[{"field":"start_date","interval":"1M"}]' \
  --data-urlencode 'metrics=[{"field":"extension_count","aggregation":"avg"}]' \
  --header 'content-type: application/json' \
  --header 'authorization: Bearer <auth token>'
```

#### Multiple grouping fields

```shell
curl --get \
  --url 'https://127.0.0.1:5000/api/circulation/loans/stats' \
  --data-urlencode 'group_by=[{"field":"state"},{"field":"start_date","interval":"1M"}]' \
  --header 'content-type: application/json' \
  --header 'authorization: Bearer <auth token>'
```

#### Grouping by document availability during request and query filtering

```shell
curl --get \
  --url 'https://127.0.0.1:5000/api/circulation/loans/stats' \
  --data-urlencode 'group_by=[{"field":"extra_data.stats.available_items_during_request"}]' \
  --data-urlencode 'q=request_start_date:[2025-01-01 TO 2025-12-31]' \
  --header 'content-type: application/json' \
  --header 'authorization: Bearer <auth token>'
```

---

## Loan Transitions

The Loan Transitions statistics track loan state change events over time using the invenio-stats package. 
Each time a loan transitions to a new state (e.g., checkout, extend, return), an event is recorded with a timestamp and trigger type.


### Endpoint

```
POST /api/stats
```

### Parameters

The request body should contain a named query with the `loan-transitions` stat type.

| Name         | Type   | Location | Required | Description                                                                            |
| ------------ | ------ | -------- | -------- | -------------------------------------------------------------------------------------- |
| `trigger`    | string | body     | ✓        | The transition type to filter on. See [available triggers](#available-triggers) below. |
| `interval`   | string | body     | ✓        | Aggregation interval. One of `year`, `quarter`, `month`, `week`, `day`.                |
| `start_date` | string | body     | ✗        | Beginning of the date range (`YYYY-MM-DD`).                                            |
| `end_date`   | string | body     | ✗        | End of the date range (`YYYY-MM-DD`).                                                  |

### Available Triggers

The following transition triggers are implemented in InvenioILS:

| Trigger    | Description      |
| ---------- | ---------------- |
| `request`  | Loan requested   |
| `checkout` | Item checked out |
| `extend`   | Loan extended    |
| `cancel`   | Loan cancelled   |

!!! note "Custom transition types"
    Other systems or extensions may add additional transition types. The available triggers are determined by your circulation configuration. E.g. [cds-ils](https://github.com/CERNDocumentServer/cds-ils) adds the `self-checkout` and `checkin` transition

### Example

Track loan extensions by month in 2025:

```shell
curl --request POST \
  --url https://127.0.0.1:5000/api/stats \
  --header 'content-type: application/json' \
  --header 'authorization: Bearer <auth token>' \
  --data '{
  "loan_extensions_2025": {
    "stat": "loan-transitions",
    "params": {
      "trigger": "extend",
      "start_date": "2025-01-01",
      "end_date": "2025-12-31",
      "interval": "month"
    }
  }
}'
```


