FROM solr:5.5.4-alpine

COPY conf /solrconf

RUN /opt/solr/bin/solr start && \
    /opt/solr/bin/solr create_core -c development-core -d /solrconf && \
    /opt/solr/bin/solr create_core -c test-core -d /solrconf && \
    /opt/solr/bin/solr stop
