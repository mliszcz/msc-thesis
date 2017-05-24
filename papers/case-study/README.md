Building this paper:

1. extract <http://www.cai.sk/ojs/public/style/cai-style.zip> a new `./cai-style`
   directory:
   ```
   .
   ├── Makefile
   ├── README.md
   ├── cai-style
   │   ├── cai.cls
   │   └── my10.clo
   ├── my10.clo -> cai-style/my10.clo
   ├── tangojs-case-study.md
   └── template.tex
   ```

2. type `make all` (requires [latex](https://latex-project.org/) and
   [pandoc](https://pandoc.org/))

3. check for the paper in a generated `./build` directory
