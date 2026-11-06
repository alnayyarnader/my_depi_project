FROM nginx:alpine
ENV NGINX_ENVSUBST_FILTER="^(FRONTEND_PORT|BACKEND_HOST|APP_NAMESPACE|BACKEND_PORT)$"
COPY nginx.conf /etc/nginx/templates/default.conf.template
COPY src/index.html /usr/share/nginx/html/index.html
