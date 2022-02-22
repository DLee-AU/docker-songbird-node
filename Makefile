# Some Ideas on the Self Documenting Help
# taken from https://gist.github.com/prwhite/8168133

# Don't forget to use CCZE - for colorised output
# make | ccze -A

include make.d/common.mk
# include make.d/config.mk

.PHONY: check
check:  ##@Misc	Check for Applicable Files Exist
	$(QUIET) \
	if command -v docker > /dev/null 2>&1 || command -v podman > /dev/null 2>&1; then \
		if command -v docker > /dev/null 2>&1; then \
			printf "\e[1;33mDocker\e[0m is \e[1;32mDetected\n\n\e[0m"; \
		fi; \
		if command -v podman > /dev/null 2>&1; then \
			printf "\e[1;33mPodman\e[0m is \e[1;32mDetected\n\n\e[0m"; \
		fi; \
	else \
		printf "\e[1;31mDocker\e[0m is \e[1;31mnot on the system\n\e[0m"; \
		printf "Please Install\n"; \
	fi
	$(QUIET) \
	if command -v docker-compose > /dev/null 2>&1 || command -v podman-compose > /dev/null 2>&1; then \
		if command -v docker-compose > /dev/null 2>&1; then \
			printf "\e[1;33mDocker Compose\e[0m is \e[1;32mDetected\n\n\e[0m"; \
		fi; \
		if command -v podman-compose > /dev/null 2>&1; then \
			printf "\e[1;33mPodman Compose\e[0m is \e[1;32mDetected\n\n\e[0m"; \
		fi; \
	else \
		printf "\e[1;31mdocker-compose\e[0m is \e[1;31mnot on the system\n\e[0m"; \
		printf "\e[1;35mPlease Install\e[0m\n"; \
	fi


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

.PHONY: coston-build
coston-build: check flare-repo ##@Coston	Build Docker Coston Node Image
	$(QUIET) printf "Docker Build\n"
	docker-compose -f docker-compose.coston.yml build

.PHONY: coston-up
coston-up: coston-build ##@Coston	Run Docker coston-node
	$(QUIET) printf "Docker Up\n"
	docker-compose -f docker-compose.coston.yml up -d

.PHONY: coston-status
coston-status:  ##@Coston	Run Status songbird-node
	$(QUIET) printf "Docker Status\n"
	docker-compose -f docker-compose.coston.yml ps

.PHONY: coston-logs
coston-logs:  ##@Coston	Run Status songbird-node
	$(QUIET) printf "Docker Logs\n"
	docker-compose -f docker-compose.coston.yml logs -f

.PHONY: coston-down
coston-down: ##@Coston	Bring Coston Node Down
	$(QUIET) printf "Docker Down\n"
	docker-compose -f docker-compose.coston.yml down

.PHONY: coston-clean
coston-clean: ##@Coston	Remove Coston Image
	$(QUIET) printf "Docker Clean\n"
	docker rmi dulee/flare-node:coston

.PHONY: songbird-build
songbird-build: check flare-repo ##@Songbird	Build Docker Songbird Node Image
	$(QUIET) printf "Docker Build\n"
	docker-compose -f docker-compose.songbird.yml build

.PHONY: songbird-up
songbird-up: songbird-build ##@Songbird	Run Docker songbird-node
	$(QUIET) printf "Docker Up\n"
	docker-compose -f docker-compose.songbird.yml up -d

.PHONY: songbird-status
songbird-status:  ##@Songbird	Run Status songbird-node
	$(QUIET) printf "Docker Status\n"
	docker-compose -f docker-compose.songbird.yml ps

.PHONY: songbird-logs
songbird-logs:  ##@Songbird	Run Status songbird-node
	$(QUIET) printf "Docker Logs\n"
	docker-compose -f docker-compose.songbird.yml logs -f

.PHONY: songbird-down
songbird-down: ##@Songbird	Bring Songbird Node Down
	$(QUIET) printf "Docker Down\n"
	docker-compose -f docker-compose.songbird.yml down

.PHONY: songbird-clean
songbird-clean: ##@Songbird	Remove Songbird Image
	$(QUIET) printf "Docker Clean\n"
	docker rmi dulee/flare-node:songbird

.PHONY: clean 
clean: coston-clean songbird-clean ##@Misc	Remove all src files
	$(QUIET) printf "Cleaning up\n"
	$(QUIET) printf "Removing the Repo from build/src/flare"
	$(QUIET) rm -Rvf build/src/flare