## ⚠️ Deprecated ⚠️

Inspired by the essence of this project I created [GGFilter.com](http://ggfilter.com/), which has similar goals of helping you find games, but with a greater scope and infrastructure.

---

### PlaytimeForTheBuck Builder

Builder app that binds the `ptb-scrapper` and the `ptb-frontend` together and handles the automatic tasks.

As it is, it requires to have the `ptb-frontend` and the `ptb-scrapper` on the parent directory, because on the Gemfile I haven't added the Git reference to pull them from here.

```bash
rake -T
rake cronjob                  # Scrap, build, cache, copy, commit and push!
rake generate_site            # Generate the _site with all the things
rake push_to_git              # Push the Jekyll-generated website
rake scrap                    # Scrap everything
rake scrapper:games           # Scrap each game to get the categories and other stuff
rake scrapper:games_list      # Scrap the games list to get new games, prices, and stuff
rake scrapper:migrations      # Create migration files
rake scrapper:reviews         # Scrap the reviews for each game
rake scrapper:summary         # Save summary
rake site:cache               # Renders the app on a headless browser and extract the table conte...
rake site:copy_md5_summary    # Rename the summary file, games.json to add the md5 on the file name
rake site:inject_md5_summary  # Add summary file md5 to index.html
rake site:jekyll              # Builds the front end website with Jekylls
```

### About

Made by Zequez on it's free time. GPLv2 licence.
