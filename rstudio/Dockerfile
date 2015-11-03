FROM rocker/rstudio

MAINTAINER Patrick Wiener <patrick.wiener[at]hs-karlsruhe.de>

# User config and supervisord for persistent RStudio session
# userconf.sh has been modified in comparison to the original
# work of rocker. It instantiates specific user for the use of
# RStudio.
COPY userconf.sh /usr/bin/userconf.sh

EXPOSE 8787

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
