-- Our orders stream has added a new field called "extrafield_evolution" and we'd like our stream
-- to reflect this new field. The field was evolved with schema registry forward transitory guarantees, so the data is being produced 
-- with the new field, but this new field isn't being interpreted by our cache. 
-- Here, we update our cache to interpret the new field.

-- Trigger reinterpretation of the schema

CREATE OR REPLACE STREAM ORDERS_FLOW WITH (KAFKA_TOPIC='order_flow', VALUE_FORMAT='AVRO');

-- Update cache

CREATE OR REPLACE TABLE ORDER_CACHE AS
SELECT ORDERID `ORDERID`
    , LATEST_BY_OFFSET(ORDERTIME) `ORDERTIME`
    , LATEST_BY_OFFSET(ITEMID) `ITEMID`
    , LATEST_BY_OFFSET(ORDERUNITS) `ORDERUNITS`
    , LATEST_BY_OFFSET(ADDRESS->CITY) `ADDRESS_CITY`
    , LATEST_BY_OFFSET(ADDRESS->STATE) `ADDRESS_STATE`
    , LATEST_BY_OFFSET(ADDRESS->ZIPCODE) `ADDRESS_ZIPCODE`
    , LATEST_BY_OFFSET(EXTRAFIELD_EVOLUTION) `NEWFIELD`
FROM ORDERS_FLOW
GROUP BY ORDERID;