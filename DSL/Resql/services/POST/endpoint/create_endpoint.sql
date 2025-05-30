/*
declaration:
  version: 0.1
  description: "Create a new endpoint, optionally linking it to a specific service if not marked as common"
  method: post
  namespace: endpoint
  accepts: json
  returns: json
  allowlist:
    body:
      - field: endpointId
        type: string
        description: "Unique UUID for the endpoint"
      - field: serviceId
        type: string
        description: "Service ID to link the endpoint to (used only if isCommon is false)"
      - field: name
        type: string
        description: "Name of the endpoint"
      - field: type
        type: string
        enum: ['openApi', 'custom']
        description: "Type/category of the endpoint"
      - field: fileName
        type: string
        description: "File name associated with the endpoint"
      - field: isCommon
        type: boolean
        description: "Whether the endpoint is common across services"
      - field: definitions
        type: object
        description: "JSONB object defining the endpoint behavior or structure"
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
    definitions
)
VALUES (
    :endpointId::uuid,
    CASE
      -- Common endpoints are not linked to any services initially
      -- They are linked with services when endpoints are added to the flow structure 
      WHEN :isCommon IS TRUE THEN ARRAY[]::uuid[]
      ELSE ARRAY[:serviceId::uuid]
    END,
    :name,
    :type::endpoint_type,
    :fileName,
    :isCommon,
    :definitions::jsonb
); 