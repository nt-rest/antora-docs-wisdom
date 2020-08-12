CMD /C antora generate --clean playbook.yml

COPY /y index.html .\..\nt-rest.github.io\docs\
COPY /y CNAME      .\..\nt-rest.github.io\docs\
COPY /y NUL        .\..\nt-rest.github.io\docs\.nojekyll

