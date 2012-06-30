# What This Does
This is a small script that will export comments out of a Drupal 6 database and into DISQUS compatible XML files. DISQUS does not allow XML files larger than 50MB, so this script will output files at around 45MB each.

# Limitations and Known Issues
I wrote this for a client that did not require threaded comments, thus this script will only export your comments as a flat, chronological thread.

I've only tested this on my own computer (Mac OS 10.7). It should work on any *nix OS with Ruby 1.9 and the requisite gems.

The Builder gem is supposed to check for correct UTF-8 encoding when building the XML file but I still encountered several comments that had encoding issues. Though [this gem might help](https://github.com/brianmario/charlock_holmes).

DISQUS has a limit of 25000 characters per comment body. The script will still export comments that are longer, but the DISQUS importer will ignore them.

# How To Use It
Place this code on the same server as your Drupal database. The script only needs the node and comments tables, so you can also just dump those to your local machine and run the script there.

First, make sure you have the required gems:
```shell
bundle install
```

Next, edit `config.example`, filling in your database credentials, and save the file as `config`.

Finally, run the script from inside the project directory.
```shell
ruby xml-export
```

The XML files will be generated and placed in the same directory as the script.

# Author
Jonathan Pichot
@jonpichot
http://jpichot.com

# License
Since this is my first open source code, I wasn't sure what license to choose. I settled on MIT since I understand it to be one of the more lenient licenses. If you ever do package this code, I'd appreciate attribution, but the license doesn't require it.