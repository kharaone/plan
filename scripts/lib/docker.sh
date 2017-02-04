# Lists the name of the running containers
docker_containers() {
    docker ps --format '{{.Names}}'
}
