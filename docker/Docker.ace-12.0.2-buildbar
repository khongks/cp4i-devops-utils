FROM ubuntu:20.04
MAINTAINER Trevor Dolby <tdolby@uk.ibm.com> (@tdolby)

# copied from https://github.com/ot4i/ace-docker/tree/master/experimental/ace-full
# docker build -t ace-buildbar:12.0.2.0-ubuntu -f Dockerfile.ubuntu
# docker build --no-cache -t ace-buildbar:12.0.2.0-ubuntu .
# oc patch configs.imageregistry.operator.openshift.io/cluster --patch '{"spec":{"defaultRoute":true}}' --type=merge
# HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
# oc get secret -n openshift-ingress  router-certs-default -o go-template='{{index .data "tls.crt"}}' | base64 -d | sudo tee /etc/pki/ca-trust/source/anchors/${HOST}.crt  > /dev/null
# docker login -u $(oc whoami) -p $(oc whoami -t) $HOST
# docker tag ace-buildbar:12.0.2.0-ubuntu $HOST/jenkins/ace-buildbar:12.0.2.0-ubuntu
# docker push $HOST/jenkins/ace-buildbar:12.0.2.0-ubuntu
# docker run -it ace-buildbar:12.0.2.0-ubuntu /bin/bash
# oc exec -it -n jenkins cp4i-jenkins-ace-43-g896j-ft090-n2327 -c buildbar -- /bin/bash
# oc adm prune images --registry-url=$HOST --confirm

# ARG DOWNLOAD_URL=http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/integration/12.0.2.0-ACE-LINUX64-DEVELOPER.tar.gz
# python -m SimpleHTTPServer 7800
ARG DOWNLOAD_URL=http://host.docker.internal:7800/12.0.2.0-ACE-LINUX64-DEVELOPER.tar.gz
ARG PRODUCT_LABEL=ace-12.0.2.0

# Prevent errors about having no terminal when using apt-get
ENV DEBIAN_FRONTEND noninteractive

# Install ACE v12.0.2.0 and accept the license
RUN apt-get update && apt-get install -y --no-install-recommends curl && \
    mkdir /opt/ibm && echo Downloading package ${DOWNLOAD_URL} && \
    curl ${DOWNLOAD_URL} | tar zx --directory /opt/ibm && \
    mv /opt/ibm/${PRODUCT_LABEL} /opt/ibm/ace-12 && \
    /opt/ibm/ace-12/ace make registry global accept license deferred

# Configure the system
RUN echo "ACE_12:" > /etc/debian_chroot \
  && echo ". /opt/ibm/ace-12/server/bin/mqsiprofile" >> /root/.bashrc

# mqsicreatebar prereqs; need to run "Xvfb -ac :99 &" and "export DISPLAY=:99"  
RUN apt-get -y install libgtk2.0-0 libxtst6 xvfb git curl libswt-gtk-4-java libswt-gtk-4-jni

# Set BASH_ENV to source mqsiprofile when using docker exec bash -c
ENV BASH_ENV=/opt/ibm/ace-12/server/bin/mqsiprofile

# Create a user to run as, create the ace workdir, and chmod script files
# RUN useradd --uid 1001 --create-home --home-dir /home/aceuser --shell /bin/bash -G mqbrkrs,sudo aceuser \
#   && su - aceuser -c "export LICENSE=accept && . /opt/ibm/ace-12/server/bin/mqsiprofile && mqsicreateworkdir /home/aceuser/ace-server" \
#   && echo ". /opt/ibm/ace-12/server/bin/mqsiprofile" >> /home/aceuser/.bashrc

RUN su - root -c "export LICENSE=accept && . /opt/ibm/ace-12/server/bin/mqsiprofile && mqsicreateworkdir /root"

USER root
RUN echo "Xvfb -ac :100 &" >> /root/.bashrc
RUN echo "export DISPLAY=:100" >> /root/.bashrc
ENTRYPOINT ["bash"]

# aceuser
# USER 1001
# ENTRYPOINT ["bash"]