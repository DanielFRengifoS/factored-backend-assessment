# README
# github: https://github.com/DanielFRengifoS/factored-backend-assessment

* ruby v 3.1.3

* Description

This is software that acts as a both mediator and administrator of the database (SQLite) by providing an API. The API enables the web application to communicate with the database, perform CRUD (Create, Read, Update, Delete) operations, and filter data as needed.

Filters include text-based filters from regular columns, as well as filters using queries including foreign keys, from one-to-one relationships to many to many.

In general, it serves as a backend for a Star Wars web application, which implies that it is designed to provide information about the Star Wars universe, particularly it's Films, Planets and Characters. Therefore, the API included in this system is designed to provide access to this information, allowing the front-end web application to display it to users.

The software also includes user management. it is here that the CRUD capabilities are showcased, allowing the user to create read update, and delete users. pagination features are also included to facilitate data collection and visualization
Note CRUD functionalities also exist for the resources Film, Planet, and Person. however, these aren't used in the frontend implementation.

To use this application, you will need to have the following installed:

    Ruby: 3.1.3 (recommended)
    Rails 7.0.4.2

* Steps

    Install dependencies by running 
        bundle install
    Run rails to create the necessary database tables.
        db:migrate
    Start the development server by running.
        rails server

Configuration

- Will run in port 8000

# Future improvements

Given more time, I would've liked to include a jwt token for auth purposes.
Giving the app more security would also be a future improvement
Including starships, species, and vehicles into the app
making more complex filters, for example, greater than or lesser than for numerical values
expand the user functionalities and schema. It would be nice to include username, high score (check frontend main page), and profile picture for example
