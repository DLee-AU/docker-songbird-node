SHELL := /bin/bash
QUIET := @

# Taken from 
# https://github.com/adepretis/docker-make-stub

BLUE      := $(shell tput -Txterm setaf 4)
GREEN     := $(shell tput -Txterm setaf 2)
TURQUOISE := $(shell tput -Txterm setaf 6)
WHITE     := $(shell tput -Txterm setaf 7)
YELLOW    := $(shell tput -Txterm setaf 3)
GREY      := $(shell tput -Txterm setaf 1)
RESET     := $(shell tput -Txterm sgr0)
RED       := $(shell tput -Txterm setaf 1)

SMUL      := $(shell tput smul)
RMUL      := $(shell tput rmul)

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP_FUN = \
	%help; \
	use Data::Dumper; \
	while(<>) { \
		if (/^([_a-zA-Z0-9\-%]+)\s*:.*\#\#(?:@([a-zA-Z0-9\-_\s]+))?\t(.*)$$/ \
			|| /^([_a-zA-Z0-9\-%]+)\s*:.*\#\#(?:@([a-zA-Z0-9\-]+))?\s(.*)$$/) { \
			$$c = $$2; $$t = $$1; $$d = $$3; \
			push @{$$help{$$c}}, [$$t, $$d, $$ARGV] unless grep { grep { grep /^$$t$$/, $$_->[0] } @{$$help{$$_}} } keys %help; \
		} \
	}; \
	for (sort keys %help) { \
		printf("${WHITE}%24s:${RESET}\n\n", $$_); \
		for (@{$$help{$$_}}) { \
			printf("%s%25s${RESET}%s  %s${RESET}\n", \
				( $$_->[2] eq "Makefile" || $$_->[0] eq "help" ? "${YELLOW}" : "${GREY}"), \
				$$_->[0], \
				( $$_->[2] eq "Makefile" || $$_->[0] eq "help" ? "${GREEN}" : "${GREY}"), \
				$$_->[1] \
			); \
		} \
		print "\n"; \
	}

# make
.DEFAULT_GOAL := help

# Variable wrapper
define defw
	custom_vars += $(1)
	$(1) ?= $(2)
	export $(1)
	shell_env += $(1)="$$($(1))"
endef

# Variable wrapper for hidden variables
define defw_h
	$(1) := $(2)
	shell_env += $(1)="$$($(1))"
endef

# Colorized output for control functions (info, warning, error)
define verbose_info 
	@echo ${TURQUOISE}
	@echo ================================================================================
	@echo ${1}
	@echo ================================================================================
	@echo
	@tput -Txterm sgr0 # ${RESET} won't work here for some reason
endef

define verbose_warning
	@echo ${YELLOW}
	@echo ================================================================================
	@echo ${1}
	@echo ================================================================================
	@echo
	@tput -Txterm sgr0 # ${RESET} won't work here for some reason
endef

define verbose_error
	@echo ${RED}
	@echo ================================================================================
	@echo ${1}
	@echo ================================================================================
	@echo
	@tput -Txterm sgr0 # ${RESET} won't work here for some reason
endef

define information_title	
	@echo ${GREEN}================================================================================
	@echo ${1}
	@echo ================================================================================	
	@tput -Txterm sgr0 # ${RESET} won't work here for some reason
endef

define information_body
	$(QUIET)printf "%b" "${TURQUOISE}"
	$(QUIET)echo ${1}
	$(QUIET)tput -Txterm sgr0 # ${RESET} won't work here for some reason
endef

.PHONY: help
help:: ##@Usage Show this help.
	@echo ""
	@printf "%30s " "${BLUE}VARIABLES"
	@echo "${RESET}"
	@echo ""
	@printf "${BLUE}%25s${RESET}${TURQUOISE}  ${SMUL}%s${RESET}\n" $(foreach v, $(custom_vars), $v $(if $($(v)),$($(v)), ''))
	@echo ""
	@echo ""
	@echo ""
	@printf "%30s " "${YELLOW}TARGETS"
	@echo "${RESET}"
	@echo ""
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)


# =========================================== old
# .DEFAULT_GOAL := help

# SHELL := /bin/bash

# TODAYS_DATE=$(shell date --iso-8601)
# QUIET := @

# # Terminal Colors for the Shell
# # RED=\x1B
# RED=$'\e[1;31m
# # REDFLASH=$'\e[39;31;2:39;5m
# REDBG=$'\e[31;7;5;107m
# WHITE=$'\e[1;97m
# GREEN=$'\e[1;32m
# YELLOW=$'\e[1;33m
# YELLOWREDBG=$'\e[37;7;5;107m
# BLUE=$'\e[1;34m
# MAGENTA=$'\e[1;35m
# CYAN=$'\e[1;36m
# END=$'\e[0m

# ifndef AWS_ACCESS_KEY_ID
# $(error AWS_ACCESS_KEY_ID, does not exist)
# endif

# ifndef AWS_SECRET_ACCESS_KEY
# $(error AWS_SECRET_ACCESS_KEY, does not exist)
# endif

