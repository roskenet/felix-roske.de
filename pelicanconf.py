AUTHOR = 'Felix Roske'
SITENAME = "Felix' Website"
SITESUBTITLE = "Nichts Wichtiges"
SITEURL = "http://localhost:8000"
ABOUT = "Meine völlig sinnlose Seite auf der ich meine Gedanken ordne."
DEFAULT_IMAGE = "airport1.jpg"

PATH = "content"

THEME = "./theme"

TIMEZONE = 'Europe/Berlin'

DEFAULT_LANG = 'de'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = (
    ("Pelican", "https://getpelican.com/"),
    ("Python.org", "https://www.python.org/"),
    ("Jinja2", "https://palletsprojects.com/p/jinja/"),
    ("You can modify those links in your config file", "#"),
)

# Social widget
SOCIAL = (
    ('facebook', 'http://www.facebook.com/felix_roske'),
    ('github', 'https://github.com/roskenet'),
    ('flickr', 'https://www.flickr.com/photos/197338452@N05'),
    ('instagram', 'https://www.instagram.com/roskefelix'),
    ('pinterest', 'https://www.pinterest.de/felixroske/_created/'),
)

DEFAULT_PAGINATION = 5

TYPOGRIFY = True

DEFAULT_DATE_FORMAT = '%a %d %B %Y'

# Uncomment following line if you want document-relative URLs when developing
# RELATIVE_URLS = True

from functools import partial
JINJA_FILTERS = {
    'sort_by_article_count': partial(
        sorted,
        key=lambda tags: len(tags[1]),
        reverse=True)} # reversed for descending order