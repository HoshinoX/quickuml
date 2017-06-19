#!/bin/sh

if [ -f setup.lock ]; then echo >&2 "setup.lock"; exit 1; fi

# check requirements
requires=(
php
pear
composer
java
dot
)
for d in ${requires[*]}
do
    type $d >/dev/null 2>&1 || { echo >&2 "require $d installed"; exit 1; }
done
# check php version
php_ver=`php -v | grep built | awk '{print $2}'`
if [[ $php_ver < "5.6" ]]; then echo >&2 "require php >= 5.6"; exit 1; fi
echo "requires ok"

# setup dir
root=$(cd `dirname $0`; pwd)
mkdir -p $root/bin
mkdir -p $root/outputs

# intall phpuml
pear install PHP_UML
ln -fs $(pear config-show | grep bin_dir | awk '{print $5}')/phpuml $root/bin
echo "phpuml ok"

# intall php-plantumlwriter
composer require davidfuhr/php-plantumlwriter
ln -fs $root/vendor/bin/php-plantumlwriter $root/bin/php-plantumlwriter

# to enhanced with filter: https://github.com/davidfuhr/php-plantumlwriter/pull/6
wget -P vendor/davidfuhr/php-plantumlwriter/src/Flagbit/Plantuml/Command/ -c \
    https://raw.githubusercontent.com/Bladrak/php-plantumlwriter/filter_option/src/Flagbit/Plantuml/Command/WriteCommand.php
echo "php-plantumlwriter ok"

# intall plantuml
wget http://sourceforge.net/projects/plantuml/files/plantuml.jar
mv plantuml.jar bin/
echo "plantuml ok"

# create quickuml 
cat > $root/bin/quickuml << EOF
#!/bin/sh

bin=\$(cd \`dirname \$0\`; pwd)

if [[ \$1 == "" ]] || [[ \$2 == "" ]]
then 
    echo "usage: quickuml <src_dir> <name>"
    exit 1
fi

output_dir=\$(dirname \$bin)/outputs/\$2
mkdir -p \$output_dir

# generate puml from php src
php \$bin/php-plantumlwriter write \$1 --filter="*.php" > \$output_dir/\$2.puml
echo .

# generate uml diagram from puml
java -DPLANTUML_LIMIT_SIZE=8192 -jar \$bin/plantuml.jar \$output_dir/\$2.puml -o \$output_dir -nbthread auto -progress
echo .

# phpuml common options
phpuml_opts="-n \$2 -m *.php -l 0 --pure-object --no-deployment-view --no-component-view "

# generate html dosc from php src
mkdir -p \$output_dir/html
\$bin/phpuml \$1 -o \$output_dir/html -f html \$phpuml_opts
echo .

# generate xmi from php src
\$bin/phpuml \$1 -o \$output_dir -f xmi -x 2 \$phpuml_opts
echo .

echo "output in \$output_dir"

exit 0
EOF

# export bin/ to PATH
chmod +x $root/bin/quickuml
export PATH=$PATH:$bin
echo "quickuml ok"

touch setup.lock

echo "done"
exit 0