# Use VSCode and GN+Ninja to Compile Gowin GW1NS-4 Project

Because I did not download official IDE, I modified the official source code to rebuilt the build system based on GN + Ninja, and use VSCode to edit the source code and compile it on the command line (or use VSCode's Task to compile).
GN+Ninja build system directory description:

<img src="/projects/Using VSCode and GN+Ninja to Compile Gowin GW1NS-4 Project/pic/VScode pic (1).png" width= "400">

### Design Flow

1. Download code

https://gitee.com/walker2048/gw1-ns-4-c-gn

2. Install GN and Ninja tools (Linux only). Download gn and ninja, extract to the directory and put the directory into the environment variables

gn address: https://repo.huaweicloud.com/HarmonyOS/compiler/gn/1523/linux/gn.1523.tar
ninja address: https://repo.huaweicloud.com/harmonyos/compiler/ninja/1.9.0/linux/ninja.1.9.0 .tar

3. In the git downloaded project directory, run the build command

<img src="/projects/Using VSCode and GN+Ninja to Compile Gowin GW1NS-4 Project/pic/VScode (2).png" width= "400">

<img src="/projects/Using VSCode and GN+Ninja to Compile Gowin GW1NS-4 Project/pic/VScode pic (3).png" width= "400">

4. This will complete the compilation.

If you need to add c source file, refer to the following tutorial.

For example, if you need to add the test.c file in the user directory, modify lines 21~27 of the user/BUILD.gn file, add test.c to it, as shown in the following.

<img src="/projects/Using VSCode and GN+Ninja to Compile Gowin GW1NS-4 Project/pic/VScode pic (4).png" width= "400">

<img src="/projects/Using VSCode and GN+Ninja to Compile Gowin GW1NS-4 Project/pic/VScode pic (5).png" width= "400">

If you need to add additional components, you can refer to the system component configuration and copy the component source code directory to the root directory. Also copy the BUILD.gn file of system to this component, and modify line 3 static_library("system"); change system to the component directory name (case consistent), and change line 5 to the c file name that needs to be compiled. Finally, change line 4 of the user/BUILD.gn (written by component name), sorted from the top and written from left to right.

If you need to add a global reference directory, modify lines 20~27 of build/config/BUILD.gn and add the directory to it.
