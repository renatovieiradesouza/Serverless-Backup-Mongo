#!/bin/bash

#####
#Author: Renato Souza - Condo Livre
#####

# BUCKET_S3=${1}
# NAME_FUNCTION=${2}
# DESCRIPTION=${3}
# LOG_GROUP=${4} 
# ENV=${5}

# echo '
# ###################### Functionbeat Configuration Example #######################

# # This file is an example configuration file highlighting only the most common
# # options. The functionbeat.reference.yml file from the same directory contains all the
# # supported options with more comments. You can use it as a reference.
# #
# # You can find the full configuration reference here:
# # https://www.elastic.co/guide/en/beats/functionbeat/index.html
# #

# # ================================== Provider ==================================
# # Configure functions to run on AWS Lambda, currently we assume that the credentials
# # are present in the environment to correctly create the function when using the CLI.
# #
# # Configure which S3 endpoint should we use.
# functionbeat.provider.aws.endpoint: "s3.amazonaws.com"
# # Configure which S3 bucket we should upload the lambda artifact.
# functionbeat.provider.aws.deploy_bucket: '$BUCKET_S3'

# functionbeat.provider.aws.functions:
#   # Define the list of function availables, each function required to have a unique name.
#   # Create a function that accepts events coming from cloudwatchlogs.
#   - name: '$NAME_FUNCTION'
#     enabled: true
#     type: cloudwatch_logs

#     # Description of the method to help identify them when you run multiples functions.
#     description: '$DESCRIPTION'

#     # Concurrency, is the reserved number of instances for that function.
#     # Default is 5.
#     #
#     # Note: There is a hard limit of 1000 functions of any kind per account.
#     #concurrency: 5

#     # The maximum memory allocated for this function, the configured size must be a factor of 64.
#     # There is a hard limit of 3008MiB for each function. Default is 128MiB.
#     memory_size: 128MiB

#     # Dead letter queue configuration, this must be set to an ARN pointing to a SQS queue.
#     #dead_letter_config.target_arn:

#     # Execution role of the function.
#     #role: arn:aws:iam::123456789012:role/MyFunction

#     # Connect to private resources in an Amazon VPC.
#     #virtual_private_cloud:
#     #  security_group_ids: []
#     #  subnet_ids: []

#     # Optional fields that you can specify to add additional information to the
#     # output. Fields can be scalar values, arrays, dictionaries, or any nested
#     # combination of these.
#     fields:
#       env: '$ENV'

#     # List of cloudwatch log group registered to that function.
#     triggers:
#       - log_group_name: '$LOG_GROUP'

#     # Define custom processors for this function.
#     #processors:
#     #  - dissect:
#     #      tokenizer: "%{key1} %{key2}"

  
# # ================================== General ===================================

# # The name of the shipper that publishes the network data. It can be used to group
# # all the transactions sent by a single shipper in the web interface.
# #name:

# # The tags of the shipper are included in their own field with each
# # transaction published.
# #tags: ["service-X", "web-tier"]

# # Optional fields that you can specify to add additional information to the
# # output.
# #fields:
# #  env: staging

# # ================================= Dashboards =================================
# # These settings control loading the sample dashboards to the Kibana index. Loading
# # the dashboards is disabled by default and can be enabled either by setting the
# # options here or by using the `setup` command.
# #setup.dashboards.enabled: true

# # The directory from where to read the dashboards. The default is the `kibana`
# # folder in the home path.
# #setup.dashboards.directory: ${path.home}/kibana

# # In case the archive contains the dashboards from multiple Beats, this lets you
# # select which one to load. You can load all the dashboards in the archive by
# # setting this to the empty string.
# #setup.dashboards.beat: ""

# # The name of the Kibana index to use for setting the configuration. Default is ".kibana"
# #setup.dashboards.kibana_index: .kibana

# # If true and Kibana is not reachable at the time when dashboards are loaded,
# # it will retry to reconnect to Kibana instead of exiting with an error.
# #setup.dashboards.retry.enabled: true

# # Duration interval between Kibana connection retries.
# #setup.dashboards.retry.interval: 5s

# # Maximum number of retries before exiting with an error, 0 for unlimited retrying.
# #setup.dashboards.retry.maximum: 3

# # The URL from where to download the dashboards archive. By default this URL
# # has a value which is computed based on the Beat name and version. For released
# # versions, this URL points to the dashboard archive on the artifacts.elastic.co
# # website.
# #setup.dashboards.url:

# # ================================== Template ==================================

# # A template is used to set the mapping in Elasticsearch
# # By default template loading is enabled and the template is loaded.
# # These settings can be adjusted to load your own template or overwrite existing ones.

# # Set to false to disable template loading.
# #setup.template.enabled: true

# # Template name. By default the template name is "functionbeat-%{[agent.version]}"
# # The template name and pattern has to be set in case the Elasticsearch index pattern is modified.
# setup.template.name: "development-%{[agent.version]}"

# # Template pattern. By default the template pattern is "functionbeat-%{[agent.version]}" to apply to the default index settings.
# # The template name and pattern has to be set in case the Elasticsearch index pattern is modified.
# setup.template.pattern: "development-%{[agent.version]}"

# # Path to fields.yml file to generate the template
# #setup.template.fields: "${path.config}/fields.yml"

# # A list of fields to be added to the template and Kibana index pattern. Also
# # specify setup.template.overwrite: true to overwrite the existing template.
# #setup.template.append_fields:
# #- name: field_name
# #  type: field_type

# # Enable JSON template loading. If this is enabled, the fields.yml is ignored.
# #setup.template.json.enabled: false

# # Path to the JSON template file
# #setup.template.json.path: "${path.config}/template.json"

