# README

## Steps to install Data2paper

1. Install Docker and Docker Compose following the [installation guide](https://docs.docker.com/compose/install/)

2. For Linux-based installs, ensure that Docker Compose does [not require root permissions](https://docs.docker.com/install/linux/linux-postinstall/)

3. Verify that Docker and Docker Compose are running and are recent versions
    ```bash
    $ docker -v
    Docker version 17.12.0-ce, build c97c6d6
    ```

    ```bash
    $ docker-compose -v
    docker-compose version 1.18.0, build 8dd22a9
    ```

4. Clone the Data2paper repository 
    ```bash
    $ git clone https://github.com/anusharanganathan/data2paper.git
    Cloning into 'data2paper'...
    remote: Counting objects: 1585, done.
    remote: Compressing objects: 100% (185/185), done.
    remote: Total 1585 (delta 283), reused 371 (delta 257), pack-reused 1132
    Receiving objects: 100% (1585/1585), 579.40 KiB | 1.06 MiB/s, done.
    Resolving deltas: 100% (850/850), done.
    ```
    Switch to the `refactor` branch
    ```bash
    $ cd data2paper
    $ git checkout refactor
    ```

5. Generate three .env files to set database passwords
    
    Create a file `postgres/.env` and specify the master database password, as well as separate database passwords for Data2paper 
    and Fedora Commons:
    ```bash
    # Note: this is the master postgres user's password
    POSTGRES_USER=postgres
    POSTGRES_PASSWORD=password
    
    # This is the data2paper database user's password
    DATA2PAPER_PASSWORD=password_d2p
    
    # This is the fedora_commons database user's password
    FEDORA_COMMONS_PASSWORD=password_fc
    ```

    Create a file `fedora_commons/.env` and specify the same database password for Fedora Commons:
    ```bash
    POSTGRES_HOST=postgres
    POSTGRES_USER=fedora_commons
    POSTGRES_PASSWORD=password_fc
    ```
    
    Finally, create a file `data2paper/.env` (i.e. in `data2paper/data2paper/.env`) and specify the data2paper database
    password and secret key. (A new random secret key can be easily generated using the Rails utility `rake secret` if 
    you have a working Rails project to hand.)
    ```bash
    POSTGRES_HOST=postgres
    POSTGRES_USER=data2paper
    POSTGRES_PASSWORD=password_d2p
    
    SECRET_KEY_BASE=ac3847e644d0ba45d01d84eeadb411659290340003771d939c523c9a2bf7775b9265f9801c12b11bbeb8e672cc258a50ca39c5b634b0b4bb2b1ededfd542fcd1
    HOST=data2paper.org
    ```

6. Build the containers (can take 10~30 mins if never built before)
    ```bash
    $ docker-compose build
    ```
    
    Run the system:
    ```bash
    $ docker-compose run
    ```

7. Login using the URL http://localhost:3000/admin/sign_in?locale=en
    
    The default admin account is: admin@example.com / password

