# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# ebuild generated by hackport 0.6.6.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="restricting the servers that http-client will use"
HOMEPAGE="https://hackage.haskell.org/package/http-client-restricted"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/connection-0.2.5:=[profile?]
	dev-haskell/data-default:=[profile?]
	>=dev-haskell/http-client-0.6:=[profile?] <dev-haskell/http-client-0.7:=[profile?]
	>=dev-haskell/http-client-tls-0.3.2:=[profile?] <dev-haskell/http-client-tls-0.4:=[profile?]
	>=dev-haskell/network-3.0.0.0:=[profile?]
	dev-haskell/network-bsd:=[profile?]
	dev-haskell/utf8-string:=[profile?]
	>=dev-lang/ghc-8.4.3:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.2.0.1
"
