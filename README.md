# docker-songbird-node

Dockerised Songbird Node

## Prerequisite

* docker
* docker-compose
* make

## Adjustments

To adjust where the location of the log files and the db is located.

You need to change where the `/logs` and `/db` in the contatiner are mapped to.

So just adjust the `docker-compose.<network>.yml` file Volumes attribute to change the location


    services:
    flare-node-songbird:
        image: dulee/flare-node:songbird
        container_name: flare_node_songbird
        hostname: flare_node_songbird
        # restart: unless-stopped
        restart: on-failure
        stdin_open: true # docker run -i
        tty: true        # docker run -t
        ports:
            - 29650:9650
            - 29651:9651
        environment:
            - FLARE_NETWORK_ID=${FLARE_NETWORK_ID:-songbird}
            # - HTTP_HOST=${HTTP_HOST:-0.0.0.0}
            - LISTEN_ADDRESS=0.0.0.0
            - BOOTSTRAP_IPS=${BOOTSTRAP_IPS:-}
            - BOOTSTRAP_IDS=${BOOTSTRAP_IDS:-}
            - DB_DIR=${DB_DIR:-/db}
            - LOG_DIR=${LOG_DIR:-/logs}
            - CHAIN_CONFIG_DIR=${CHAIN_CONFIG_DIR:-/app/.flare/configs}
            - LOG_LEVEL=${LOG_LEVEL:-INFO}    
        build:
            context: build
            dockerfile: Dockerfile.songbird
        env_file:
            - ./build/.env.songbird
        volumes:
            - ${PWD}/db:/db         <-- Change This i.e     - /srv/data/database_dir:/db 
            - ${PWD}/logs:/logs     <-- Change This i.e     - /srv/logs/log_dir:/logs
            - ${PWD}/configs:/app/.flare/configs
## To Use

If in doubt run `make` and it should be self documenting

    > make

                  TARGETS

                  Coston:

             coston-build  Build Docker Coston Node Image
                coston-up  Run Docker coston-node
            coston-status  Run Status songbird-node
              coston-logs  Run Status songbird-node
              coston-down  Bring Coston Node Down
             coston-clean  Remove Coston Image

                    Misc:

                    check  Check for Applicable Files Exist
               flare-repo  Setup Flare Repo
                    clean  Remove all src files

                Songbird:

           songbird-build  Build Docker Songbird Node Image
              songbird-up  Run Docker songbird-node
          songbird-status  Run Status songbird-node
            songbird-logs  Run Status songbird-node
            songbird-down  Bring Songbird Node Down
           songbird-clean  Remove Songbird Image

                   Usage:

                     help  Show this help.


You run the stages individually or just run `make coston-up`

### Coston

If you want to bring it up

    > make flare-repo
      ...    
    > make coston-build
      ...
    > make coston-up
      ...

If you want to bring it down
    
    > make coston-down
      ...


### Songbird

If you want to bring it up

    > make flare-repo
      ...    
    > make songbird-build
      ...
    > make songbird-up
      ...

If you want to bring it down

    > make songbird-down
      ...

# Notes

If you like it or want to change it go for it.

Regards,

Dusty