# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE=""

inherit java-pkg-2 java-ant-2 java-webapp

DESCRIPTION="Some blogging software"
HOMEPAGE="http://blojsom.sourceforge.net/"
SRC_URI="mirror://sourceforge/blojsom/${P}-source.zip"

LICENSE="BSD"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE=""

# I know, there are few bundled jars, but that's not important for java-webapp
# eclass and also it nicely shows the warning showed by java-webapp ;)
COMMON_DEPS="
	=dev-java/asm-3*
	=dev-java/cglib-2.1*
	=dev-java/commons-io-1*
	=dev-java/ehcache-1.2*
	=dev-java/hibernate-3.1*
	=dev-java/servletapi-2.4*
	dev-java/xmlrpc
	dev-java/antlr
	dev-java/c3p0
	dev-java/commons-codec
	dev-java/commons-collections
	dev-java/commons-dbcp
	dev-java/commons-fileupload
	dev-java/commons-logging
	dev-java/commons-pool
	dev-java/dom4j
	dev-java/jta
	dev-java/junit
	dev-java/log4j
	dev-java/sun-jaf
	dev-java/sun-javamail
	dev-java/velocity
"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEPS}"
RDEPEND=">=virtual/jdk-1.4
	${COMMON_DEPS}"

S="${WORKDIR}"

WEBAPP_OWNED_JARS="blojsom-core-3.1.jar
	blojsom-extensions-3.1.jar
	blojsom-plugins-3.1.jar
	blojsom-plugins-templates-3.1.jar
	blojsom-resources-3.1.jar"

src_unpack() {

	unpack ${A}

	cd "${S}/lib"
	rm -fv *.jar
	java-pkg_jar-from junit
	java-pkg_jar-from servletapi-2.4

	cd "${S}/war/WEB-INF/lib/"
	rm -fv activation*
	rm -fv antlr-*
	rm -fv asm-*
	rm -fv blojsom-*
	rm -fv c3p0*
	rm -fv cglib-*
	rm -fv commons-{codec,collections,dbcp,fileupload,io,logging,pool}*
	rm -fv dom4j*
	rm -fv ehcache-*
	rm -fv hibernate-*
	rm -fv jta*
	rm -fv log4j*
	rm -fv mail* smtp*
	rm -fv velocity*
	rm -fv xmlrpc-*
	java-pkg_jar-from antlr
	java-pkg_jar-from asm-3
	java-pkg_jar-from c3p0
	java-pkg_jar-from cglib-2.1
	java-pkg_jar-from commons-codec
	java-pkg_jar-from commons-collections
	java-pkg_jar-from commons-dbcp
	java-pkg_jar-from commons-fileupload
	java-pkg_jar-from commons-io-1
	java-pkg_jar-from commons-logging
	java-pkg_jar-from commons-pool
	java-pkg_jar-from dom4j-1
	java-pkg_jar-from ehcache-1.2
	java-pkg_jar-from hibernate-3.1
	java-pkg_jar-from jta
	java-pkg_jar-from log4j
	java-pkg_jar-from sun-jaf
	java-pkg_jar-from sun-javamail
	java-pkg_jar-from velocity
	java-pkg_jar-from xmlrpc

}

src_compile() {
	eant war
}

src_install() {
	java-webapp_dowar "${S}/distro/${PN}.war"
}
