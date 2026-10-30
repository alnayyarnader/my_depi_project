FROM nginx:alpine

# Copy static frontend files to Nginx default public folder
COPY src/ /usr/share/nginx/html/

# Copy custom Nginx configuration if needed
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
