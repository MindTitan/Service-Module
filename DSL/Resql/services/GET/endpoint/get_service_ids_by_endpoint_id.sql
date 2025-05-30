/*
declaration:
  version: 0.1
  description: "Fetch the most recent non-deleted list of service IDs associated with a specific endpoint"
  method: get
  namespace: endpoint
  returns: json
  allowlist:
    query:
      - field: endpointId
        type: string
        description: "UUID of the endpoint to retrieve associated service IDs for"
  response:
    fields:
      - field: service_ids
        type: array
        items:
          type: string
        description: "Array of service IDs linked to the specified endpoint"
*/
SELECT service_ids
FROM endpoints
WHERE endpoint_id = :endpointId::uuid
  AND deleted IS FALSE
ORDER BY id DESC
LIMIT 1;