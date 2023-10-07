# Build NeuVector images

Neuvector's main product contains 4 components, manager, controller, enforcer and scanner. Their source code are hosted in the following repos.

- https://github.com/neuvector/manager
- https://github.com/neuvector/neuvector
- https://github.com/neuvector/scanner

These components share the similar build process. The executables are compiled by the "build" containers. The build containers have all the tool chains and dependencis installed, which allows you to build in any host environment. After the executables are compiled, they are added to the base image of each component to make the container images.

## Create build container images

The executables are compiled with build containers. There are two build container images.

 - *neuvector/build_fleet*: used to compile executables of the controller, enforcer and scanner;
 - *neuvector/build_manager*: used to compile the manager's java program.

These two build container images are hosted in the docker hub. You can rebuild them with the following commands.

```
make build_fleet
make build_manager
```
## Create base images

Base images provide necessary dependencies for the executables to run. The default base images are created from the Alpine Linux. Bases images of other Linux distros, such as ubi and bci, are provided as well.

There are 4 base images, one for each component.
- neuvector/manager_base
- neuvector/controller_base
- neuvector/enforcer_base
- neuvector/scanner_base

These base images are hosted in the docker hub. You can recreate them with the following commands.

```
make manager_base
make controller_base
make enforcer_base
make scanner_base
```

## Compile executables and build images

### controller and enforcer

The following commands will run unitest and compile executables,
```
git clone git@github.com:neuvector/neuvector.git
cd neuvector
make fleet
cd ..
```

then, you can build images with the following commands,
```
cp neuvector/Makefile .
cp neuvector/build/dockerignore .dockerignore

make ctrl_image
make enf_image
```

*neuvector/controller* and *neuvector/enforcers* images are created after above commands run successfully.

### scanner

The first step is to generate the new vulnerability database. You should provide the database version in the format of 2.123 when creating the database.

```
git clone git@github.com:neuvector/vul-dbgen.git
cd ./vul-dbgen
git clone --depth 1 git@github.com:neuvector/vul-source.git 
VULN_VER=x.xxx make db
cd ..
```

The second step is to copy the database into the scanner folder.
```
git clone git@github.com:neuvector/scanner.git
mkdir -p scanner/data
cp ./vul-dbgen/cvedb.regular scanner/data
```

The third step is to run unitest and compile executables,
```
cd ./scanner
make binary
cd ..
```

then, you can build the scanner image with the following commands,
```
cp scanner/Makefile Makefile
cp scanner/build/dockerignore .dockerignore
make scanner_image
```

*neuvector/scanner* image is created after above commands run successfully.

### manager

The following commands compile the manager jar file,
```
git clone git@github.com:neuvector/manager.git
cd manager
make jar
cd ..
```

then, you can build the manager image with the following commands,
```
cp manager/Makefile .
make manager_image
```

*neuvector/manager* image is created after above commands run successfully.
