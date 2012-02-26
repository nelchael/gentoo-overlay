# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

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

python_prepare_all() {
	sed -i \
		-e "s,'doc,# 'doc,g" \
		-e "s,'exa,# 'exa,g" \
		setup.py || die
}

python_install_all() {
	rm -f "${D}/usr/bin"/*.py || die

	python-distutils-ng_doscript scripts/runxlrd.py

	dohtml xlrd/doc/*.html
	if use examples; then
		insinto "/usr/share/doc/${PF}"
		doins -r xlrd/examples
	fi
}
