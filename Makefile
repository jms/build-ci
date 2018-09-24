run:
	docker build --no-cache -t jmsanchez/build-ci .

shell:
	docker run -it jmsanchez/build-ci bash -l