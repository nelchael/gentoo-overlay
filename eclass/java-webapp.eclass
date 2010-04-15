# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: nelchael
# Purpose: contains common functions for Java web applications
#

inherit java-utils-2

DEPENDS="app-arch/zip
	app-arch/unzip"

# TODO: documentation
# TODO: list of supported servers?

# Keep this list sorted!
SUPPORTED_WEB_SERVERS="
	www-servers/jboss
	www-servers/jetty
	www-servers/resin
	www-servers/tomcat
"

EXPORT_FUNCTIONS pkg_postinst

function _resolve_symlink() {

	debug-print-function ${FUNCNAME} $*

	[[ -z "${1}" ]] && die "Missing symlink name"

	local fn="$(find "${S}" -type l -name "${1}")"
	[[ -z "${fn}" ]] && return
	readlink "${fn}" || die "readlink failed"

}

function _get_owning_package() {

	debug-print-function ${FUNCNAME} $*

	[[ -z "${1}" ]] && die "Missing jar name"
	grep "^${1}@" "${T}/java-pkg-depend" | cut -d '@' -f 2

}

function _ensure_owner() {

	debug-print-function ${FUNCNAME} $*

	[[ -z "${1}" ]] && die "Missing package name"
	[[ -n "$(grep -E "@?${1}" "${T}/java-pkg-depend")" ]]

}

function _postprocess_war() {

	debug-print-function ${FUNCNAME} $*

	[[ ${#} != 1 ]] && die "Missing argument!"

	if [[ -z "$(unzip -t "${1}" | grep WEB-INF/lib/)" ]]; then
		ewarn 'No WEB-INF/lib found in archive!'
		return
	fi

	echo ">>> Post processing $(basename "${1}") ..."

	local extract_dir="java-webapp-unpacked-${PN}-${SLOT}-${PV}"

	mkdir -p "${T}/${extract_dir}" || die "failed to create ${T}/${extract_dir}"

	cd "${T}/${extract_dir}/"
	unzip -qq "${1}" || die "failed to unpack war"

	cd WEB-INF/lib
	local unknown=

	for i in *.jar; do

		# Check if this jar is owned by package:
		if hasq "${i}" ${WEBAPP_OWNED_JARS}; then
			echo ">>> Package owned jar: ${i}, skipping"
			continue
		fi

		local destname="${i}"
		local owner=$(_get_owning_package "${i}")

		if [[ -z "${owner}" ]]; then

			# No owner -> try to find the original symlink in ${S}
			local original="$(_resolve_symlink "${i}")"
			if [[ -z "${original}" ]]; then
				unknown="${unknown} ${i}"
				echo ">>> No package owns ${i}, skipping"
				continue
			fi

			destname="$(basename "${original}")"
			owner="$(echo "${original}" | cut -d / -f 4)"

		fi

		_ensure_owner "${owner}" || die "Package ${owner} not recorded"

		rm -f "${i}" || die "rm \"${i}\" failed"
		echo ">>> Symlinking ${i} (${owner}) to WEB-INF/lib/"
		ln -s "/usr/share/${owner}/lib/${destname}" "${i}" || \
			die "failed to create symlink to \"${i}\""

	done

	local tmp_war="${T}/tmp-$(basename "${1}")"
	cd "${T}/${extract_dir}/"
	echo ">>> Recreating $(basename "${1}")"
	zip -qyr9 "${tmp_war}" * || die "zip failed"

	cd "${T}"
	rm -rf "${extract_dir}"

	rm -f "${1}" || die "failed to remove original war"
	mv "${tmp_war}" "${1}" || die "failed to move recreated war file"

	if [[ -n "${unknown}" ]]; then

		ewarn "Following java archives not owned by any installed package were"
		ewarn "found in web archive $(basename "${2}"):"
		ewarn
		for i in ${unknown}; do
			ewarn "    ${i}"
		done
		ewarn
		ewarn "If the archives above were built by ${CATEGORY}/${P} they should"
		ewarn "be added to WEBAPP_OWNED_JARS in ebuild, if these are"
		ewarn "a third-party libraries then this is a bug, please report"
		ewarn "this to http://bugs.gentoo.org/"

	fi

}

function java-webapp_newwar() {

	debug-print-function ${FUNCNAME} $*

	[[ -z "${1}" ]] && die "Missing old war file name"
	[[ -z "${2}" ]] && die "Missing new war file name"

	local newname="$(basename "${2}")"

	java-pkg_init_paths_

	dodir "${JAVA_PKG_WARDEST}"
	insinto "${JAVA_PKG_WARDEST}"
	newins "${1}" "${newname}"

}

function java-webapp_dowar() {

	[[ -z "${1}" ]] && die "Missing war file name"
	java-webapp_newwar "${1}" "$(basename "${1}")"

}

function post_src_install() {

	java-pkg_init_paths_

	for i in $(find "${D}/${JAVA_PKG_WARDEST}" -name '*.war' | sort); do
		_postprocess_war "${i}"
	done

}

function java-webapp_pkg_postinst() {

	elog "To use this web application create a symlink to installed .war file"
	elog "in server webapps directory."

	local foundServer=no
	for i in ${SUPPORTED_WEB_SERVERS}; do
		has_version "${i}" && foundServer=yes
	done

	if [[ "${foundServer}" = "no" ]]; then

		elog
		elog "It looks like you don't have any supported web server installed,"
		elog "please emerge one of:"
		for i in ${SUPPORTED_WEB_SERVERS}; do
			elog "    ${i}"
		done

	fi

}
