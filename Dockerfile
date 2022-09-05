FROM rockylinux:9 AS qemu_full_build

RUN dnf update -y
RUN dnf install -y rpmdevtools rpmlint rpmlib
RUN dnf groupinstall -y "Development Tools"
RUN dnf config-manager --set-enabled crb
RUN dnf install -y ninja-build glib2-devel libfdt-devel pixman-devel zlib-devel bzip2 ninja-build python3
COPY . /rhel-qemu-builder
WORKDIR /rhel-qemu-builder
ENTRYPOINT bash /rhel-qemu-builder/build.sh