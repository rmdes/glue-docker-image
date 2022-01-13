FROM python:3.7-bullseye

LABEL version=1.0 maintainer="Stax Development Team" author="Elemir Stevko"

ARG USER_HOME_DIR="/root"
ARG ROOT_DIR="$USER_HOME_DIR/aws-glue-libs"
ARG GLUE_JARS_DIR="$ROOT_DIR/jarsv3"
ARG GLUE_PY_FILES "$ROOT_DIR/PyGlue.zip"
ARG SPARK_CONF_DIR "$ROOT_DIR/conf"

RUN wget -O- https://apt.corretto.aws/corretto.key | apt-key add -
RUN apt-get update && apt-get install -y software-properties-common zip
RUN add-apt-repository 'deb https://apt.corretto.aws stable main'
RUN apt-get update && apt-get install -y java-1.8.0-amazon-corretto-jdk

WORKDIR /root

RUN git clone https://github.com/awslabs/aws-glue-libs.git

# maven
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
    && curl -fsSL -o /tmp/apache-maven.tar.gz https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-common/apache-maven-3.6.0-bin.tar.gz \
    && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 --no-same-owner \
    && rm -f /tmp/apache-maven.tar.gz \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

# Glue 3.0 libs
RUN curl -fsSL -o /tmp/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3.tgz https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-3.0/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3.tgz \
    && tar xf /tmp/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3.tgz --no-same-owner \
    && rm -f /tmp/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3.tgz

ENV SPARK_HOME $USER_HOME_DIR/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3
ENV SPARK_CONF_DIR "$ROOT_DIR/conf"
ENV PYTHONPATH "$ROOT_DIR/PyGlue.zip:$SPARK_HOME/python/lib/py4j-0.10.9-src.zip:$SPARK_HOME/python/"

RUN cd "$ROOT_DIR" \
    && rm -f PyGlue.zip \
    && zip -r PyGlue.zip awsglue \
    && mvn -f $ROOT_DIR/pom.xml -DoutputDirectory=$ROOT_DIR/jarsv3 dependency:copy-dependencies \
    && mkdir -p "$SPARK_CONF_DIR" \
    && rm -f "$SPARK_CONF_DIR/spark-defaults.conf" \
    && echo "spark.driver.extraClassPath $GLUE_JARS_DIR/*" >> $SPARK_CONF_DIR/spark-defaults.conf \
    && echo "spark.executor.extraClassPath $GLUE_JARS_DIR/*" >> $SPARK_CONF_DIR/spark-defaults.conf

# Remove netty jar files as a temporary fix for the problem in Glue 3.0 distribution
RUN rm "$ROOT_DIR"/jarsv3/netty-*.jar

CMD bash
