-- Our orders stream has added a new field called "extrafield_evolution" and we'd like our stream
-- to reflect this new field. The field was evolved with schema registry forward transitory guarantees, so the data is being produced 
-- with the new field, but this new field isn't being interpreted by our cache. 
-- Here, we update our cache to interpret the new field.

-- Recompute the schema

CREATE OR REPLACE TABLE ORDERS_CACHE (ORDER_ID_KEY VARCHAR PRIMARY KEY) WITH (KAFKA_TOPIC='order_flow', VALUE_FORMAT='AVRO', KEY_FORMAT='KAFKA');

-- Update cache

CREATE OR REPLACE TABLE ORDERS_CACHE_CLEAN AS
SELECT ORDER_ID_KEY `ORDERID`
    , FROM_UNIXTIME(ORDERTIME) `ORDERTIME`
    , ITEMID `ITEMID`
    , ORDERUNITS `ORDERUNITS`
    , ADDRESS->CITY `ADDRESS_CITY`
    , ADDRESS->STATE `ADDRESS_STATE`
    , ADDRESS->ZIPCODE `ADDRESS_ZIPCODE`
    , EXTRAFIELD_EVOLUTION `EVOLUTION`
    , EVOLUTION_V2 `EVOLUTION_V2`
FROM ORDERS_CACHE
EMIT CHANGES;