FROM rockylinux:9 AS qemu_full_build

RUN dnf update -y
RUN dnf install -y cmake ncurses-devel wget rpmdevtools rpmlint
COPY . /rhel-qemu-builder
WORKDIR /rhel-qemu-builder
ENTRYPOINT bash /rhel-qemu-builder/build.sh