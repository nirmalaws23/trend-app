FROM nginx:alpine

# Copy compiled production assets from dist folder to Nginx server root
COPY dist/ /usr/share/nginx/html/

# Expose port 3000 as required by the assignment guidelines
EXPOSE 3000

# Custom Nginx configuration to serve traffic on port 3000
RUN sed -i 's/listen  *80;/listen 3000;/g' /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
