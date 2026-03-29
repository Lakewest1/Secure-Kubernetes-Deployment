FROM nginxinc/nginx-unprivileged:latest  

# Copy your HTML files directly (overwrite defaults)
COPY index.html /usr/share/nginx/html/index.html

# If you have more files (CSS, JS, images)
# COPY . /usr/share/nginx/html