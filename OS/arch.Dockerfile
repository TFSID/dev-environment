# Use Arch Linux as the base image
FROM archlinux:latest


# Add a known good mirrorlist
# RUN echo "Server = http://mirrors.edge.kernel.org/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

# # Install reflector to update mirror list
# RUN pacman -Sy --noconfirm reflector sudo && \
#     pacman -Scc --noconfirm

# # Update the mirror list
# RUN reflector --country $(curl -s https://ipinfo.io/country) --age 12 --sort rate --save /etc/pacman.d/mirrorlist


# Install necessary packages
# RUN pacman -Syu --noconfirm \
#     sudo \
#     openssh \
#     vim \
#     git \
#     base-devel \
#     && pacman -Scc --noconfirm

RUN pacman -Syu --noconfirm sudo && pacman -Scc --noconfirm
RUN pacman -Syu --noconfirm openssh && pacman -Scc --noconfirm
RUN pacman -Syu --noconfirm vim && pacman -Scc --noconfirm
RUN pacman -Syu --noconfirm git && pacman -Scc --noconfirm
RUN pacman -Syu --noconfirm base-devel && pacman -Scc --noconfirm
# Enable and start SSH service
RUN systemctl enable sshd
# Create a developer user and group
RUN groupadd devgroup && useradd -m developer -g devgroup -G wheel

# Set a password for the developer user
RUN echo 'developer:password' | chpasswd

# Allow the developer user to use sudo without a password
RUN echo 'developer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set up the SSH server
RUN mkdir /var/run/sshd \
&& ssh-keygen -A \
&& echo 'PermitRootLogin no' >> /etc/ssh/sshd_config \
&& echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config \
&& echo 'AllowUsers developer' >> /etc/ssh/sshd_config

# Create a structured workspace folder
RUN mkdir -p /workspace \
&& chown developer:devgroup /workspace

# Expose SSH port
EXPOSE 22



# Set the working directory
WORKDIR /workspace

# Switch to the developer user

USER developer
RUN systemctl start sshd
# Start the SSH service
# CMD ["/usr/sbin/sshd", "-D"]
