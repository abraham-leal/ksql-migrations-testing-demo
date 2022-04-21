import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.IntegerSerializer;
import org.apache.kafka.common.serialization.StringSerializer;
import org.apache.log4j.BasicConfigurator;
import java.util.Properties;

public class orders_producer_dg {

    private static final String TOPIC = "order_flow";

    public static Properties getConfig (){
        final Properties props = new Properties();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "pkc-6ojv2.us-west4.gcp.confluent.cloud:9092");
        props.put(ProducerConfig.ACKS_CONFIG, "all");
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, io.confluent.kafka.serializers.KafkaAvroSerializer.class);
        props.put(ProducerConfig.CLIENT_ID_CONFIG, "orders_producer");
        props.put(ProducerConfig.BATCH_SIZE_CONFIG, 65536);
        props.put(ProducerConfig.LINGER_MS_CONFIG, 10);
        props.put(ProducerConfig.COMPRESSION_TYPE_CONFIG, "snappy");
        props.put("sasl.jaas.config", "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"CQFOXOIC6JE5K6OJ\" " +
                "password=\"EiBPejeUZhKShAUDCI1dF+xDz2LkLzUki7JmtQ3+IXKfDH5fa4H63yIQw37Yb6pZ\";");
        props.put("sasl.mechanism", "PLAIN");
        props.put("security.protocol", "SASL_SSL");

        props.put("schema.registry.url", "https://psrc-4r3n1.us-central1.gcp.confluent.cloud");
        props.put("basic.auth.credentials.source", "USER_INFO");
        props.put("basic.auth.user.info", "G6DKMBPKTOKVQAFB:aMImvFaPV9V42dBXP6vgoBrJ4y9tL/q0yqfsvXQtCSW7Xm8vYNTPSm4gcXnohiwv");

        return props;
    }

    public static void main(final String[] args) {
        BasicConfigurator.configure();

        //Start producer with configurations
        KafkaProducer<String, ksql.orders> producer =
                new KafkaProducer<String, ksql.orders>(getConfig());

        try {

            for (long i = 0; i < 1; i++) {
                //Std generation of fake key and value
                final String orderId = "777777";
                final ksql.address fake_addr = new ksql.address();
                fake_addr.setCity("Austin");
                fake_addr.setState("Texas");
                fake_addr.setZipcode(78704L);
                final ksql.orders gen_order = new ksql.orders();
                gen_order.setOrderid(777777);
                gen_order.setOrdertime(System.currentTimeMillis());
                gen_order.setOrderunits(1.0D);
                gen_order.setItemid("Item_infinity");
                gen_order.setAddress(fake_addr);
                gen_order.setExtrafieldEvolution("something");
                gen_order.setEvolutionV2("SomethingElse");

                // Generating record without header
                final ProducerRecord<String, ksql.orders> record =
                        new ProducerRecord<String, ksql.orders>(TOPIC, orderId, gen_order);

                producer.send(record, ((recordMetadata, e) -> {
                    System.out.println("Record was sent to topic " +
                            recordMetadata.topic() + " with offset " + recordMetadata.offset() + " in partition " + recordMetadata.partition());
                }));
            }

        }
        catch (Exception ex){
            ex.printStackTrace();
        }

        //Tell producer to flush before exiting
        producer.flush();
        System.out.printf("Successfully produced messages to a topic called %s", TOPIC);

        //Shutdown hook to assure producer close
        Runtime.getRuntime().addShutdownHook(new Thread(producer::close));

    }

}
