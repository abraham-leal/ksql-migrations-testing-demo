FROM confluentinc/cp-ksqldb-server:7.1.1
COPY . /build
WORKDIR /build