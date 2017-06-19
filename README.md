# Quickuml

A tool to create uml, xmi, html documents from php source codes, based on:
[php-plantumlwriter](https://github.com/davidfuhr/php-plantumlwriter), 
[plantuml](https://github.com/plantuml/plantuml), 
[PHP_UML](http://pear.php.net/package/PHP_UML).

Requirements
-----------
* php >= 5.6
* pear
* composer
* java
* [graphviz-dot](http://www.graphviz.org/Home.php)

Run `setup.sh` to setup `quickuml` command.

Usage
----------
Run `quickuml <source_dir> <name>` to generate everything into `outputs/<name>`.

Example:
``` shell
$ quickuml vendor/symfony/console/Output/ demo
```
would produce `outputs/demo/demo.png`.
![Markdown](http://i2.muimg.com/597980/4479aec6a3e3346f.png)

Future Works
----------
* Add support for options to `quickuml` command.