# # Name under which the template is stored in Elasticsearch
# #setup.template.json.name: ""

# # Set this option if the JSON template is a data stream.
# #setup.template.json.data_stream: false

# # Overwrite existing template
# # Do not enable this option for more than one instance of functionbeat as it might
# # overload your Elasticsearch with too many update requests.
# #setup.template.overwrite: false

# # Elasticsearch template settings
# setup.template.settings:

#   # A dictionary of settings to place into the settings.index dictionary
#   # of the Elasticsearch template. For more details, please check
#   # https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping.html
#   #index:
#     #number_of_shards: 1
#     #codec: best_compression

#   # A dictionary of settings for the _source field. For more details, please check
#   # https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-source-field.html
#   #_source:
#     #enabled: false


# # =================================== Kibana ===================================

# # Starting with Beats version 6.0.0, the dashboards are loaded via the Kibana API.
# # This requires a Kibana endpoint configuration.
# setup.kibana:

#   # Kibana Host
#   # Scheme and port can be left out and will be set to the default (http and 5601)
#   # In case you specify and additional path, the scheme is required: http://localhost:5601/path
#   # IPv6 addresses should always be defined as: https://[2001:db8::1]:5601
#   #host: "localhost:5601"

#   # Kibana Space ID
#   # ID of the Kibana Space into which the dashboards should be loaded. By default,
#   # the Default Space will be used.
#   #space.id:

# # =============================== Elastic Cloud ================================

# # These settings simplify using Functionbeat with the Elastic Cloud (https://cloud.elastic.co/).

# # The cloud.id setting overwrites the `output.elasticsearch.hosts` and
# # `setup.kibana.host` options.
# # You can find the `cloud.id` in the Elastic Cloud web UI.
# cloud.id: "AWS_CondoLivre:dXMtZWFzdC0xLmF3cy5mb3VuZC5pbyRmZjBmNDBlNTVmMzY0MWYwYWI2NTg5ODNmN2E4ODllNCRlZmE5NDQ1NWZlZmI0YWIxYWYzOGQ4ZmQ5MDFkOTY3Yw=="
# # The cloud.auth setting overwrites the `output.elasticsearch.username` and
# # `output.elasticsearch.password` settings. The format is `<user>:<pass>`.
# cloud.auth: "elastic:WadYwT1zCJFo4VCuzJfUHCQq"

# # ================================== Outputs ===================================

# # Configure what output to use when sending the data collected by the beat.

# # ---------------------------- Elasticsearch Output ----------------------------
# output.elasticsearch:
#   # Array of hosts to connect to.
#   hosts: ["localhost:9200"]

#   # Protocol - either `http` (default) or `https`.
#   #protocol: "https"

#   # Authentication credentials - either API key or username/password.
#   #api_key: "id:api_key"
#   #username: "elastic"
#   #password: "changeme"

#   index: "development-%{[agent.version]}"

# # ------------------------------ Logstash Output -------------------------------
# #output.logstash:
#   # The Logstash hosts
#   #hosts: ["localhost:5044"]

#   # Optional SSL. By default is off.
#   # List of root certificates for HTTPS server verifications
#   #ssl.certificate_authorities: ["/etc/pki/root/ca.pem"]

#   # Certificate for SSL client authentication
#   #ssl.certificate: "/etc/pki/client/cert.pem"

#   # Client Certificate Key
#   #ssl.key: "/etc/pki/client/cert.key"

# # ================================= Processors =================================

# # Configure processors to enhance or manipulate events generated by the beat.

# processors:
#   - add_host_metadata: ~
#   - add_cloud_metadata: ~


# # ================================== Logging ===================================

# # Sets log level. The default log level is info.
# # Available log levels are: error, warning, info, debug
# #logging.level: debug

# # At debug level, you can selectively enable logging only for some components.
# # To enable all selectors use ["*"]. Examples of other selectors are "beat",
# # "publisher", "service".
# #logging.selectors: ["*"]

# # ============================= X-Pack Monitoring ==============================
# # Functionbeat can export internal metrics to a central Elasticsearch monitoring
# # cluster.  This requires xpack monitoring to be enabled in Elasticsearch.  The
# # reporting is disabled by default.

# # Set to true to enable the monitoring reporter.
# #monitoring.enabled: false

# # Sets the UUID of the Elasticsearch cluster under which monitoring data for this
# # Functionbeat instance will appear in the Stack Monitoring UI. If output.elasticsearch
# # is enabled, the UUID is derived from the Elasticsearch cluster referenced by output.elasticsearch.
# #monitoring.cluster_uuid:

# # Uncomment to send the metrics to Elasticsearch. Most settings from the
# # Elasticsearch output are accepted here as well.
# # Note that the settings should point to your Elasticsearch *monitoring* cluster.
# # Any setting that is not set is automatically inherited from the Elasticsearch
# # output configuration, so if you have the Elasticsearch output configured such
# # that it is pointing to your Elasticsearch monitoring cluster, you can simply
# # uncomment the following line.
# #monitoring.elasticsearch:

# # ============================== Instrumentation ===============================

# # Instrumentation support for the functionbeat.
# #instrumentation:
#     # Set to true to enable instrumentation of functionbeat.
#     #enabled: false

#     # Environment in which functionbeat is running on (eg: staging, production, etc.)
#     #environment: ""

#     # APM Server hosts to report instrumentation results to.
#     #hosts:
#     #  - http://localhost:8200

#     # API Key for the APM Server(s).
#     # If api_key is set then secret_token will be ignored.
#     #api_key:

#     # Secret token for the APM Server(s).
#     #secret_token:


# # ================================= Migration ==================================

# # This allows to enable 6.7 migration aliases
# #migration.6_to_7.enabled: true'

