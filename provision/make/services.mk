#
# See ./CONTRIBUTING.rst
#

services:
	make services.help

services.help:
	@echo '    Services:'
	@echo ''
	@echo '        services.db                  Running db by stage=(dev,stage,test,prod)'
	@echo ''

services.db:
	@if [ -z "${stage}" ]; then \
		$(docker-dev) run --rm --service-ports -d db; \
	else \
		$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/${stage}.yml run --rm --service-ports -d db; \
	fi
