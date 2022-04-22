-- We want to be notified of errors that happen in our processing pipeline in order for us to do something about it.
-- For this, ksqlDB has the ksql processing log that can be parsed to be notified of errors.

-- We set to earliest to get all previous errors if they exist

SET 'auto.offset.reset' = 'earliest';

-- We create a STREAM that will log all errors to their own individual topic.
-- From there, we can add event-driven automation for error remediation or intervention by humans
-- Note that the biggest work is being done by the WHERE clause: The processing log contains errors for all persistent queries
-- so it is important to filter by the query ID we are interested in.

CREATE STREAM ORDER_CACHE_ERRORS AS
SELECT
    logger AS query_id,
    encode(message->deserializationError->RECORDB64, 'base64', 'utf8') AS message,
    message->deserializationError->cause AS deserializationErrorCause,
    message->deserializationError->errorMessage AS deserializationErrorMessage,
    message->recordProcessingError->cause as recordProcessingErrorCause,
    message->recordProcessingError->record as recordProcessingErrorRecord,
    message->recordProcessingError->errorMessage as recordProcessingErrorErrorMessage,
    message->serializationError->cause as serializationErrorCause,
    message->serializationError->record as serializationErrorRecord,
    message->serializationError->errorMessage as serializationErrorErrorMessage,
    message->productionError->errorMessage as productionErrorErrorMessage,
    message->kafkaStreamsThreadError->cause as kafkaStreamsThreadErrorCause,
    message->kafkaStreamsThreadError->threadName as kafkaStreamsThreadErrorThreadName,
    message->kafkaStreamsThreadError->errorMessage as kafkaStreamsThreadErrorErrorMessage
  FROM KSQL_PROCESSING_LOG klog
  WHERE klog.logger like 'processing.CTAS_ORDERS_CACHE_CLEAN_167%'
  EMIT CHANGES;
