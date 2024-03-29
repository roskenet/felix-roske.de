AUTHOR = 'Felix Roske'
SITENAME = "Felix' Website"
SITEURL = 'http://localhost:8000'

THEME = './themes/MinimalXY'

PATH = 'content'
STATIC_PATHS = ['static']

TIMEZONE = 'Europe/Berlin'

DEFAULT_LANG = 'de'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# MARKDOWN = ['codehilite(css_class=highlight)','extra']

DEFAULT_PAGINATION = 10

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True

# Theme customizations
MINIMALXY_CUSTOM_CSS = 'static/custom.css'
MINIMALXY_FAVICON = 'favicon.ico'
# MINIMALXY_START_YEAR = 2021
MINIMALXY_CURRENT_YEAR = 2023

# Author
AUTHOR_INTRO = u'Ein Sammelsurium von Vielem.'
AUTHOR_DESCRIPTION = u'Felix\' Website befasst sich mit Allem und mit Nichts richtig.'
AUTHOR_AVATAR = '/images/felix.png'
AUTHOR_WEB = 'http://felix-roske.de'

# Services
#GOOGLE_ANALYTICS = 'UA-12345678-9'
#DISQUS_SITENAME = 'johndoe'

# Social
SOCIAL = (
    ('facebook', 'http://www.facebook.com/felix_roske'),
    ('github', 'https://github.com/roskenet'),
    ('flickr', 'https://www.flickr.com/photos/197338452@N05'),
    ('instagram', 'https://www.instagram.com/roskefelix'),
    ('pinterest', 'https://www.pinterest.de/felixroske/_created/'),
)

# Menu
MENUITEMS = (
   ('Tags', '/tags.html'),
)
