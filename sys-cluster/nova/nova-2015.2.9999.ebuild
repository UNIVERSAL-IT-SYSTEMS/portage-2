# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1 eutils git-2 linux-info multilib user

DESCRIPTION="A cloud computing fabric controller (main part of an IaaS system) written in Python"
HOMEPAGE="https://launchpad.net/nova"
SRC_URI="https://dev.gentoo.org/~prometheanfire/dist/nova/liberty/nova.conf.sample -> liberty-nova.conf.sample"
EGIT_REPO_URI="https://github.com/openstack/nova.git"
EGIT_BRANCH="stable/liberty"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+compute compute-only iscsi +kvm +memcached mysql +novncproxy openvswitch postgres +rabbitmq sqlite test xen"
REQUIRED_USE="!compute-only? ( || ( mysql postgres sqlite ) )
						compute-only? ( compute !rabbitmq !memcached !mysql !postgres !sqlite )
						compute? ( ^^ ( kvm xen ) )"

CDEPEND=">=dev-python/pbr-1.8[${PYTHON_USEDEP}]"
# need to package dev-python/sphinxcontrib-seqdiag
DEPEND="
	>=dev-python/setuptools-16.0[${PYTHON_USEDEP}]
	${CDEPEND}
	app-admin/sudo
	test? (
		${RDEPEND}
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		<=dev-python/coverage-4.0[${PYTHON_USEDEP}]
		~dev-python/fixtures-1.3.1[${PYTHON_USEDEP}]
		>=dev-python/mock-1.2[${PYTHON_USEDEP}]
		<=dev-python/mock-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/mox3-0.7.0[${PYTHON_USEDEP}]
		<=dev-python/mox3-0.10.0[${PYTHON_USEDEP}]
		>=dev-python/psycopg-2.5[${PYTHON_USEDEP}]
		<=dev-python/psycopg-2.6.1[${PYTHON_USEDEP}]
		>=dev-python/pymysql-0.6.2[${PYTHON_USEDEP}]
		<=dev-python/pymysql-0.6.6[${PYTHON_USEDEP}]
		~dev-python/python-barbicanclient-3.3.0[${PYTHON_USEDEP}]
		>=dev-python/python-ironicclient-0.8.0[${PYTHON_USEDEP}]
		<=dev-python/python-ironicclient-0.8.1[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		<=dev-python/subunit-1.1.0[${PYTHON_USEDEP}]
		~dev-python/requests-mock-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		>=dev-python/pillow-2.4.0[${PYTHON_USEDEP}]
		<dev-python/pillow-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		<=dev-python/oslo-sphinx-3.2.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.10.0[${PYTHON_USEDEP}]
		<=dev-python/oslotest-1.11.0[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		<=dev-python/testrepository-0.0.20[${PYTHON_USEDEP}]
		>=dev-python/testresources-0.2.4[${PYTHON_USEDEP}]
		<=dev-python/testresources-0.2.7-r9999[${PYTHON_USEDEP}]
		>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		<=dev-python/testtools-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/tempest-lib-0.8.0[${PYTHON_USEDEP}]
		<=dev-python/tempest-lib-0.9.0[${PYTHON_USEDEP}]
		~dev-python/bandit-0.13.2[${PYTHON_USEDEP}]
		>=dev-python/oslo-vmware-0.16.0[${PYTHON_USEDEP}]
		<=dev-python/oslo-vmware-0.21.0[${PYTHON_USEDEP}]
	)"

# barbicanclient is in here for doc generation
RDEPEND="
	${CDEPEND}
	compute-only? (
		>=dev-python/sqlalchemy-0.9.9[${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.1.0[${PYTHON_USEDEP}]
	)
	sqlite? (
		>=dev-python/sqlalchemy-0.9.9[sqlite,${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.1.0[sqlite,${PYTHON_USEDEP}]
	)
	mysql? (
		dev-python/mysql-python
		>=dev-python/sqlalchemy-0.9.9[${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.1.0[${PYTHON_USEDEP}]
	)
	postgres? (
		dev-python/psycopg:2
		>=dev-python/sqlalchemy-0.9.9[${PYTHON_USEDEP}]
		<dev-python/sqlalchemy-1.1.0[${PYTHON_USEDEP}]
	)
	>=dev-python/boto-2.32.1[${PYTHON_USEDEP}]
	<=dev-python/boto-2.38.0[${PYTHON_USEDEP}]
	>=dev-python/decorator-3.4.0[${PYTHON_USEDEP}]
	<=dev-python/decorator-4.0.2[${PYTHON_USEDEP}]
	~dev-python/eventlet-0.17.4[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.6[${PYTHON_USEDEP}]
	<=dev-python/jinja-2.8[${PYTHON_USEDEP}]
	>=dev-python/keystonemiddleware-2.0.0[${PYTHON_USEDEP}]
	<=dev-python/keystonemiddleware-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/lxml-2.3[${PYTHON_USEDEP}]
	<=dev-python/lxml-3.4.4[${PYTHON_USEDEP}]
	>=dev-python/routes-1.12.3[${PYTHON_USEDEP}]
	!~dev-python/routes-2.0[${PYTHON_USEDEP}]
	!~dev-python/routes-2.1[$(python_gen_usedep 'python2_7')]
	<=dev-python/routes-2.2[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.0[${PYTHON_USEDEP}]
	<=dev-python/cryptography-1.0.1-r9999[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2.3[${PYTHON_USEDEP}]
	<=dev-python/webob-1.4.1[${PYTHON_USEDEP}]
	>=dev-python/greenlet-0.3.2[${PYTHON_USEDEP}]
	<=dev-python/greenlet-0.4.9[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.5.0-r1[${PYTHON_USEDEP}]
	<=dev-python/pastedeploy-1.5.2[${PYTHON_USEDEP}]
	<=dev-python/paste-2.0.2[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7[${PYTHON_USEDEP}]
	<dev-python/prettytable-0.8[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-migrate-0.9.6[${PYTHON_USEDEP}]
	<=dev-python/sqlalchemy-migrate-0.10.0[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.12[${PYTHON_USEDEP}]
	!~dev-python/netaddr-0.7.16[${PYTHON_USEDEP}]
	<=dev-python/netaddr-0.7.18[${PYTHON_USEDEP}]
	~dev-python/netifaces-0.10.4[${PYTHON_USEDEP}]
	>=dev-python/paramiko-1.13.0[${PYTHON_USEDEP}]
	<=dev-python/paramiko-1.15.2[${PYTHON_USEDEP}]
	>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
	<=dev-python/Babel-2.0[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.9[${PYTHON_USEDEP}]
	<=dev-python/iso8601-0.1.10[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/jsonschema-2.5.0[${PYTHON_USEDEP}]
	<dev-python/jsonschema-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-cinderclient-1.3.1[${PYTHON_USEDEP}]
	<=dev-python/python-cinderclient-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-1.6.0[${PYTHON_USEDEP}]
	<=dev-python/python-keystoneclient-1.7.2-r9999[${PYTHON_USEDEP}]
	>=dev-python/python-neutronclient-2.6.0[${PYTHON_USEDEP}]
	<=dev-python/python-neutronclient-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-glanceclient-0.18.0[${PYTHON_USEDEP}]
	<=dev-python/python-glanceclient-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-barbicanclient-3.0.1[${PYTHON_USEDEP}]
	<=dev-python/python-barbicanclient-3.3.0[${PYTHON_USEDEP}]
	~dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.5.0[${PYTHON_USEDEP}]
	<=dev-python/stevedore-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools-16.0[${PYTHON_USEDEP}]
	>=dev-python/websockify-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/websockify-0.6.1[${PYTHON_USEDEP}]
	<=dev-python/websockify-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-2.3.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-concurrency-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-2.3.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-config-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-0.2.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-context-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-1.8.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-log-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-reports-0.1.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-reports-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.4.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-serialization-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-2.0.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-utils-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-db-2.4.1[${PYTHON_USEDEP}]
	<=dev-python/oslo-db-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-rootwrap-2.0.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-rootwrap-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-messaging-1.16.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-1.17.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-messaging-1.17.1[${PYTHON_USEDEP}]
	<=dev-python/oslo-messaging-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.5.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-i18n-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-service-0.7.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-service-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/rfc3986-0.2.0[${PYTHON_USEDEP}]
	<=dev-python/rfc3986-0.2.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-middleware-2.8.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-middleware-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/psutil-1.1.1[${PYTHON_USEDEP}]
	<dev-python/psutil-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-versionedobjects-0.9.0[${PYTHON_USEDEP}]
	<=dev-python/oslo-versionedobjects-0.10.0[${PYTHON_USEDEP}]
	>=dev-python/alembic-0.8.0[${PYTHON_USEDEP}]
	<=dev-python/alembic-0.8.20[${PYTHON_USEDEP}]
	>=dev-python/os-brick-0.4.0[${PYTHON_USEDEP}]
	<=dev-python/os-brick-0.5.0[${PYTHON_USEDEP}]
	<=dev-python/libvirt-python-1.2.19[${PYTHON_USEDEP}]
	app-emulation/libvirt[iscsi?]
	novncproxy? ( www-apps/novnc )
	sys-apps/iproute2
	openvswitch? ( <=net-misc/openvswitch-2.4.0 )
	rabbitmq? ( net-misc/rabbitmq-server )
	memcached? ( net-misc/memcached
	<=dev-python/python-memcached-1.57 )
	sys-fs/sysfsutils
	sys-fs/multipath-tools
	net-misc/bridge-utils
	compute? (
		app-cdr/cdrkit
		kvm? ( app-emulation/qemu )
		xen? ( app-emulation/xen
			   app-emulation/xen-tools )
	)
	iscsi? (
		sys-fs/lsscsi
		>=sys-block/open-iscsi-2.0.872-r3
	)"

PATCHES=(
)

pkg_setup() {
	linux-info_pkg_setup
	CONFIG_CHECK_MODULES="BLK_DEV_NBD VHOST_NET IP6_NF_FILTER IP6_NF_IPTABLES IP_NF_TARGET_REJECT \
	IP_NF_MANGLE IP_NF_TARGET_MASQUERADE NF_NAT_IPV4 IP_NF_FILTER IP_NF_IPTABLES \
	NF_CONNTRACK_IPV4 NF_DEFRAG_IPV4 NF_NAT_IPV4 NF_NAT NF_CONNTRACK NETFILTER_XTABLES \
	ISCSI_TCP SCSI_DH DM_MULTIPATH DM_SNAPSHOT"
	if linux_config_exists; then
		for module in ${CONFIG_CHECK_MODULES}; do
			linux_chkconfig_present ${module} || ewarn "${module} needs to be enabled in kernel"
		done
	fi
	enewgroup nova
	enewuser nova -1 -1 /var/lib/nova nova
}

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_test() {
	testr init
	testr run --parallel || die "failed testsuite under python2.7"
}

python_install() {
	distutils-r1_python_install

	if use !compute-only; then
		for svc in api cert conductor consoleauth network scheduler spicehtml5proxy xvpvncproxy; do
			newinitd "${FILESDIR}/nova.initd" "nova-${svc}"
		done
	fi
	use compute && newinitd "${FILESDIR}/nova.initd" "nova-compute"
	use novncproxy && newinitd "${FILESDIR}/nova.initd" "nova-novncproxy"

	diropts -m 0750 -o nova -g qemu
	dodir /var/log/nova /var/lib/nova/instances
	diropts -m 0750 -o nova -g nova

	insinto /etc/nova
	insopts -m 0640 -o nova -g nova
	newins "${FILESDIR}/etc.liberty/api-paste.ini" "api-paste.ini"
	newins "${FILESDIR}/etc.liberty/cells.json" "cells.json"
	newins "${FILESDIR}/etc.liberty/logging_sample.conf" "logging_sample.conf"
	newins "${DISTDIR}/liberty-nova.conf.sample" "nova.conf.sample"
	newins "${FILESDIR}/etc.liberty/policy.json" "policy.json"
	newins "${FILESDIR}/etc.liberty/rootwrap.conf" "rootwrap.conf"
	#rootwrap filters
	insinto /etc/nova/rootwrap.d
	newins "${FILESDIR}/etc.liberty/rootwrap.d/api-metadata.filters" "api-metadata.filters"
	newins "${FILESDIR}/etc.liberty/rootwrap.d/compute.filters" "compute.filters"
	newins "${FILESDIR}/etc.liberty/rootwrap.d/network.filters" "network.filters"
	#copy migration conf file (not coppied on install via setup.py script)
	insopts -m 0644
	insinto /usr/$(get_libdir)/python2.7/site-packages/nova/db/sqlalchemy/migrate_repo/
	doins "nova/db/sqlalchemy/migrate_repo/migrate.cfg"
	#copy the CA cert dir (not coppied on install via setup.py script)
	cp -R "${S}/nova/CA" "${D}/usr/$(get_libdir)/python2.7/site-packages/nova/" || die "installing CA files failed"

	#add sudoers definitions for user nova
	insinto /etc/sudoers.d/
	insopts -m 0600 -o root -g root
	doins "${FILESDIR}/nova-sudoers"

	if use iscsi ; then
		# Install udev rules for handle iscsi disk with right links under /dev
		udev_newrules "${FILESDIR}/openstack-scsi-disk.rules" 60-openstack-scsi-disk.rules

		insinto /etc/nova/
		doins "${FILESDIR}/scsi-openscsi-link.sh"
	fi
}

pkg_postinst() {
	if use iscsi ; then
		elog "iscsid needs to be running if you want cinder to connect"
	fi
}
