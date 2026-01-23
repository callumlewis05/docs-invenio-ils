# Acquisition Order Statistics

See [Histogram Endpoints](histogram.md) for general parameter documentation.

```
GET /api/acquisition/stats
```

## Stats Fields

The following fields are added to acquisition orders specifically for statistics. They require [`ILS_EXTEND_INDICES_WITH_STATS_ENABLED`](../../customize/configure.md#ils_extend_indices_with_stats_enabled-truefalse) to be enabled.

| Field                                 | Description                                                               |
| ------------------------------------- | ------------------------------------------------------------------------- |
| `stats.document_request_waiting_time` | Days between related literature request creation and order received date. |
| `stats.order_processing_time`         | Days between order creation and received date.                            |

## Example

Average order processing time by month:

```shell
curl --get \
  --url 'https://127.0.0.1:5000/api/acquisition/stats' \
  --data-urlencode 'group_by=[{"field":"_created","interval":"1M"}]' \
  --data-urlencode 'metrics=[{"field":"stats.order_processing_time","aggregation":"avg"}]' \
  --header 'authorization: Bearer <auth token>'
```
