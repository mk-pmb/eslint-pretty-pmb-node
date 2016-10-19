
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



Oddities
========

  * npm reports `requires a peer of eslint@* but none was installed.`
    even with eslint 3.8.0 installed. No idea. npm's
    [package.json docs](https://docs.npmjs.com/files/package.json#dependencies)
    explicitly state that `*` "Matches any version".

  * Giving a non-existing path results in `+OK no messages`.
    That's correct behavior for this module, because when I run
    eslint v3.8.1 on `/404/nope/doesnt_exist.js`,
    it exists with no output and exit code 0.







License
-------
<!--#echo json="package.json" key=".license" -->
ISC
<!--/#echo -->
