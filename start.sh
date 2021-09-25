if [ $# -eq 0 ] ; then
  echo "What is the project domain?"
  read DOMAIN
  if [ ${#DOMAIN} -eq 0 ] ; then
    echo "This is a invalid domain!"
    exit 1
  fi
else
  DOMAIN=$1
fi
FILE=$(pwd)/apache2/certs/$DOMAIN.crt
if [ ! -f "$FILE" ] ; then
  echo "Creating certificate..."
  echo "[req]
    distinguished_name = req_distinguished_name
    x509_extensions = v3_req
    prompt = no
    [req_distinguished_name]
    CN = *.$DOMAIN
    [v3_req]
    keyUsage = keyEncipherment, dataEncipherment
    extendedKeyUsage = serverAuth
    subjectAltName = @alt_names
    [alt_names]
    DNS.1 = *.$DOMAIN
    DNS.2 = $DOMAIN
  " > $(pwd)/apache2/certs/$DOMAIN.conf

  openssl req \
    -new \
    -newkey rsa:2048 \
    -sha1 \
    -days 3650 \
    -nodes \
    -x509 \
    -keyout apache2/certs/$DOMAIN.key \
    -out apache2/certs/$DOMAIN.crt \
    -config $(pwd)/apache2/certs/$DOMAIN.conf

  rm $(pwd)/apache2/certs/$DOMAIN.conf
  echo ""
  echo "Certificate generated for domains:"
  echo "- $DOMAIN"
  echo "- *.$DOMAIN"
  echo ""
  echo "Add the $(pwd)/apache2/certs/$DOMAIN.crt certificate to your valid keys."
  echo ""
fi

APACHE_FILE=apache2/vhosts/$DOMAIN.conf
if [ ! -f "$APACHE_FILE" ] ; then
  echo "ServerName $DOMAIN

    <VirtualHost *:80>
        ServerAdmin admin@$DOMAIN
        ServerName $DOMAIN
        ServerAlias www.$DOMAIN
        ServerAlias dev.$DOMAIN
        DocumentRoot /var/www/html/public
        ErrorLog ${APACHE_LOG_DIR}/www.$DOMAIN-error.log
        CustomLog ${APACHE_LOG_DIR}/www.$DOMAIN-access.log combined
    </VirtualHost>


    <VirtualHost *:443>
        ServerAdmin admin@$DOMAIN
        ServerName $DOMAIN
        ServerAlias www.$DOMAIN
        ServerAlias dev.$DOMAIN
        DocumentRoot /var/www/html/public
        ErrorLog ${APACHE_LOG_DIR}/www.$DOMAIN-error.log
        CustomLog ${APACHE_LOG_DIR}/www.$DOMAIN-access.log combined

        SSLEngine on
        SSLCertificateFile    /etc/apache2/ssl/from-host/$DOMAIN.crt
        SSLCertificateKeyFile /etc/apache2/ssl/from-host/$DOMAIN.key
    </VirtualHost>
  " > $APACHE_FILE

  echo ""
  echo "Created $APACHE_FILE";
fi

docker-compose up -d