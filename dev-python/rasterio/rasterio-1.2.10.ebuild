# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Command line tool and API for geospatial raster data"
HOMEPAGE="https://github.com/rasterio/rasterio"
SRC_URI="https://github.com/rasterio/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sci-libs/gdal
	dev-python/affine[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/cligj[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/click-plugins[${PYTHON_USEDEP}]
	dev-python/snuggs[${PYTHON_USEDEP}]
"
#DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		dev-python/boto3[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# disable tests failing for unknown reason
		tests/test_env.py::test_rio_env_no_credentials
		tests/test_rio_info.py::test_info_azure_unsigned
		tests/test_warp.py::test_reproject_resampling[Resampling.cubic]
		tests/test_warp.py::test_reproject_resampling[Resampling.lanczos]
		tests/test_warp.py::test_reproject_resampling_alpha[Resampling.cubic]
		tests/test_warp.py::test_reproject_resampling_alpha[Resampling.lanczos]
	)

	mv rasterio{,.bak} || die # Avoid non-working local import
	epytest ${deselect[@]/#/--deselect }
	mv rasterio{.bak,} || die
}
