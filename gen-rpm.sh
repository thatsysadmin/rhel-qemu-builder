#!/bin/sh

# Export filepaths
export BUILDDIR=/qemu_full/build
export BUILDROOT=~/rpmbuild/
export RPMSRC=~/rpmbuild/SOURCES
export RPMSPEC=~/rpmbuild/SPECS
export RPMBUILD=~/rpmbuild/BUILD

# Check if user's rpmbuild folder is there, if so, temoprairly rename it.
if [ -d ~/rpmbuild ]; then
	echo "Backing up rpmbuild"
	~/rpmbuild ~/rpmbuild.bkp
	export RPMBUILDEXISTS=TRUE
else
	export RPMBUILDEXISTS=FALSE
fi

# Create rpmbuild folder structure
mkdir ~/rpmbuild
mkdir ~/rpmbuild/BUILD
mkdir ~/rpmbuild/BUILDROOT
mkdir ~/rpmbuild/RPMS
mkdir ~/rpmbuild/SOURCES
mkdir ~/rpmbuild/SPECS
mkdir ~/rpmbuild/SRPMS

# Create qemu_full .spec file with preinstall and postinstall scripts
cat << 'EOF' > $RPMSPEC/qemu_full.spec
Name:           qemu_full
Version:        0.0.1
Release:        1%{?dist}
Summary:        full qemu build for rhel9
BuildArch:      x86_64

License:        GPLv3
URL:            https://github.com/thatsysadmin/rhel-qemu-builder
Source0:        qemu_full-0.0.1_bin.tar.gz

Requires:       bash

%description
(h)top like task monitor for AMD and NVIDIA GPUs. It can handle multiple GPUs and print information about them in a htop familiar way.

%prep
%setup -q

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/%{_bindir}
cp qemu_full $RPM_BUILD_ROOT/%{_bindir}/qemu-system-x86_64

%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_bindir}/qemu-system-x86_64

%changelog
* Sat Mar 12 2022 h <65380846+thatsysadmin@users.noreply.github.com>
- Initial packaging of qemu_full.
EOF

# Copy over qemu_full binary and supplemental files into rpmbuild/BUILD/
mkdir genrpm
mkdir genrpm/qemu_full-0.0.1
#ls /qemu_full/build/src/
cp /qemu_full/build/src/qemu-system-x86_64 genrpm/qemu_full-0.0.1/qemu-system-x86_64
cd genrpm

# tarball everything as if it was a source file for rpmbuild
tar --create --file qemu_full-0.0.1_bin.tar.gz qemu_full-0.0.1/
mv qemu_full-0.0.1_bin.tar.gz ~/rpmbuild/SOURCES

# Use rpmbuild to build the RPM package.
rpmlint ~/rpmbuild/SPECS/qemu_full.spec
QA_RPATHS=$(( 0x0001|0x0010 )) rpmbuild -bb $RPMSPEC/qemu_full.spec

# Move RPM package into pickup location
mv ~/rpmbuild/RPMS/x86_64/qemu_full-0.0.1-1.fc*.x86_64.rpm /qemu_full/qemu_full.rpm

# Clean up; delete the rpmbuild folder we created and move back the original one
if [ "$RPMBUILDEXISTS" == "TRUE" ]; then
        echo "Removing and replacing original rpmbuild folder."
        rm -rf ~/rpmbuild
        mv ~/rpmbuild.bkp ~/rpmbuild
fi
exit 0