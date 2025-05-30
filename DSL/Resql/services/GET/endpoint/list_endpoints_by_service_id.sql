/*
declaration:
  version: 0.1
  description: "Fetch the latest version of each non-deleted endpoint associated with a given service ID or marked as common"
  method: get
  namespace: endpoint
  returns: json
  allowlist:
    query:
      - field: id
        type: string
        description: "Service ID used to filter endpoints (matched via service_ids or is_common)"
  response:
    fields:
      - field: endpoint_id
        type: string
        description: "UUID of the endpoint"
      - field: name
        type: string
        description: "Name of the endpoint"
      - field: type
        type: string
        enum: ['openApi', 'custom']
        description: "Type or category of the endpoint"
      - field: file_name
        type: string
        description: "Name of the file associated with the endpoint"
      - field: is_common
        type: boolean
        description: "Indicates if the endpoint is marked as common (shared across services)"
      - field: definitions
        type: object
        description: "JSON structure of the endpoint definitions"
*/
WITH LatestEndpoints AS (
  SELECT DISTINCT ON (e.endpoint_id) e.*
  FROM endpoints AS e
  WHERE (e.service_ids @> ARRAY[:id]::uuid[] OR e.is_common = true)
  ORDER BY e.endpoint_id, e.id DESC
)
SELECT
  endpoint_id,
  name,
  type,
  file_name,
  is_common,
  definitions
FROM LatestEndpoints
WHERE deleted IS FALSE
ORDER BY id DESC;
