#!/bin/bash
#
# 2006, Krzysztof Pawlik - nelchael@gentoo.org
# 
# This script generates file for User Libraries import for Eclipse.
# You can find that option in:
#  Window -> Preferences -> Java -> Build Path -> User Libraries
#
# All your installed Java packages that register any jar are exported.
#

function get_name() {

	echo $(echo ${1} | sed -e 's,^.*/share/\(.*\)/package.env$,\1,')

}

function get_desc() {

	cat ${1} | grep ^DESCRIPTION | cut -d '=' -f 2- | sed -e 's/"//g' | sed -e 's,--,,g'

}

function get_libdir() {

	cat ${1} | grep ^LIBRARY_PATH | cut -d '=' -f 2- | sed -e 's/"//g'

}

function find_source() {

	find $(dirname ${1}) -name "*-src.zip" | head -n 1

}

echo '<?xml version="1.0" encoding="UTF-8"?>'
echo '<eclipse-userlibraries version="2">'

for package in /usr/share/*/package.env; do

	packageName=$(get_name ${package})

	echo '  <library name="'"${packageName}"'" systemlibrary="false">'
	echo '    <!-- '"$(get_desc ${package})"' -->'

	gotSource=no

	for jar in $(grep ^CLASSPATH ${package} | cut -d = -f 2- | sed -e 's/"//g' | sed -e 's/:/ /g'); do

		echo -n '    <archive path="'"${jar}"'"'

		if [[ -n "$(find_source ${package})" ]]; then
			echo -n ' source="'"$(find_source ${package})"'"'
			gotSource=yes
		fi

		if [[ -n "$(get_libdir ${package})" ]]; then
			echo -n ' nativelibpaths="'"$(get_libdir ${package})"'"'
		fi

		echo '/>'

	done

	[[ "${gotSource}" = "no" ]] && echo "Package without source: ${packageName}" >&2

	echo '  </library>'

done

echo '</eclipse-userlibraries>'
