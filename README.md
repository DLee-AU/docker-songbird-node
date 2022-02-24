# docker-songbird-node

Dockerised Songbird Node

## Prerequisite

* docker
* docker-compose
* make

## Adjustments

To adjust where the location of the log files and the db is located on the host.

You need to change where the `/logs` and `/db` in the contatiner are mapped to.

To do so just change the `DB_DIR` and `LOG_DIR` in the `./build/.env.<network>` file.

`./build/.env.coston` - *Original*

    FLARE_NETWORK_ID=coston
    HTTP_HOST=0.0.0.0
    DB_DIR=./db               <-- Change These for Directory Location outside of the Container
    LOG_DIR=./logs            <-- Change These for Directory Location outside of the Container
    CHAIN_CONFIG_DIR=/app/.flare/configs
    LOG_LEVEL=INFO

Change them to the directory you prefer

`./build/.env.coston` - *Adjusted*

    FLARE_NETWORK_ID=coston
    HTTP_HOST=0.0.0.0
    DB_DIR=/srv/coston/db     <-- Changed to the preferred Directory on the Host
    LOG_DIR=/srv/coston/logs  <-- Changed to the preferred Directory on the Host
    CHAIN_CONFIG_DIR=/app/.flare/configs
    LOG_LEVEL=INFO

## Docker Compose File 

`docker-compose.<network>.yml`

    version: '3'

    services:
      flare-node-coston:
        image: dulee/flare-node:coston
        container_name: flare_node_coston
        hostname: flare_node_coston
        # restart: unless-stopped
        restart: on-failure
        stdin_open: true # docker run -i
        tty: true        # docker run -t
        ports:
          - 19650:9650
          - 19651:9651
        # Environment Variables in the Container
        environment:
          - FLARE_NETWORK_ID=${FLARE_NETWORK_ID:-coston}
          # - HTTP_HOST=${HTTP_HOST:-0.0.0.0}
          - LISTEN_ADDRESS=0.0.0.0
          - BOOTSTRAP_IPS=${BOOTSTRAP_IPS:-}
          - BOOTSTRAP_IDS=${BOOTSTRAP_IDS:-}
          - DB_DIR=/db
          - LOG_DIR=/logs
          - CHAIN_CONFIG_DIR=${CHAIN_CONFIG_DIR:-/app/.flare/configs}
          - LOG_LEVEL=${LOG_LEVEL:-INFO}
        build:
          context: build
          dockerfile: Dockerfile.coston
        # Env Variable from outside the container, i.e. SHELL Variables
        env_file:
          - ./build/.env.coston
        volumes:
          - ${DB_DIR:-./db}:/db
          - ${LOG_DIR:-./logs}/logs:/logs
          - ${PWD}/configs/coston:/app/.flare/configs
        
## To Use

If in doubt run `make` and it should be self documenting

    > make

                          TARGETS

                          Coston:

              coston-config-check  Config Check
                    coston-build  Build Docker Coston Node Image
                        coston-up  Run Docker coston-node
                      coston-down  Bring Coston Node Down
                    coston-status  Run Status songbird-node
                      coston-logs  Run Status songbird-node
                    coston-clean  Remove Coston Image

                            Misc:

                      flare-repo  Setup Flare Repo
                            clean  Remove all src files
                            check  Check for Applicable Files Exist

                          Python:

                    python-setup  Setup Python DockerImage ${PYTHON_IMAGE} (Planned)
              python-coston-test  Run Python Tests Against Coston Node (Planned)
            python-songbird-test  Run Python Tests Against Songbird Node (Planned)

                              S3:

                        s3-setup  Setup S3 (Planned)
                    s3-bootstrap  Copy Databasefiles from S3 Source (Planned)

                        Songbird:

                  songbird-build  Build Docker Songbird Node Image
                      songbird-up  Run Docker songbird-node
                    songbird-down  Bring Songbird Node Down
                  songbird-status  Run Status songbird-node
                    songbird-logs  Run Status songbird-node
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