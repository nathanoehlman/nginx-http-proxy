
#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;




events {
    worker_connections  8080;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;
    
### TODO make this an include rather than the whole config
    ## register the routes
    {{#each route}}
    upstream {{this.source}} { 
        {{#each this.hosts}}server {{this}};
        {{/each}}
    }
    {{/each}}

    server {
        listen       80;
        server_name  _;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;
### TODO make this an include rather than the whole config

{{#each route}}
        location /{{this.source}} {
            proxy_pass http://{{this.source}}/{{this.source}};
        }
{{/each}}
    }

}
