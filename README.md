# felix-roske.de

This is the source of my website.

To publish:

``` shell
$ mkdocs build
$ aws s3 cp --recursive . s3://felix-roske.de/
