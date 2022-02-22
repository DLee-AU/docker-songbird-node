# Some Ideas on the Self Documenting Help
# taken from https://gist.github.com/prwhite/8168133

# Don't forget to use CCZE - for colorised output
# make | ccze -A

include make.d/common.mk
# include make.d/config.mk

.PHONY: flare-repo 
flare-repo:  ##@Misc	Setup Flare Repo
	$(QUIET)if [ -d "build/src/flare" ]; then\
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
coston-build: flare-repo ##@Coston	Build Docker Coston Node Image
	$(QUIET) printf "Docker Build\n"
	docker-compose -f docker-compose.coston.yml build

.PHONY: coston-up
coston-up: coston-build ##@Coston	Run Docker coston-node
	$(QUIET) printf "Docker Build\n"
	docker-compose -f docker-compose.coston.yml up -d

.PHONY: coston-down
coston-down: ##@Coston	Bring Coston Node Down
	$(QUIET) printf "Docker Build\n"
	docker-compose -f docker-compose.coston.yml down

.PHONY: coston-clean
coston-clean: ##@Coston	Remove Coston Image
	$(QUIET) printf "Docker Build\n"
	docker rmi dulee/flare-node:coston

.PHONY: songbird-build
songbird-build: flare-repo ##@Songbird	Build Docker Songbird Node Image
	$(QUIET) printf "Docker Build\n"
	docker-compose -f docker-compose.songbird.yml build

.PHONY: songbird-up
songbird-up: songbird-build ##@Songbird	Run Docker songbird-node
	$(QUIET) printf "Docker Build\n"
	docker-compose -f docker-compose.songbird.yml up -d

.PHONY: songbird-down
songbird-down: ##@Songbird	Bring Songbird Node Down
	$(QUIET) printf "Docker Build\n"
	docker-compose -f docker-compose.songbird.yml down

.PHONY: songbird-clean
songbird-clean: ##@Songbird	Remove Songbird Image
	$(QUIET) printf "Docker Build\n"
	docker rmi dulee/flare-node:songbird

.PHONY: clean 
clean: coston-down songbird-down ##@Misc	Remove all src files
	$(QUIET) printf "Cleaning up\n"
	$(QUIET) printf "Removing the Repo from build/src/flare"
	$(QUIET) rm -Rvf build/src/flare