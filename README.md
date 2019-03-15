# jihuama/tommariassh
This project build a docker container, based on alpine, include openjdk,tomcat7,mariaDB,vim.
Open ports 8080,3306,22.
All passwords is 123456
## China TimeZone
docker run --name mytomsql -d -p 9090:8080 -p 55:22 -p 3306:3306 jihuama/tommariassh
## Other TimeZone
docker run --name mytomsql -e TZ='Europe/Vienna' -d -p 9090:8080 -p 55:22 -p 3306:3306 jihuama/tommariassh
