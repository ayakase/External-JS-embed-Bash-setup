#!/bin/bash

# Update and install required packages
sudo apt update
sudo apt install -y nginx snapd

# Install ngrok
sudo snap install ngrok

# Set up Nginx configuration
sudo tee /etc/nginx/sites-available/localhost > /dev/null << EOF
server {
    listen 8080;
    server_name localhost;

    location /scripts/ {
        root /var/www/html;
        expires 30d;
        add_header Cache-Control "public, no-transform";
    }
}
EOF

# Enable the configuration
sudo ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/

# Test and reload Nginx
sudo nginx -t && sudo systemctl reload nginx

# Create script directory and set permissions
sudo mkdir -p /var/www/html/scripts
sudo chown -R ubuntu:ubuntu /var/www/html/scripts

# Create the floating icon script
cat << EOF > /var/www/html/scripts/floating-icon.js
(function() {
    var icon = document.createElement('div');
    icon.innerHTML = '👋';
    icon.style.position = 'fixed';
    icon.style.bottom = '20px';
    icon.style.right = '20px';
    icon.style.width = '50px';
    icon.style.height = '50px';
    icon.style.borderRadius = '50%';
    icon.style.backgroundColor = '#007bff';
    icon.style.color = 'white';
    icon.style.display = 'flex';
    icon.style.justifyContent = 'center';
    icon.style.alignItems = 'center';
    icon.style.fontSize = '24px';
    icon.style.cursor = 'pointer';
    icon.style.boxShadow = '0 2px 10px rgba(0,0,0,0.2)';
    icon.style.zIndex = '9999';

    icon.onmouseover = function() { this.style.transform = 'scale(1.1)'; };
    icon.onmouseout = function() { this.style.transform = 'scale(1)'; };
    icon.onclick = function() { alert('Icon clicked!'); };

    document.body.appendChild(icon);
})();
EOF

echo "Setup complete."
