
<!--#echo json="package.json" key="name" underline="=" -->
eslint-pretty-pmb
=================
<!--/#echo -->

<!--#echo json="package.json" key="description" -->
Helps me invoke eslint with eslint-formatter-pretty.
<!--/#echo -->

  * Detects path to `eslint-formatter-pretty`
  * Injects a corresponding `--format=` option.
  * If you gave no CLI arguments at all, instead of lecturing you,
    it will assume you meant the current directory.
  * On exit without any messages, tells you explicitly whether it succeeded.



Usage
-----

```bash
$ elp
+OK no messages
```



<!--#toc stop="scan" -->


License
-------
<!--#echo json="package.json" key=".license" -->
ISC
<!--/#echo -->
