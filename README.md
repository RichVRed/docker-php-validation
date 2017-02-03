## PHP_Depend - This tool shows you the quality of your design in the terms of extensibility, reusability and maintainability.
[![Docker Pulls](https://img.shields.io/docker/pulls/rvannauker/pdepend.svg)](https://hub.docker.com/r/vannauker/pdepend/) [![Docker Stars](https://img.shields.io/docker/stars/rvannauker/pdepend.svg)](https://hub.docker.com/r/rvannauker/pdepend/) [![](https://images.microbadger.com/badges/image/rvannauker/pdepend:latest.svg)](https://microbadger.com/images/rvannauker/pdepend:latest) [![GitHub issues](https://img.shields.io/github/issues/RichVRed/docker-php-validation.svg)](https://github.com/RichVRed/docker-php-validation) [![license](https://img.shields.io/github/license/RichVRed/docker-php-validation.svg)](https://tldrlegal.com/license/mit-license)
Docker container to install and run pdepend

### Installation / Usage
1. Install the rvannauker/pdepend container:
```bash
docker pull rvannauker/pdepend
```
2. Run pdepend through the pdepend container:
```bash
sudo docker run --rm --volume $(pwd):/workspace --name="pdepend" "rvannauker/pdepend" {destination}
```

### Download the source:
To run, test and develop the PDEPEND Dockerfile itself, you must use the source directly:
1. Download the source:
```bash
git clone https://github.com/RichVRed/docker-php-validation.git
```
2. Build the container:
```bash
sudo docker build --force-rm --tag "rvannauker/pdepend" --file php-coulping-detector.dockerfile .
```
3. Test running the container:
```bash
 $ docker run rvannauker/pdepend --help
```