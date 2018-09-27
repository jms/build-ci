run:
	docker build --no-cache -t jmsanchez/build-ci .

shell:
	docker run -i -t --rm=true jmsanchez/build-ci bash -l