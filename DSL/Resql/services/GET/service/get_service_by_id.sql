/*
declaration:
  version: 0.1
  description: "Retrieve the latest non-deleted service configuration by service_id, including both common and specific endpoints"
  method: get
  namespace: service
  returns: json
  allowlist:
    query:
      - field: id
        type: string
        description: "Service identifier used to fetch the latest version of a service"
  response:
    fields:
      - field: id
        type: string
        description: "Unique identifier of the service record"
      - field: name
        type: string
        description: "Name of the service"
      - field: description
        type: string
        description: "Service description"
      - field: slot
        type: string
        description: "Slot type of the service"
      - field: state
        type: string
        enum: ['active', 'inactive', 'draft', 'ready']
        description: "Current state of the service"
      - field: type
        type: string
        enum: ['GET', 'POST']
        description: "Ruuter type associated with the service"
      - field: is_common
        type: boolean
        description: "Indicates whether the service is common"
      - field: structure
        type: object
        description: "JSON structure defining the service"
      - field: service_id
        type: string
        description: "Identifier linking this service to its group"
*/
WITH MaxService AS (
  SELECT MAX(id) AS maxId
  FROM services
  WHERE service_id = :id
  LIMIT 1
)
SELECT
  id,
  name,
  description,
  slot,
  current_state AS state,
  ruuter_type AS type,
  is_common,
  structure::json,
  service_id
FROM services
JOIN MaxService ON id = maxId
WHERE NOT deleted
ORDER BY id ASC;
