

 

RUN add-apt-repository ppa:webupd8team/java && apt-get update && apt-get install oracle-java7-installer -y

RUN apt-get install -y unzip \
    && curl -O -s -k -L -C - http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.2.2%20GA3/liferay-portal-tomcat-6.2-ce-ga3-20150103155803016.zip  \
    && unzip liferay-portal-tomcat-6.2-ce-ga3-20150103155803016.zip -d /opt \ 
    && rm liferay-portal-tomcat-6.2-ce-ga2-20140319114139101.zip
    
    
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:Celeron1+' | chpasswd

RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
    
COPY portal-ext.properties  /opt/liferay-portal-6.2-ce-ga3/


    # volumes
VOLUME ["/var/liferay-home", "/opt/liferay-portal-6.2-ce-ga3/"]

# Ports
EXPOSE 8080 ,22

# Set JAVA_HOME
ENV JAVA_HOME /opt/java

# EXEC
CMD ["run","/usr/sbin/sshd", "-D"]
ENTRYPOINT ["/opt/liferay-portal-6.2-ce-ga2/tomcat-7.0.42/bin/catalina.sh"]
