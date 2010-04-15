# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit ruby git

DESCRIPTION="RCS parsing library for Ruby"
HOMEPAGE="http://gitorious.org/fromcvs"
SRC_URI=""

EGIT_REPO_URI="git://gitorious.org/fromcvs/rcsparse.git"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"
