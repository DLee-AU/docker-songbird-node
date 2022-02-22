# docker-songbird-node

Dockerised Songbird Node

## To Use

If in doubt run `make` and it should be self documenting

    > make

                  TARGETS

                  Coston:

             coston-build  Build Docker Coston Node Image
                coston-up  Run Docker coston-node
              coston-down  Bring Coston Node Down
             coston-clean  Remove Coston Image

                    Misc:

               flare-repo  Setup Flare Repo
                    clean  Remove all src files

                Songbird:

           songbird-build  Build Docker Songbird Node Image
              songbird-up  Run Docker songbird-node
            songbird-down  Bring Songbird Node Down
           songbird-clean  Remove Songbird Image

                   Usage:

                     help  Show this help.


You run the stages individually or just run `make coston-up`

### Coston

    > make flare-repo
      ...    
    > make coston-build
      ...
    > make coston-up
      ...

### Songbird

    > make flare-repo
      ...    
    > make songbird-build
      ...
    > make songbird-up
      ...

# Notes

If you like it or want to change it go for it.

Regards,

Dusty