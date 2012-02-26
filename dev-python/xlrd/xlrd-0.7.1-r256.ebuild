# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

#USE_PYTHON="python25 python26 python27"
PYTHON_OPTIONAL="no"

inherit python-distutils-ng

DESCRIPTION="Library for developers to extract data from Microsoft Excel (tm) spreadsheet files"
HOMEPAGE="http://pypi.python.org/pypi/xlrd"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc-aix ~hppa-hpux ~ia64-hpux ~x86-interix ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="examples"

DEPEND=""
RDEPEND=""

python_unpack_all() {
	: echo " ### python_unpack_all ### (${@}) PYTHON=${PYTHON}"
	unpack ${A}	# Not needed
}

python_prepare_all() {
	: echo " ### python_prepare_all ### (${@}) PYTHON=${PYTHON}"
	sed -i \
		-e "s,'doc,# 'doc,g" \
		-e "s,'exa,# 'exa,g" \
		setup.py || die
}

python_prepare() {
	: echo " ### python_prepare ### (${@}) PYTHON=${PYTHON}"
}

python_configure() {
	: echo " ### python_configure ### (${@}) PYTHON=${PYTHON}"
}

python_compile() {
	: echo " ### python_compile ### (${@}) PYTHON=${PYTHON}"
	${PYTHON} setup.py build || die
}

python_test() {
	: echo " ### python_test ### (${@}) PYTHON=${PYTHON}"
}

python_install() {
	: echo " ### python_install ### (${@}) PYTHON=${PYTHON}"
	${PYTHON} setup.py install --no-compile --root="${D}/" || die
}

python_install_all() {
	: echo " ### python_install_all ### (${@}) PYTHON=${PYTHON}"
	rm -f "${D}/usr/bin"/*.py || die

	python-distutils-ng_doscript scripts/runxlrd.py

	dohtml xlrd/doc/*.html
	if use examples; then
		insinto "/usr/share/doc/${PF}"
		doins -r xlrd/examples
	fi
}
