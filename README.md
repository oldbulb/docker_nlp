![だいたい10分でざっくり押さえるDockerの基本 – WPJ](https://cdn.webprofessional.jp/wp-content/uploads/sites/2/2016/12/01095655/1480553813_image2.png)

# 1. Guideline of docker NLP images

## 1.1 List of images and containers

- **Images**

| Name             | Id             | Tag                               | Maitainer |
| ---------------- | -------------- | --------------------------------- | --------- |
| `workspace/nlp ` | `c6fb050916dc` | `python3.8-pytorch1.8-v1.0`       | ZHAO_Ming |
| `nvidia/cuda`    |                | `11.2.0-cudnn8-devel-ubuntu20.04` | Nvidia    |
| `ubuntu`         |                | `20.04`                           | ubuntu    |
|                  |                |                                   |           |

- **Containers**

| Name                       | Image          | Port                     | Volume                                                   |
| :------------------------- | -------------- | ------------------------ | -------------------------------------------------------- |
| `workspace-$username-$tag` | `c6fb050916dc` | `49153:8888`, `49154:22` | `/home/[$Username]/workspace_$tag:/home/workspace_$tag ` |
|                            |                |                          |                                                          |
|                            |                |                          |                                                          |

> Base images: `workspace/nlp:python3.8-pytorch1.8-v1.0`
>
> Please use your `$username` in standand format and date(recommended) as  `$tag` 
>
> You are free to creat your own images by `docker commit` containers or by `docker build` via `Dockerfile`. It will be very nice to share your contribution. 

------

## 1.2 Command for `docker run` 

```shell
$ chmod a+x docker_run.sh # execute permission
$ ./docker_run.sh $username $tag $image_id 

$ docker ps -a # view all containers
$ docker rm [container-id] # deletion
```

> Default image: `workspace/nlp:python3.8-pytorch1.8-v1.0`
>
> The container port `22` and `8888`  will be fixed and linked to the ports of randomly. So you need to note down the specific ports of your own containers, which is prepared for `jupyter notebook` and `SFTP` services.
>
> Actually we should use `nvidia-docker` instead of `docker` for GPU. The default setting of `docker` has been configured, so the both commands are OK.

---

## 1.3 Access containers with`exec`

```shell
$ docker exec -it $comtainer_id /bin/bash
```

> The command `exec` is recommended, which allows the containers not to get in 'stop' status when you `exit`.

---

## 1.4 Jupyter notebook yes!

```shell
$ ssh $username@133.9.48.110 -L 1234:133.9.48.110:$port-to'8888' # build another ssh connection with experiment machine 
------------------------- 
Access "http://localhost:1234/" in your browser. # '1234' is not fixed.
```

> Actually the startup command of  `workspace/nlp:python3.8-pytorch1.8-v1.0` Jupyter notebook has been written in the dockerfile, which means that the Jupyter service is enabled by default when the container is created.
>
> Of course, if the container is stopped, the service will also be stopped. By adding the parameter `--restart=always`to the `run` command at the beginning, the ''true default startup" of Jupyter can be realized.
>
> `run_jupyter.sh` can be re-configured and executed in your containers via `/home/run_jupyter.sh` .
>
> Also via`jupyter notebook --no-browser --ip=0.0.0.0 --allow-root  -NotebookApp.token=  --notebook-dir='/home'`

---

## 1.5 PyCharm and remote development

> Please contact with **Zhao Ming** "oldbulb@fuji.waseda.jp" for further setting.

---

## 1.6 Customization for your own images

```shell
$ docker commit -a $username -m $messages [container-id] [image-name:tag] # creat a new immage from your container
$ docker build -t [image-name:tag] -f [Dockerfile path] . 
# creat a new immage from your Dockerfile and '.' is for the context path and necessay

$ docker save -o [filename.tar] [image_id] # save your image as a tar file
$ docker load -i [filename.tar] # load your tar file to get a related image
```

> The Dockerfiles of  `workspace/nlp:python3.8-pytorch1.8-v1.0`  and `nvidia/cuda:11.2.0-cudnn8-devel-ubuntu20.04` are availiable for reference. 
>
> Official doc on dockerfiles [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
>
> More references @ [floydhub/dockerfiles](https://github.com/floydhub/dockerfiles), [deepo/dockerfiles]（https://github.com/ufoym/deepo/tree/master/docker）, [nvidia/container-images@gitlab](https://gitlab.com/nvidia/container-images)
>
> Note: The Waseda Proxy is not so friedly with some sources for `apt-get intsall` and `pip install`, especially for Nvidia. :bear::hammer::confused:
>
> **Visit [OpenSource @ Nvidia](https://developer.download.nvidia.com/compute/cuda/opensource/image/) for the GPL sources of the packages contained in the CUDA base image layers.**

---







# 2. Further reading

## 2.1 What is Docker?

**Docker** is a set of platform as a service (PaaS) products that use OS-level virtualization to deliver software in packages called containers. Containers are isolated from one another and bundle their own software,libraries and configuration files; they can communicate with each other through well-defined channels. All containers are run by a single operating system kernel  and therefore use fewer resources than virtual machines.

**Important concepts**

* **Image**

  Similar to the image in virtual machine, it is a read-only template for docker engine with file system. Any application needs environment to run, and image is used to provide this environment. For example, an Ubuntu image is a template containing the environment of the Ubuntu operating system. Similarly, if you install Apache Software on the image, you can call it an Apache image.

* **Container**

  Similar to a lightweight sandbox, it can be regarded as a minimalist Linux system environment (including root permission, process space, user space and network space), as well as applications running in it. Docker engine uses container to run and isolate various applications. Container is an application instance created by image, which can create, start, stop and delete containers. Containers are isolated from each other and do not affect each other. Note: the image itself is read-only. When the container starts from the image, docker creates a writable layer on the upper layer of the image, and the image itself remains unchanged.

* **Repository**

  Similar to the code repository (Github), this is repository for images, where docker stores image files centrally. The repository is the place where images are stored. Generally, each repository stores one type of images, and each image is distinguished by tag. For example, the Ubuntu repository stores images of multiple versions (12.04, 14.04, etc.).

  

  ![img](https://www.runoob.com/wp-content/uploads/2016/04/576507-docker1.png)



[Docker Wiki Page](https://en.wikipedia.org/wiki/Docker_(software)) and [Docker.com](https://www.docker.com/) for more details.



## 2.2 Why to introduce Docker?

When using the experimental machine for model training, we may encounter the following problems. The environment is configured again and again, and some errors may occur at any time. Therefore, we prefer to make the server environment consistent with our local environment, especially when we reconfigure the local environment for some reasons. In addition, when we implement other people's papers, we probably need to reconfigure their environments.

Docker can help solve these problems.

In fact, Docker is not necessarily the best solution to these problems. Even we need to pay some learning cost. But docker can help us realize some other functions.

If you 

* use Jupyter or PyCharm as the main ide to write Python

* need to train and debug your deep learning models frequently

* want to synchronize the code between locolhost and different servers

The following remote environment configuration of "Pycharm + Docker" can help you run and debug codes on the local PyCharm IDE using the Python interpreter and environment of the servers.

> Pycharm professional version is necessary. You can use Waseda student email address to apply for one year for free.



## 2.3 Install Docker Engine on Ubuntu

You can install Docker Engine in different ways. [Docker docs](https://docs.docker.com/engine/install/) for more details.
"**Install using the repository**" is the recommended approach. 

**Watch out! The proxy of Waseda blocks the repository site of [DockerHub](https://hub.docker.com/) and download site of [Nvidia](https://nvidia.github.io/nvidia-docker/) !!!**

**No `pull`, `push` & download !**

---

### 2.3.1 OS requirements

To install Docker Engine, you need the 64-bit version of one of these Ubuntu versions:

- Ubuntu Groovy 20.10
- Ubuntu Focal 20.04 (LTS)
- Ubuntu Bionic 18.04 (LTS)
- Ubuntu Xenial 16.04 (LTS)

Docker Engine is supported on `x86_64` (or `amd64`), `armhf`, and `arm64` architectures.

---

### 2.3.2 Uninstall old versions

Older versions of Docker were called `docker`, `docker.io`, or `docker-engine`. If these are installed, uninstall them:

```shell
$ sudo apt-get remove docker docker-engine docker.io containerd runc
```

----

### 2.3.3 Install using the repository

**SET UP THE REPOSITORY**

1. Update the `apt` package index and install packages to allow `apt` to use a repository over HTTPS:

   ```shell
   $ sudo apt-get update
   
   $ sudo apt-get install \
       apt-transport-https \
       ca-certificates \
       curl \
       gnupg-agent \
       software-properties-common
   ```

2. Add Docker’s official GPG key:

   ```shell
   $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
   ```

   Verify that you now have the key with the fingerprint `9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88`, by searching for the last 8 characters of the fingerprint.

   ```shell
   $ sudo apt-key fingerprint 0EBFCD88
   
   pub   rsa4096 2017-02-22 [SCEA]
         9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
   uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
   sub   rsa4096 2017-02-22 [S]
   ```

3. Use the following command to set up the **stable** repository. To add the **nightly** or **test** repository, add the word `nightly` or `test` (or both) after the word `stable` in the commands below. [Learn about **nightly** and **test** channels](https://docs.docker.com/engine/install/).

   > **Note**: The `lsb_release -cs` sub-command below returns the name of your Ubuntu distribution, such as `xenial`. Sometimes, in a distribution like Linux Mint, you might need to change `$(lsb_release -cs)` to your parent Ubuntu distribution. For example, if you are using `Linux Mint Tessa`, you could use `bionic`. Docker does not offer any guarantees on untested and unsupported Ubuntu distributions.

   *For x86_64 / amd64*

   ```shell
   $ sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
   ```

**INSTALL DOCKER ENGINE**

1. Update the `apt` package index, and install the *latest version* of Docker Engine and containerd

   ```shell
    $ sudo apt-get update
    $ sudo apt-get install docker-ce docker-ce-cli containerd.io
   ```

2. Verify that Docker Engine is installed correctly by running the `hello-world` image.

   ```shell
   $ sudo docker run hello-world
   ```

   This command downloads a test image and runs it in a container. When the container runs, it prints an informational message and exits.

Docker Engine is installed and running. The `docker` group is created but no users are added to it. You need to use `sudo` to run Docker commands. Continue to [Linux postinstall](https://docs.docker.com/engine/install/linux-postinstall/) to allow non-privileged users to run Docker commands and for other optional configuration steps.

**UPGRADE DOCKER ENGINE**

To upgrade Docker Engine, first run `sudo apt-get update`, then follow the [installation instructions](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository), choosing the new version you want to install.

---

### 2.3.4 Post-installation steps for Linux

This section contains optional procedures for configuring Linux hosts to work better with Docker.

The Docker daemon binds to a Unix socket instead of a TCP port. By default that Unix socket is owned by the user `root` and other users can only access it using `sudo`. The Docker daemon always runs as the `root` user.

If you don’t want to preface the `docker` command with `sudo`, create a Unix group called `docker` and add users to it. When the Docker daemon starts, it creates a Unix socket accessible by members of the `docker` group.

To create the `docker` group and add your user:

1. Create the `docker` group.

   ```shell
   $ sudo groupadd docker
   ```

2. Add your user to the `docker` group.

   ```shell
   $ sudo usermod -aG docker $USER
   ```

3. Log out and log back in so that your group membership is re-evaluated.

   If testing on a virtual machine, it may be necessary to restart the virtual machine for changes to take effect.

   On a desktop Linux environment such as X Windows, log out of your session completely and then log back in.

   On Linux, you can also run the following command to activate the changes to groups:

   ```shell
   $ newgrp docker 
   ```

4. Verify that you can run `docker` commands without `sudo`.

   ```shell
   $ docker run hello-world
   ```

   This command downloads a test image and runs it in a container. When the container runs, it prints an informational message and exits.

   If you initially ran Docker CLI commands using `sudo` before adding your user to the `docker` group, you may see the following error, which indicates that your `~/.docker/` directory was created with incorrect permissions due to the `sudo` commands.

   ```shell
   WARNING: Error loading config file: /home/user/.docker/config.json -
   stat /home/user/.docker/config.json: permission denied
   ```

   To fix this problem, either remove the `~/.docker/` directory (it is recreated automatically, but any custom settings are lost), or change its ownership and permissions using the following commands:

   ```shell
   $ sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
   $ sudo chmod g+rwx "$HOME/.docker" -R
   ```



## 2.4 Install NVIDIA-Docker

Setup the `stable` repository and the GPG key:

```shell
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
```

Install the `nvidia-docker2` package (and dependencies) after updating the package listing:

```shell
$ sudo apt-get update
```

```shell
$ sudo apt-get install -y nvidia-docker2
```

Restart the Docker daemon to complete the installation after setting the default runtime:

```shell
$ sudo systemctl restart docker
```

At this point, a working setup can be tested by running a base CUDA container:

```shell
$ sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```

This should result in a console output shown below:

```shell
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.51.06    Driver Version: 450.51.06    CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Tesla T4            On   | 00000000:00:1E.0 Off |                    0 |
| N/A   34C    P8     9W /  70W |      0MiB / 15109MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```



# 3. All-in-one Docker image

Tow recommended Docker image for deep learning

* [Deepo](https://github.com/ufoym/deepo)
* [FLOYDHUB](https://github.com/floydhub/dl-docker)

Both of them allow users to customize their own environments.

Take Deepo as an example:

------

### 3.1 Installation

1. Install [Docker](https://docs.docker.com/engine/installation/) and [nvidia-docker](https://github.com/NVIDIA/nvidia-docker).

2. Obtain the all-in-one image from [Docker Hub](https://hub.docker.com/r/ufoym/deepo)

```shell
docker pull ufoym/deepo
```

For users in China who may suffer from slow speeds when pulling the image from the public Docker registry, you can pull `deepo` images from the China registry mirror by specifying the full path, including the registry, in your docker pull command, for example:

```shell
docker pull registry.docker-cn.com/ufoym/deepo
```

------

### 3.2 Usage

Now you can try this command:

```shell
docker run --gpus all --rm ufoym/deepo nvidia-smi
```

This should work and enables Deepo to use the GPU from inside a docker container. If this does not work, search [the issues section on the nvidia-docker GitHub](https://github.com/NVIDIA/nvidia-docker/issues) -- many solutions are already documented. To get an interactive shell to a container that will not be automatically deleted after you exit do

```shell
docker run --gpus all -it ufoym/deepo bash
```

If you want to share your data and configurations between the host (your machine or VM) and the container in which you are using Deepo, use the -v option, e.g.

```shell
docker run --gpus all -it -v /host/data:/data -v /host/config:/config ufoym/deepo bash
```

This will make `/host/data` from the host visible as `/data` in the container, and `/host/config` as `/config`. Such isolation reduces the chances of your containerized experiments overwriting or using wrong data.

Please note that some frameworks (e.g. PyTorch) use shared memory to share data between processes, so if multiprocessing is used the default shared memory segment size that container runs with is not enough, and you should increase shared memory size either with `--ipc=host` or `--shm-size` command line options to `docker run`.

```shell
docker run --gpus all -it --ipc=host ufoym/deepo bash
```

------

### 3.3 Customization

If you prefer a specific framework rather than an all-in-one image, just append a tag with the name of the framework. Take tensorflow for example:

```shell
docker pull ufoym/deepo:tensorflow
```

If you need more information about JupterNotebook support or build your own customized image, you can access [Deepo](http://ufoym.com/deepo/) for help.

------



