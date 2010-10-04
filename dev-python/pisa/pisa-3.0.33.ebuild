# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Converter for HTML/XHTML and CSS to PDF"
HOMEPAGE="http://www.xhtml2pdf.com/"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/reportlab
	dev-python/html5lib
	dev-python/imaging"
DEPEND="${RDEPEND}"
