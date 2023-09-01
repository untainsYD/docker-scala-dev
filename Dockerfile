FROM archlinux:base-devel

LABEL org.opencontainers.image.authors="untainsyd@gmail.com"

# Install necessary packages
RUN pacman-key --init && \
    pacman -Sy archlinux-keyring --noconfirm && sudo pacman -Su --noconfirm && \
    pacman -S --noconfirm reflector && \
    reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist && \
    pacman -Syy --noconfirm && \
    pacman -S --noconfirm git neovim bash gzip zip unzip

# Install and set up Java
RUN pacman -S jdk17-openjdk jdk11-openjdk jdk8-openjdk --noconfirm && \
    archlinux-java unset

# Create a non-root user
RUN echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && useradd -m -u 1000 -U -s /bin/bash www

# Install Paru AUR helper
#RUN git clone https://aur.archlinux.org/paru.git /home/www/paru && \
#     cd /home/www/paru && \
#     sed -i 's|sudo -u|fakeroot|g' PKGBUILD && \
#     makepkg -si

# Set shell
SHELL ["/bin/bash", "-c"]

# Switch to the non-root user
USER www

# Install tools
ENV PATH="/home/www/.local/share/coursier/bin:$PATH"
WORKDIR /home/www
RUN echo $HOME > /tmp/user \
    && curl -s "https://get.sdkman.io" | bash \
    && source "$HOME/.sdkman/bin/sdkman-init.sh" \
    && curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" | gzip -d > cs \
    && chmod +x cs && ./cs setup --yes && rm -rf cs \
    && yes | cs update && yes | cs java --jvm 11 && cs java --jvm 17 && eval "$(cs java --jvm 17 --env)" \
    && scala-cli install completions --shell bash

# Set the default command to keep the container running
CMD ["sleep", "infinity"]
