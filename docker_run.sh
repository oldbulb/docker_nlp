#! /bin/bash
#
# ------ docker run script ------
# `-idt` is for 'Interactive', 'Detached', 'Terminal'
# '-ipc=host' is for sharing memory with the host to accelerate computation
# Default fornat: `--name [container-name]`  --->  `workspace-{Name}-{Date}`
#                  e.g. `workspace-Zhao_ming-0301`
# Default port: `-p 8888:8888` is for JupyterNotebook   `-p 22:22` is for SFTP
# Default shared volume: `-v [host-src]:[container-dest]` --->  `/home/{Name}/workspace_{Date}:/home/workspace_{Date}`
#                  e.g. `/home/Zhao_ming/workspace_0301:/home/workspace_0301`
# Defaul image_id: b5236cfa5b64 <---> "nlp/pytorch1.8:base"  if use other image, just type the id as the third argument.

imageid(){
    if [ $# = 3 ];
    then
       	echo "$3"
    else 
 	echo a396d659228e;      
   fi
}

echo "The image_id: $(imageid $@) \
	The containe_name: workspace-$1-$2" && \

docker run -idt \
    --ipc=host \
    --name "workspace-$1-$2" \
    -p ::22 \
    -p ::8888 \
    -v /home/$1/workspace_$2:/home/workspace_$2 \
    $(imageid $@) \
    /bin/bash && \

docker ps -a \
