/*
declaration:
  version: 0.1
  description: "Soft-delete the latest version of all non-common endpoints linked to a given service"
  method: post
  namespace: endpoint
  returns: json
  accepts: json
  allowlist:
    body:
      - field: serviceId
        type: string
        description: "Service ID whose associated non-common endpoints should be soft-deleted"
  response:
    fields: []
*/

WITH latest_endpoints AS (
    SELECT DISTINCT ON (endpoint_id) *
    FROM endpoints
    WHERE
        service_ids @> ARRAY[:serviceId::uuid]
        AND is_common = FALSE
        AND deleted = FALSE
    ORDER BY endpoint_id, id DESC
)
INSERT INTO endpoints (
    endpoint_id,
    service_ids,
    name,
    type,
    file_name,
    is_common,
    definitions,
    deleted,
    created_at,
    updated_at
)
SELECT
    endpoint_id,
    service_ids,
    name,
    type,
    file_name,
    is_common,
    definitions,
    TRUE AS deleted,
    created_at,
    updated_at
FROM latest_endpoints;
