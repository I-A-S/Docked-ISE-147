# Use an older 32-bit compatible Ubuntu base image
FROM ubuntu:18.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install all the 32-bit and other dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
    build-essential \
    libz1:i386 \
    libncurses5:i386 \
    libbz2-1.0:i386 \
    libstdc++6:i386 \
    libtinfo5 \
    libgdk-pixbuf2.0-0:i386 \
    libcairo2:i386 \
    libexpat1:i386 \
    libfontconfig1:i386 \
    libfreetype6:i386 \
    libglib2.0-0:i386 \
    libice6:i386 \
    libjpeg8:i386 \
    libpng16-16:i386 \
    libsm6 \
    libsm6:i386 \
    libx11-6:i386 \
    libxau6:i386 \
    libxcomposite1:i386 \
    libxcursor1:i386 \
    libxdamage1:i386 \
    libxdmcp6:i386 \
    libxext6:i386 \
    libxfixes3:i386 \
    libxi6:i386 \
    libxinerama1:i386 \
    libxrandr2:i386 \
    libxrender1:i386 \
    libxtst6:i386 \
    libgtk2.0-0:i386 \
    wget \
    gawk \
    git \
    make \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the resources into the image
COPY Resources/Xilinx_ISE_DS_Lin_14.7_1015_1.tar /tmp/
COPY Resources/install.sh /tmp/

# Run the batch installer
RUN cd /tmp && \
    tar xf Xilinx_ISE_DS_Lin_14.7_1015_1.tar && \
    cd Xilinx_ISE_DS_Lin_14.7_1015_1 && \
    bin/lin64/batchxsetup -batch /tmp/install.sh

# Source xilinx env/settings for interactive sessions
RUN echo "source /opt/Xilinx/14.7/ISE_DS/settings64.sh" >> /root/.bashrc

# Create a wrapper script to source the xilinx env/settings
RUN echo '#!/bin/bash' > /opt/xilinx_run.sh && \
    echo 'source /opt/Xilinx/14.7/ISE_DS/settings64.sh' >> /opt/xilinx_run.sh && \
    echo 'export PATH=$PATH:/opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64' >> /opt/xilinx_run.sh && \
    echo 'exec "$@"' >> /opt/xilinx_run.sh && \
    chmod +x /opt/xilinx_run.sh

# Set the working directory for when container starts
WORKDIR /workspace

# Set the default entrypoint to the wrapper script
ENTRYPOINT ["/opt/xilinx_run.sh"]
