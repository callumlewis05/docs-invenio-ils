# Document Request Statistics

See [Histogram Endpoints](histogram.md) for general parameter documentation.

```
GET /api/document-requests/stats
```

## Stats Fields

The following fields are added to document requests specifically for statistics. They require [`ILS_EXTEND_INDICES_WITH_STATS_ENABLED`](../../customize/configure.md#ils_extend_indices_with_stats_enabled-truefalse) to be enabled.

| Field                           | Description                                                                          |
| ------------------------------- | ------------------------------------------------------------------------------------ |
| `stats.provider_creation_delay` | Days between document request creation and associated order/borrowing request creation. |

## Example

Average time to create purchase order or borrowing request:

```shell
curl --get \
  --url 'https://127.0.0.1:5000/api/document-requests/stats' \
  --data-urlencode 'group_by=[{"field":"_created","interval":"1M"}]' \
  --data-urlencode 'metrics=[{"field":"stats.provider_creation_delay","aggregation":"avg"}]' \
  --header 'authorization: Bearer <auth token>'
```
