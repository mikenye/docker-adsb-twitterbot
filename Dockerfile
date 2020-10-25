FROM debian:stable-slim

ENV URL_OVERPUTNEY_REPO="https://github.com/shbisson/OverPutney.git" \
    PATH_OVERPUTNEY="/opt/overputney" \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -x && \
    TEMP_PACKAGES=() && \
    KEPT_PACKAGES=() && \
    # Deploy git (for cloning OverPutney)
    TEMP_PACKAGES+=(git) && \
    # Dependencies for OverPutney
    KEPT_PACKAGES+=(ca-certificates) && \
    KEPT_PACKAGES+=(chromium-driver) && \
    KEPT_PACKAGES+=(gawk) && \
    KEPT_PACKAGES+=(python3) && \
    TEMP_PACKAGES+=(python3-pip) && \
    TEMP_PACKAGES+=(python3-setuptools) && \
    TEMP_PACKAGES+=(python3-wheel) && \
    # Dependencies for s6-overlay
    TEMP_PACKAGES+=(curl) && \
    TEMP_PACKAGES+=(gnupg2) && \
    TEMP_PACKAGES+=(file) && \
    # Install packages
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ${KEPT_PACKAGES[@]} \
        ${TEMP_PACKAGES[@]} \
        && \
    git config --global advice.detachedHead false && \
    # Deploy OverPutney
    git clone "$URL_OVERPUTNEY_REPO" "$PATH_OVERPUTNEY" && \
    pushd "$PATH_OVERPUTNEY" && \
    pip3 install -r requirements.txt && \
    popd && \
    # Deploy s6-overlay
    curl -s https://raw.githubusercontent.com/mikenye/deploy-s6-overlay/master/deploy-s6-overlay.sh | sh && \
    # Clean-up
    apt-get remove -y ${TEMP_PACKAGES[@]} && \
    apt-get autoremove -y && \
    rm -rf /src/* /tmp/* /var/lib/apt/lists/*

# Copy config files
COPY rootfs/ /

# Set s6 init as entrypoint
ENTRYPOINT [ "/init" ]
