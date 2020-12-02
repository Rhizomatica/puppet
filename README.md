# Rhizomatica Puppet repository

This is a puppet recipe to install and prepare an installation of RCCN on a Debian 9/10 system.

**INSTALLATION:** 

Install Debian 9 or 10 (stretch/buster) amd64 from 
[https://www.debian.org/distrib/netinst](https://www.debian.org/distrib/netinst)

- During the Install process, create a user '**rhizomatica**'
- Partition as you please, otherwise "**Guided - use entire disk**"
- As above, otherwise "**All files in one partition**" is fine.
- Setup a minimal system. You don't need a **desktop environment**.
 I suggest you install **SSH server** and **standard system utilities**.
- Boot into the new system, login, locally or via ssh.
- Get root with `su -` if needed and run the following:


`root@host~# apt-get install git puppet puppetmaster` 

(Accept all the additional packages)

`root@host:~# cd /etc/puppet/code`

`root@host:/etc/puppet/code# mkdir environments`

`root@host:/etc/puppet/code# mkdir hiera`

`root@host:/etc/puppet/code# cd environments`

`root@host:/etc/puppet/code/environments# git clone https://github.com/Rhizomatica/puppet.git production`

`root@host:/etc/puppet/code/environments# cd prodution`

`root@host:/etc/puppet/code/environments/production# git submodule init`

`root@host:/etc/puppet/code/environments/production# git submodule update`

`root@host:/etc/puppet/code/environments/production# cp hiera.yaml /etc/puppet`

`root@host:/etc/puppet/code/environments/production# cp hieradata/* /etc/puppet/code/hiera`

`root@host:/etc/puppet/code/environments/production# cd /etc/puppet/code/hiera`

`root@host:/etc/puppet/code/hiera# cp site_template.yaml $(hostname -f | awk '{print tolower($0)}').yaml`

`root@host:/etc/puppet/code/hiera# cd`

`root@host:~# echo "127.0.0.1 puppet" >> /etc/hosts`

`root@host:~# systemctl restart puppetmaster`

You are now ready to run the puppet agent to prepare and configure your system.

We use ignoreschedules here to make sure that everything happens on these
initial runs, you should not need it afterwards. 

`root@host:~# puppet agent --test --ignoreschedules`

This may take a while, it has to fetch all the packages and install them,
Some package installations will fail, so when it is finished you need to do it once more:

`root@host:~# puppet agent --test --ignoreschedules`

Done! Now you can run the final RCCN setup step, but before you do this,
take a quick look at CAVEATS below.:

`root@host:~# cd /var/rhizomatica/rccn`

`root@host:/var/rhizomatica/rccn# python ./install.py -f`

Now reboot your system and [file a bug report](https://github.com/Rhizomatica/puppet/issues/new) about whatever is still not working.

### Thanks for testing RCCN! ###


----------



**CAVEATS:**

- Because you don't have the key to our private repo, you will not have any sounds in `/usr/share/freeswitch/sounds/rccn/`.
TIC is not publically distributing the sound files used on the TIC network. Someone needs to make some generic sounds.

- You might want to do `systemctl restart osmo-nitb` before running the
install.py, as if the NITB has never run, the sqlite HLR database will not
exist yet. - What's more, systemd is not starting the NITB on reboot. You
need to do `systemctl start osmo-nitb` manually. :-/
Same goes for freeswitch. FIXES??

- After install and reboot, considering add the user rhizomatica to the sudo group: `usermod -aG sudo rhizomatica`

- After install, you do not really need the puppet master service running, so
consider disabling it.

----------


ESPAÑOL:

# Repositorio Puppet de Rhizomatica
Esta es una receta para instalar y preparar una instalación de RCCN en un  sistemas Debian 9/10

**INSTALACIÓN:** 

Instalar Debian 9 o 10 (stretch/buster) amd64 de 
[https://www.debian.org/distrib/netinst](https://www.debian.org/distrib/netinst)

- Durante el proceso de instalación, crear el usuario '**rhizomatica**'
- Realiza  particiones como desees, o puedes usar  "**Guiado - usar todo el disco**"
- Como el anterior, usar "**Todos los archivos en una partición**" está bien.
- Configuración mínima del sistema.No necesitas un **entorno de escritorio**.
 Se sugiere instalar  **Servidor de SSH** y **Utilidades Estandares del Sistema**.
- Arranca el nuevo sistema , inicia sesión, localmente o por ssh.
- Hazte root con `su -`si es necesario y ejecuta lo siguiente:


`root@host~# apt-get install git puppet puppetmaster` 

(Aceptar todos los paquetes adicionales)

`root@host:~# cd /etc/puppet/code`

`root@host:/etc/puppet/code# mkdir environments`

`root@host:/etc/puppet/code# mkdir hiera`

`root@host:/etc/puppet/code# cd environments`

`root@host:/etc/puppet/code/environments# git clone https://github.com/Rhizomatica/puppet.git production`

`root@host:/etc/puppet/code/environments# cd prodution`

`root@host:/etc/puppet/code/environments/production# git submodule init`

`root@host:/etc/puppet/code/environments/production# git submodule update`

`root@host:/etc/puppet/code/environments/production# cp hiera.yaml /etc/puppet`

`root@host:/etc/puppet/code/environments/production# cp hieradata/* /etc/puppet/code/hiera`

`root@host:/etc/puppet/code/environments/production# cd /etc/puppet/code/hiera`

`root@host:/etc/puppet/code/hiera# cp site_template.yaml $(hostname -f | awk '{print tolower($0)}').yaml`

`root@host:/etc/puppet/code/hiera# cd`

`root@host:~# echo "127.0.0.1 puppet" >> /etc/hosts`

`root@host:~# systemctl restart puppetmaster`

Ahora estas preparad@ para ejecutar el agente de puppet (puppet agent) para preparar y configurar tu sistema.

Usamos ignoreschedules aquí para estar seguros de que todo se realice 
en ésta ejecución inicial, no deberias de necesitarlo después


`root@host:~# puppet agent --test --ignoreschedules`

Esto puede tomar un tiempo, tiene que buscar todos los paquetes e instalarlos,
Algunas instalaciones de paquetes fallarán, así que cuadno esta termine necesitarás hacerlo una vez más: 


`root@host:~# puppet agent --test --ignoreschedules`

¡Listo! Ahora puedes ejecutar el paso de configuración final de  RCCN, pero antes debes de hacer esto,

Done! Now you can run the final RCCN setup step, but before you do this,
Eche un vistazo rápido a las CAVEATS de abajo:

`root@host:~# cd /var/rhizomatica/rccn`

`root@host:/var/rhizomatica/rccn# python ./install.py -f`

Ahora reinicia el sistema y [realice un informe de error](https://github.com/Rhizomatica/puppet/issues/new) sobre lo que sea que no funcione.

### Gracias por probar RCCN! ###

----------



**CAVEATS:**
- Debido a que no tienes acceso a nuestro repo privado, no tendrás ningun audio in `/usr/share/freeswitch/sounds/rccn/`.

TIC no distribuye públicamente los archivos de audio usados en la red TIC. Alguien necesita hacer algunos audios genericos.

Puedes grabar audios propios en mp3 y convetirlo con sox a gsm, para ello también desde de tener instalado `sox` y  `libsox-fmt-mp3`
Instalar sox y libsox-fmt-mp3: 

`sudo apt-get install sox libsox-fmt-base
sudo apt-get install libsox-fmt-mp3` 

convertir de mp3 a gms 
`sox anyfile.mp3 -r 8000 -c1 anyfile.gsm` 

Para probar el archivo gsm puedes ejecutar el siguiente comando:
`padsp play test.gsm` 

- Es posible que debas de hacer `systemctl restart osmo-nitb` antes de ejecutar
install.py, como si NITB nunca se hubiera ejecutado, ya que  la base de datos HLR
de sqlite no existe todavia. - Además, systemd no inicia NITB al reiniciar. Necesitas
ejecutarlo manualmente `systemctl start osmo-nitb`. :-/ 
Lo mismo para con freeswitch. SOLUCIONES? 

- Después de instalar y reiniciar, considera agregar al usuario rhizomatica al grupo de sudo: `usermod -aG sudo rhizomatica`
- Después de instalar, realmente no necesitas el servicio de puppet master corriendo, así que 
considera deshabilitarlo.

----------
