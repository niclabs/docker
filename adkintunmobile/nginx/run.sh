docker run --name nginx-adk-all -v $(pwd)/nginx.conf:/etc/nginx/conf.d/adk.conf:ro \
	--link server-report:server-report -p 80:80 -p 8888:8888 \
	-v /etc/localtime:/etc/localtime:ro  --restart=unless-stopped --log-opt max-size=50m -d nginx

