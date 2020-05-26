.PHONY: build run clean push dbuild drun dclean dpush

# PRODUCTION BUILD
build:
	docker build . -f Dockerfile -t detectorchecker/detectorchecker_dashboard:latest
run:
	docker run -p 1111:1111 detectorchecker/detectorchecker_dashboard:latest
clean:
	docker image rm detectorchecker/detectorchecker_dashboard:latest
push:
	docker push detectorchecker/detectorchecker_dashboard:latest

# DEVELOPMENT BUILD
dbuild:
	docker build . -f Dockerfile -t detectorchecker/detectorchecker_dashboard:dev
drun:
	docker run -p 1111:1111 detectorchecker/detectorchecker_dashboard:dev
dclean:
	docker image rm detectorchecker/detectorchecker_dashboard:dev
dpush:
	docker push detectorchecker/detectorchecker_dashboard:dev