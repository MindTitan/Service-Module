/*
declaration:
  version: 0.1
  description: "Insert a deleted copy of the latest version of an endpoint, preserving its metadata"
  method: post
  namespace: endpoint
  returns: json
  accepts: json
  allowlist:
    body:
      - field: id
        type: string
        description: "UUID of the endpoint to be soft-deleted by duplicating and marking as deleted"
  response:
    fields: []
*/
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
FROM endpoints
WHERE endpoint_id = :id::uuid
ORDER BY id DESC
LIMIT 1;