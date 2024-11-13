ssh-keygen -t rsa -b 2048 -f ~/.ssh/key_pair
ssh -i ~/.ssh/key_pair ubuntu@SERVERPUBLICIP
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"


<<COMMENT
sudo apt update
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx

cd /var/www/html

sudo git clone https://github.com/StartBootstrap/startbootstrap-sb-admin.git
sudo mv startbootstrap-sb-admin/* .
sudo mv dist/* .
sudo rm -rf startbootstrap-sb-admin
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
sudo systemctl stop nginx
sudo systemctl start nginx
sudo systemctl daemon-reload
COMMENT

