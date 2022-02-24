# Some Ideas on the Self Documenting Help
# taken from https://gist.github.com/prwhite/8168133

# Don't forget to use CCZE - for colorised output
# make | ccze -A

include make.d/common.mk
include make.d/config.mk

# .DEFAULT_GOAL := generate

all: check check-quiet

.PHONY: flare-repo 
flare-repo:  ##@Misc	Setup Flare Repo
	$(QUIET)if [ -d "build/src/flare/.git" ]; then\
		git ls-remote build/src/flare -q > /dev/null 2>&1;\
	else\
		echo "Cloning";\
		git clone https://github.com/flare-foundation/flare.git build/src/flare;\
	fi
	$(QUIET)if [ $$? -eq 0 ]; then\
    	echo OK;\
	else\
		echo FAIL;\
	fi

.PHONY: coston-config-check
coston-config-check: ##@Coston	Config Check
	$(QUIET) printf "Docker Config Check\n"
	$(DOCKER-COMPOSE) --env-file ${COSTON_ENV_FILE} -f docker-compose.coston.yml config

.PHONY: coston-build
# coston-build: check check-quiet flare-repo ##@Coston	Build Docker Coston Node Image
coston-build: flare-repo ##@Coston	Build Docker Coston Node Image
	$(QUIET) printf "Docker Build\n"
	echo $(DOCKER-COMPOSE)
	$(DOCKER-COMPOSE) --env-file ${COSTON_ENV_FILE} -f docker-compose.coston.yml build

.PHONY: coston-up
coston-up: coston-build ##@Coston	Run Docker coston-node
	$(QUIET) printf "Docker Up\n"
	$(DOCKER-COMPOSE) --env-file ${COSTON_ENV_FILE} -f docker-compose.coston.yml up -d

.PHONY: coston-down
coston-down: check-quiet ##@Coston	Bring Coston Node Down
	$(QUIET) printf "Docker Down\n"
	$(DOCKER-COMPOSE) --env-file ${COSTON_ENV_FILE} -f docker-compose.coston.yml down

.PHONY: coston-status
coston-status: check-quiet ##@Coston	Run Status songbird-node
	$(QUIET) printf "Docker Status\n"
	$(DOCKER-COMPOSE) --env-file ${COSTON_ENV_FILE} -f docker-compose.coston.yml ps

.PHONY: coston-logs
coston-logs: check-quiet ##@Coston	Run Status songbird-node
	$(QUIET) printf "Docker Logs\n"
	$(DOCKER-COMPOSE) --env-file ${COSTON_ENV_FILE} -f docker-compose.coston.yml logs -f

.PHONY: coston-clean
coston-clean: check-quiet ##@Coston	Remove Coston Image
	$(QUIET) printf "Docker Clean\n"
	$(DOCKER) rmi dulee/flare-node:coston

.PHONY: songbird-config-check
songbird-config-check: ##@Coston	Config Check
	$(QUIET) printf "Docker Config Check\n"
	$(DOCKER-COMPOSE) --env-file ${SONGBIRD_ENV_FILE} -f docker-compose.songbird.yml config

.PHONY: songbird-build
songbird-build: check check-quiet flare-repo ##@Songbird	Build Docker Songbird Node Image
	$(QUIET) printf "Docker Build\n"
	$(DOCKER-COMPOSE) --env-file ${SONGBIRD_ENV_FILE} -f docker-compose.songbird.yml build

.PHONY: songbird-up
songbird-up: songbird-build ##@Songbird	Run Docker songbird-node
	$(QUIET) printf "Docker Up\n"
	$(DOCKER-COMPOSE) --env-file ${SONGBIRD_ENV_FILE} -f docker-compose.songbird.yml up -d

.PHONY: songbird-down
songbird-down: check-quiet##@Songbird	Bring Songbird Node Down
	$(QUIET) printf "Docker Down\n"
	$(DOCKER-COMPOSE) --env-file ${SONGBIRD_ENV_FILE} -f docker-compose.songbird.yml down

.PHONY: songbird-status
songbird-status: check-quiet ##@Songbird	Run Status songbird-node
	$(QUIET) printf "Docker Status\n"
	$(DOCKER-COMPOSE) --env-file ${SONGBIRD_ENV_FILE} -f docker-compose.songbird.yml ps

.PHONY: songbird-logs
songbird-logs: check-quiet ##@Songbird	Run Status songbird-node
	$(QUIET) printf "Docker Logs\n"
	$(DOCKER-COMPOSE) --env-file ${SONGBIRD_ENV_FILE} -f docker-compose.songbird.yml logs -f

.PHONY: songbird-clean
songbird-clean: check-quiet##@Songbird	Remove Songbird Image
	$(QUIET) printf "Docker Clean\n"
	$(DOCKER) rmi dulee/flare-node:songbird

.PHONY: clean 
clean: coston-clean songbird-clean ##@Misc	Remove all src files
	$(QUIET) printf "Cleaning up\n"
	$(QUIET) printf "Removing the Repo from build/src/flare"
	$(QUIET) rm -Rvf build/src/flare

# S3 Data Operations
.PHONY: s3-setup
s3-setup: ##@S3	Setup S3 (Planned)
	$(QUIET) printf "\e[1;32m###    Setup S3     ###\e[0m\n"
	$(QUIET) printf "\e[1;33m... SETUP TO FOLLOW ...\e[0m\n"

.PHONY: s3-bootstrap
s3-bootstrap: ##@S3	Copy Database files from S3 Source (Planned)
	$(QUIET) printf "\e[1;32mDownload (sync) DB from S3 Location ${S3_URL}\e[0m\n"
	$(QUIET) printf "\e[1;33mDownloading (syncing) to File Location:\e[0m\n"

.PHONY: python-setup
python-setup: ##@Python	Setup Python DockerImage ${PYTHON_IMAGE} (Planned)
	$(QUIET) \
	if [ $(DOCKER) inspect --type=image ${PYTHON_IMAGE} > /dev/null 2>&1 ]; then \
		printf "DockerImage(Python) - OK \n"; \
	else \
		printf "${PYTHON_IMAGE} \e[1;31mNot Found\e[0m - \e[1;32mPulling\e[0m\n"; \
		$(DOCKER) pull ${PYTHON_IMAGE}; \
	fi

# Testing
.PHONY: python-coston-test
python-coston-test: python-setup ##@Python	Run Python Tests Against Coston Node (Planned)
	$(PYTHON) tests/app.py

# Testing
.PHONY: python-songbird-test
python-songbird-test: python-setup ##@Python	Run Python Tests Against Songbird Node (Planned)
	$(PYTHON) tests/app.py

