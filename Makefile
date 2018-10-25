DOCKER_USER := ogarcia
DOCKER_ORGANIZATION := connectical
DOCKER_IMAGE := davmail

docker-image:
	docker build -t $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE) .

docker-image-test: docker-image
	docker run --name davmail -d -p 1025:1025 -p 1389:1389 -p 1110:1110 -p 1143:1143 -p 1080:1080 $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE)
	sleep 5
	netstat -puntal | egrep "1025|1389|1110|1143|1080"
	docker kill davmail
	docker rm davmail

ci-test: docker-image-test

.PHONY: docker-image docker-image-test ci-test
# vim:ft=make
