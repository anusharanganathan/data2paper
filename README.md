# README

## Steps to install Data2paper

1. [Install Ruby on Rails with rbenv](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-16-04)
   * Installed Ruby 2.4.2 ```rbenv install 2.4.2```
   * Rails 5.1.4 (Did not run ```echo "gem: --no-document" > ~/.gemrc``` as I didn't want to skip the docs)
   * Node.js for javascript runtime

2. Install [Hyrax pre-requisites](https://github.com/samvera/hyrax/#prerequisites)
   1. Install Redis ```sudo apt-get install redis-server && sudo systemctl enable redis-server.service```
   2. Install Sqlite ```sudo apt-get install sqlite3 libsqlite3-dev```
   3. Install Fits
      - Download Fits
        ```
        cd /home/appuser 
        wget http://projects.iq.harvard.edu/files/fits/files/fits-1.0.5.zip
        unzip fits-1.0.5.zip
        ```
      - Make fits.sh an executable 
        ```
        cd fits-1.0.5/
        chmod a+x fits.sh
        ```
      - Test fits.sh -h return a value 
        ```
        ./fits.sh -h
        ```
      - Add full path for fits.sh to $PATH
        Add the full path for fits.sh to $PATH
        ```
        PATH=/home/appuser/fits-1.0.5/fits.sh:$PATH
        ```
        Add this to the file ~/.profile
        ```
        vim ~/.profile
        ```
        After modifications, my path in the looks like
        ```
        PATH="$HOME/bin:$HOME/.local/bin:$PATH:$HOME/fits-1.0.5/fits.sh"
        ```
      - Also modify config/initializers/hyrax.rb and set the full path for fits in it
        ```
        config.fits_path = "/home/appuser/fits-1.0.5/fits.sh"
        ```
   4. Install Libre office for derivtaives    
        If ```which soffice``` returns a path, you're done. if not,install libre office    
        ```
        sudo apt install libreoffice-common
        ```
        Test ```which soffice``` returns a path

3. Clone the Data2paper repository

4. Install the gems 
```
bundle install
```

5. Create the database 
```
bundle exec rake db:create
```
    * Currently need to change the password in config/database.yml


6. Run the migrations 
```
bundle exec rake db:migrate
```

7. Fetch Solr and Fedora and run the application 
```
bundle exec rails hydra:server
```

8. Start background workers
```
sidekiq
```

9. Create the default admin set
```
bundle exec rails hyrax:default_admin_set:create
```

10. Create an admin user    
    Register a user for data2paper at http://localhost:3000/users/sign_up    
    ```
    $ rails c
    admin = Role.create(name: "admin")
    admin.users << User.find_by_user_key( "your_admin_users_email@fake.email.org" )
    admin.save
    ```
    Then login using the URL http://localhost:3000/admin/sign_in?locale=en

