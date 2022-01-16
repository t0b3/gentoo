# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="API for reading/writing vector geospatial data"
HOMEPAGE="https://github.com/Toblerity/fiona"
SRC_URI="https://github.com/Toblerity/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/click-plugins[${PYTHON_USEDEP}]
	dev-python/cligj[${PYTHON_USEDEP}]
	dev-python/munch[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? ( dev-python/boto3[${PYTHON_USEDEP}] )
"

S="${WORKDIR}/Fiona-${PV}"

distutils_enable_tests --install pytest

python_test() {
	local deselect=(
		# disable tests due to networking blocked
		tests/test_vfs.py::test_open_http
		tests/test_vfs.py::test_open_zip_https
		tests/test_collection.py::test_collection_http
		tests/test_collection.py::test_collection_zip_http
		# disable tests failing due to deprecated GDAL features
		tests/test_data_paths.py::test_gdal_data_wheel
		tests/test_data_paths.py::test_proj_data_wheel
		tests/test_data_paths.py::test_env_gdal_data_wheel
		tests/test_data_paths.py::test_env_proj_data_wheel
		tests/test_datetime.py::test_datefield[GPSTrackMaker-datetime]
		tests/test_datetime.py::test_datefield_null[GPSTrackMaker-datetime]
		tests/test_drvsupport.py::test_write_or_driver_error[GPSTrackMaker]
		tests/test_drvsupport.py::test_no_append_driver_cannot_append[GPSTrackMaker]
		# disable tests failing for unknown reason
		tests/test_drvsupport.py::test_no_append_driver_cannot_append[PCIDSK]
		tests/test_drvsupport.py::test_write_or_driver_error[DGN]
	)

	mv fiona{,.bak} || die # Avoid non-working local import
	epytest ${deselect[@]/#/--deselect }
	mv fiona{.bak,} || die
}
