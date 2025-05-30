/*
declaration:
  version: 0.1
  description: "Retrieve the latest non-deleted name and ID for a list of specified service IDs"
  method: get
  namespace: service
  returns: json
  allowlist:
    query:
      - field: serviceIds
        type: string
        description: "Comma-separated list of service IDs to look up"
  response:
    fields:
      - field: name
        type: string
        description: "Name of the latest non-deleted version of the service"
      - field: service_id
        type: string
        description: "Service identifier"
*/
WITH latest_services AS (
  SELECT DISTINCT ON (service_id) id, name, service_id
  FROM services
  WHERE service_id = ANY(string_to_array(:serviceIds, ','))
    AND deleted IS FALSE
  ORDER BY service_id, id DESC
)
SELECT name, service_id
FROM latest_services;
