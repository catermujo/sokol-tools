docker build . -t sokol-shdc
docker run --name shdc sokol-shdc
if [ "$(uname -m)" = "aarch64" ]; then
    PROFILE="linux-arm64-ninja-release"
else
    PROFILE="linux-x64-ninja-release"
fi
docker cp "shdc:/workspace/sokol-tools/.fibs/dist/${PROFILE}/sokol-shdc" .
docker rm shdc
docker rmi sokol-shdc
