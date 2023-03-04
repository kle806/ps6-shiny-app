# PS6 Shiny App Assignment
[Shiny App Link](https://utycvn-kelly-le.shinyapps.io/ps6-project/)


# Dataset information

The dataset covers four notable streaming services; Netflix, Hulu, Prime Video, and Disney+.

The dataset was collected through data scraping from these four streaming services in 2021 through early 2022 and published on [Kaggle](https://www.kaggle.com/datasets/ruchi798/movies-on-netflix-prime-video-hulu-and-disney)

It contains the entire movie catalog of the four streaming services, with information of the movie name, what year it was from, the age rating, Rotten tomatoes rating, and whether it was available on that particular service (represented with 1 or 0).

# App Details

The info panel contains details about the dataset and a sample of what it looks like.

The plot panel contains three widgets.

The first widget is a select list to choose what streaming service histogram to view.
The second and third widget are radio buttons to change the color gradient fill of the bins on the histogram that are related to the Rotten Tomatoes ratings of each movie.

The table panel contains one widget which is also a select list to choose what streaming service the table shows.
The table calculated the average rating of all movies produced in that specific year. Selecting a service filters the table results to only show the average ratings of movies in that year, in that specific service's catalog.
