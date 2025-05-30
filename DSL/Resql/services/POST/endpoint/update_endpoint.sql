/*
declaration:
  version: 0.1
  description: "Insert a new version of an endpoint, appending a service ID to the existing service list if present"
  method: post
  namespace: auth_users
  returns: json
  allowlist:
    query:
      - field: endpointId
        type: string
        description: "UUID of the endpoint to extend"
      - field: serviceId
        type: string
        description: "Service ID to add to the endpoint's service_ids list"
      - field: name
        type: string
        description: "Name of the endpoint"
      - field: type
        type: string
        enum: ['openApi', 'custom']
        description: "Type of the endpoint"
      - field: fileName
        type: string
        description: "Name of the file associated with the endpoint"
      - field: isCommon
        type: boolean
        description: "Indicates if the endpoint is marked as common"
      - field: definitions
        type: object
        description: "JSONB object containing the endpoint's definition"
  response:
    fields: []
*/
WITH existing AS (
  SELECT service_ids FROM endpoints WHERE endpoint_id = :endpointId::uuid ORDER BY created_at DESC LIMIT 1
)
INSERT INTO endpoints (endpoint_id, service_ids, name, type, file_name, is_common, definitions)
VALUES (
  :endpointId::uuid,
  (
    SELECT
      CASE
        WHEN existing.service_ids IS NOT NULL
        THEN (
          SELECT ARRAY(
            SELECT DISTINCT unnest(existing.service_ids || :serviceId::uuid)
          )
        )
        ELSE ARRAY[:serviceId::uuid]
      END
    FROM existing
  ),
  :name,
  :type::endpoint_type,
  :fileName,
  :isCommon,
  :definitions::jsonb
);