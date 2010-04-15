# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2 java-webapp

DESCRIPTION="Private ebuild for java-webapps.eclass testing"
HOMEPAGE="http://localhost/"
SRC_URI="http://dev.gentoo.org/~nelchael/test-0.tar.bz2"

RESTRICT="mirror"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPS="
	dev-java/ant-core
	=dev-java/resin-servlet-api-3.0*
	dev-java/jdynamite
"

DEPEND="=virtual/jdk-1.5*
	${COMMON_DEPS}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPS}"

src_unpack() {

	unpack ${A}
	cd "${S}/lib"
	rm -f *.jar

	# This tests "normal" from:
	java-pkg_jar-from resin-servlet-api-2.4
	# This tests rename:
	java-pkg_jar-from jdynamite jdynamite.jar jd.jar
	# This doesn't record individual jar names:
	java-pkg_jar-from ant-core,ant-core
	# Get out-of-portage jars - tests missing jars:
	touch phony
	zip -q9 "${S}/lib/0000.jar" phony
	zip -q9 "${S}/lib/dddd.jar" phony
	zip -q9 "${S}/lib/zzzz.jar" phony


}

src_compile() {
	eant war || die "eant failed"
}

src_install() {

	java-webapp_newwar "${S}/test-0.war" "${PN}.war"
	use source && java-pkg_dosrc "${S}"/src/*

}
