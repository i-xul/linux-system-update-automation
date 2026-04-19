#!/usr/bin/env bash

set -euo pipefail

echo "🔧 Preparing environment..."
export DEBIAN_FRONTEND=noninteractive

has() { command -v "$1" >/dev/null 2>&1; }

apt_update() {
    sudo apt update -y >/dev/null 2>&1 || sudo apt update -y
}

# ----------------------------
# 1) APT
# ----------------------------
echo "🔄 [1/6] Updating APT packages..."
apt_update

if ! sudo apt -y full-upgrade; then
    echo "⚠️ full-upgrade failed, falling back to upgrade..."
    sudo apt -y upgrade
fi

sudo apt -y autoremove --purge
echo "✅ APT update complete."

# ----------------------------
# 2) Snap
# ----------------------------
echo -e "\n🔄 [2/6] Updating Snap packages..."
if has snap; then
    sudo snap refresh || echo "⚠️ Snap update failed."
    echo "✅ Snap update complete."
else
    echo "ℹ️ Snap is not installed."
fi

# ----------------------------
# 3) Flatpak
# ----------------------------
echo -e "\n🔄 [3/6] Updating Flatpak packages..."
if has flatpak; then
    flatpak update -y || echo "⚠️ Flatpak update failed."
    echo "✅ Flatpak update complete."
else
    echo "ℹ️ Flatpak is not installed."
fi

# ----------------------------
# 4) pipx
# ----------------------------
echo -e "\n🔄 [4/6] Updating pipx packages..."
if has pipx; then
    if has jq; then
        pipx list --json | jq -r '.venvs | keys[]' | while read -r pkg; do
            [ -n "$pkg" ] || continue
            echo "⬆️ Updating $pkg..."
            pipx upgrade "$pkg" || echo "⚠️ Failed to update $pkg."
        done
    else
        echo "ℹ️ jq not found, using fallback listing."
        pipx list --short | awk '{print $1}' | while read -r pkg; do
            [ -n "$pkg" ] || continue
            echo "⬆️ Updating $pkg..."
            pipx upgrade "$pkg" || echo "⚠️ Failed to update $pkg."
        done
    fi
    echo "✅ pipx update complete."
else
    echo "ℹ️ pipx is not installed."
fi

# ----------------------------
# 5) Docker
# ----------------------------
echo -e "\n🔄 [5/6] Updating Docker and images..."
if has docker; then
    echo "🧱 Docker version: $(docker --version 2>/dev/null || echo 'unknown')"

    echo "📊 Docker disk usage (before):"
    sudo docker system df || echo "⚠️ Failed to read Docker usage."

    if dpkg -l | grep -q '^ii\s\+docker-ce'; then
        echo "⏳ Updating docker-ce..."
        sudo apt install --only-upgrade -y docker-ce docker-ce-cli containerd.io \
            || echo "⚠️ docker-ce update failed."
    elif dpkg -l | grep -q '^ii\s\+docker.io'; then
        echo "⏳ Updating docker.io..."
        sudo apt install --only-upgrade -y docker.io containerd \
            || echo "⚠️ docker.io update failed."
    else
        echo "ℹ️ Docker installation type not recognized."
    fi

    echo "⬇️ Pulling latest images..."
    sudo docker images --format '{{.Repository}}:{{.Tag}}' | grep -v '<none>' | sort -u | while read -r image; do
        [ -n "$image" ] || continue
        echo "🔄 Updating $image"
        sudo docker pull "$image" || echo "⚠️ Failed to pull $image"
    done

    echo "🧹 Cleaning unused Docker images..."
    sudo docker image prune -a -f || echo "⚠️ Docker cleanup failed."

    echo "📊 Docker disk usage (after):"
    sudo docker system df || echo "⚠️ Failed to read Docker usage."

    echo "✅ Docker update complete."
else
    echo "ℹ️ Docker is not installed."
fi

# ----------------------------
# 6) Git
# ----------------------------
echo -e "\n🔄 [6/6] Updating Git repositories in home directory..."
find "$HOME" -type d -name ".git" 2>/dev/null | while read -r gitdir; do
    repo=$(dirname "$gitdir")
    echo "📁 $repo"

    if [ -d "$repo/.git" ]; then
        echo "➡️  git -C \"$repo\" pull --rebase --autostash"
        git -C "$repo" pull --rebase --autostash \
            || echo "⚠️ git pull failed: $repo"
    fi
done

echo "✅ Git updates complete."

# ----------------------------
# Done
# ----------------------------
echo -e "\n🎉 All updates completed!"

echo -e "\n💾 Disk usage:"
df -h /
