#!/bin/bash

# @FILESOURCE config16.04.sh
# @AUTHOR Mikael Ritlay
# @DATE 21/05/2015 10:04:05 
# @VERSION 1.0.6

# Principais tarefas:
# 1. Instala pacotes basicos;
# 2. Configura o repositorio local;
# 3. Configura a autenticaçao LDAP;
# 4. Criacao de pasta HOME automatica;
# 5. GRUB2 sem tempo;
# 6. Configura o nome da maquina (HOSTANAME);
# 7. Configura unidade de rede com o servidor owncloud;
# 8. Instala OCS Inventory Agent;
# 9. Altera o background da tela de login;

# Variaveis
SERVERIP=10.0.0.5
CLOUD=/media/owncloud
OC_USER=aluno
OC_PASSWD=lec2014
REPO=/var/arquivos/repositorio
PADRAO="aptitude build-essential ldap-auth-client nscd openssh-server vim codeblocks chromium-browser gnome-panel p7zip-full traceroute qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils ubuntu-restricted-extras davfs2 curl blender git frama-c compizconfig-settings-manager nfs-common tcl8.5 tk8.5 owncloud-client-nautilus ocsinventory-agent"
PACOTES="vlc wireshark haskell-platform geany postgresql pgadmin3 fpc grace qtcreator oracle-java8-installer oracle-java8-set-default sublime-text atom ubuntu-make android-tools-adb"

# Inicio

# Caso o usuario nao seja root, ira aparecer essa mensagem;
if [ $UID != 0 ]; then {
        echo "Este script deve ser executado como superusuario, root ou sudo";
        exit 1;
        }
fi

echo -e '\n\nScript de configuração inicial para Ubuntu 16.04 AMD64\n\n'

# Configurar HOSTNAME

if [ -e /etc/hosts.backup ];  then
  echo -e '\nArquivo de backup "hosts" ja existe\n';sleep 1
  else
    # Solicitar HOSTNAME
    read -p 'Digite o HOSTNAME: lec' HOST
    while [[ "$HOST" != [[:digit:]][[:digit:]] ]];do
	    read -p 'Digite o HOSTNAME: lec' HOST
    done
    #Realiza backup do arquivo hosts
	cp /etc/hosts /etc/hosts.backup
    echo "127.0.0.1	localhost
127.0.1.1	lec$HOST

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters" > /etc/hosts
	echo "lec$HOST" > /etc/hostname	
fi

#Repositorio Local

echo -e '\nConfigurando Repositorios...\n';sleep 1
if [ -e /etc/apt/sources.list.backup ];  then
  echo -e '\nArquivo de backup "sources.list.backup" ja existe\n';sleep 1
  else
    cp /etc/apt/sources.list /etc/apt/sources.list.backup
    echo "deb http://br.archive.ubuntu.com/ubuntu/ xenial main restricted
# deb-src http://br.archive.ubuntu.com/ubuntu/ xenial main restricted
deb http://br.archive.ubuntu.com/ubuntu/ xenial-updates main restricted
# deb-src http://br.archive.ubuntu.com/ubuntu/ xenial-updates main restricted

deb http://br.archive.ubuntu.com/ubuntu/ xenial universe
# deb-src http://br.archive.ubuntu.com/ubuntu/ xenial universe
deb http://br.archive.ubuntu.com/ubuntu/ xenial-updates universe
# deb-src http://br.archive.ubuntu.com/ubuntu/ xenial-updates universe

deb http://br.archive.ubuntu.com/ubuntu/ xenial multiverse
# deb-src http://br.archive.ubuntu.com/ubuntu/ xenial multiverse
deb http://br.archive.ubuntu.com/ubuntu/ xenial-updates multiverse
# deb-src http://br.archive.ubuntu.com/ubuntu/ xenial-updates multiverse

deb http://br.archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse
# deb-src http://br.archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse

deb http://archive.canonical.com/ubuntu xenial partner
# deb-src http://archive.canonical.com/ubuntu xenial partner

deb http://security.ubuntu.com/ubuntu xenial-security main restricted
# deb-src http://security.ubuntu.com/ubuntu xenial-security main restricted
deb http://security.ubuntu.com/ubuntu xenial-security universe
# deb-src http://security.ubuntu.com/ubuntu xenial-security universe
deb http://security.ubuntu.com/ubuntu xenial-security multiverse
# deb-src http://security.ubuntu.com/ubuntu xenial-security multiverse" > /etc/apt/sources.list

# Instalação de pacotes básicos
    echo 'Instalando Pacotes Basicos...';

# JAVA ORACLE
    if [ -e /etc/apt/sources.list.d/webupd8team-ubuntu-java-xenial.list ];  then
    	echo 'Repositorio Oracle Java ja existe...';
    	else
    		echo 'Adicionando Repositorio: Oracle Java...';sleep 1
    		add-apt-repository -y ppa:webupd8team/java
    		echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
    fi

# Sublime Text Editor
    if [ -e /etc/apt/sources.list.d/webupd8team-ubuntu-sublime-text-2-xenial.list ];  then
    	echo 'Repositorio Sublime Text Editor ja existe...';
    	else
    		echo 'Adicionando Repositorio: Sublime Text Editor...';sleep 1
    		add-apt-repository -y ppa:webupd8team/sublime-text-2
    fi

#Atom Text Editor
    if [ -e /etc/apt/sources.list.d/webupd8team-ubuntu-atom-xenial.list ];  then
    	echo 'Repositorio Atom Text Editor ja existe...';
    	else
    		echo 'Adicionando Repositorio: Atom Text Editor...';sleep 1
    		add-apt-repository -y ppa:webupd8team/atom
    fi

# Owncloud    
    if [ -e /etc/apt/sources.list.d/owncloud-client.list ];  then
    	echo 'Repositorio owncloud já existe...'
    	else
    		echo 'Adicionando Repositorio Owncloud Client...'
    		wget http://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_16.04/Release.key
    		apt-key add - < Release.key; rm Release.key
    		sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_16.04/ /' > /etc/apt/sources.list.d/owncloud-client.list"
    fi

# Ubuntu Make (Ferramentas de desenvolvimento)   
umake(){
    if [ -e /etc/apt/sources.list.d/ubuntu-desktop-ubuntu-ubuntu-make-xenial.list ];  then
    	echo 'Repositorio Ubuntu Make já existe...'
    	else
    		echo 'Adicionando Ubuntu Make...'
    		add-apt-repository -y ppa:ubuntu-desktop/ubuntu-make
    		#umake android --accept-license    		
    fi
}
    
#Instalação e Atualização de pacotes
    apt-get update
    apt-get install -y --force-yes $PACOTES $PADRAO || { echo 'Erro no nome dos pacotes. Abortando...';mv /etc/apt/sources.list.backup /etc/apt/sources.list;exit 1; }
    
#Ferramentas de desenvolvimento
    echo "Instalando Android Studio"
    umake android --accept-license
    echo "Instalando Eclipse IDE"
    umake ide eclipse
    echo "Instalando Arduino IDE"
    umake arduino
    echo "Instalando NetBeans IDE"
    umake ide netbeans

# Atualizando o sistema
    apt-get -y --force-yes dist-upgrade
    if [ -e /usr/bin/dumpcap ];  then
    	echo -e '\nConfigurando WIRESHARK...\n';
    	dpkg-reconfigure wireshark-common
    	chmod o+x /usr/bin/dumpcap
    	else
    		echo -e 'Wireshark não foi instalado'
    fi
fi

#Montando unidade de compartilhamento
mkdir -p $REPO
mount.nfs $SERVERIP:$REPO $REPO || { echo -e "Erro na montagem.\nVerifique a conexao da maquina local e do servidor.\n Abortando...";exit 1; }

# Configurando autenticacao LDAP
echo -e '\nConfigurando autenticacao LDAP\n';

#Inclui o parametro ldap o arquivo /etc/nsswitch
auth-client-config -t nss -p lac_ldap

# Base de pesquisa: dc=lec,dc=dc,dc=ufc,dc=br
# Conta administrativa: cn=admin,dc=lec,dc=dc,dc=ufc,dc=br

# Configura os grupos
echo -e '\nConfigurando GRUPOS...\n';

if [ -e /etc/security/group.conf.backup ];  then
	echo -e '\nArquivo de backup "group.conf" ja existe\n';sleep 1
	else
		cp /etc/security/group.conf /etc/security/group.conf.backup
		echo '*;*;*;Al0000-2400;audio,cdrom,dialout,floppy' >> /etc/security/group.conf
fi

if [ -e /usr/share/pam-configs/my_groups ];  then
	echo -e '\nArquivo de backup "my_groups" ja existe\n';sleep 1
	else
		echo 'Name: activate /etc/security/group.conf
Default: yes
Priority: 900
Auth-Type: Primary
Auth:
        required                        pam_group.so use_first_pass' > /usr/share/pam-configs/my_groups
fi

# Modulo para criar a pasta HOME do usuario, se nao existir
if [ -e /usr/share/pam-configs/mkhomedir ];  then
	echo -e '\nArquivo de backup "mkhomedir" ja existe\n';sleep 1
	else
		echo 'Name: activate mkhomedir
Default: yes
Priority: 900
Session-Type: Additional
Session:
        required                        pam_mkhomedir.so umask=0022 skel=/etc/skel' > /usr/share/pam-configs/mkhomedir
        rm -rf /etc/skel/ ;cp -rv $REPO/skel/ /etc/
fi

#Remover 'use_authtok' da linha 26 do arquivo /etc/pam.d/common-password
echo -e '\nConfigurando PAM...\n';

if [ -e /etc/pam.d/common-password.backup ];  then
	echo -e '\nArquivo de backup "common-password" ja existe\n';sleep 1
	else
		cp /etc/pam.d/common-password /etc/pam.d/common-password.backup
		sed -i 's/use_authtok //' /etc/pam.d/common-password
		echo "[OK]"
fi

pam-auth-update
service nscd restart

# Habilitar a login manual e desabilitar usuario convidado
if [ -e /etc/lightdm/lightdm.conf.backup ];  then
	echo -e '\nArquivo de Backup "lightdm.conf" ja existe\n';sleep 1
	else
		echo -e '\nConfigurando ligthdm...\n';
    	echo "[SeatDefaults]
greeter-show-manual-login=true
greeter-hide-users=true
allow-guest=false
background='/usr/share/backgrounds/DC_LEC.jpg'" > /etc/lightdm/lightdm.conf
    	cp /etc/lightdm/lightdm.conf  /etc/lightdm/lightdm.conf.backup
    	echo "[OK]"
fi
# Fim da configuracao LDAP

# Alterar fundo com o logo do DC
if [ -e /usr/share/backgrounds/DC_LEC.jpg ];  then
	echo "Aviso: Fundo de tela já foi configurado"
	else
		echo "Alterando fundo de tela..."
		#scp administrador@10.0.0.4:/home/administrador/Imagens/DC_Lec.jpg /usr/share/backgrounds/logo_DCLEC.jpg
		cp $REPO/DC_LEC.jpg /usr/share/backgrounds/
		echo "[com.canonical.unity-greeter]
draw-user-backgrounds=false
background='/usr/share/backgrounds/DC_LEC.jpg'" >> /usr/share/glib-2.0/schemas/10_unity-settings-daemon.gschema.override
		glib-compile-schemas /usr/share/glib-2.0/schemas/
		echo "[OK]"
fi

#Montar Unidade de Rede owncloud
owncloud(){
if [ -e /etc/davfs2/secrets.backup ];  then
    echo -e '\nArquivo de backup "/etc/davfs2/secrets.conf" ja existe\n';sleep 1
    else
        echo -e '\nConfigurando Unidade de Rede...\n';sleep 1
        mkdir -p $CLOUD
        chmod 0777 $CLOUD
        cp /etc/davfs2/secrets /etc/davfs2/secrets.backup
        echo "http://$SERVERIP/owncloud/remote.php/webdav $OC_USER  $OC_PASSWD" > /etc/davfs2/secrets
        echo "http://$SERVERIP/owncloud/remote.php/webdav $CLOUD      davfs   rw,file_mode=777,dir_mode=777,auto     0       2" >> /etc/fstab
        echo "[OK]"
fi
}

#Configurações adicionais
#Ajustando as configuracoes do GRUB
if [ -e /etc/default/grub.backup ];  then
	echo -e '\nArquivo de backup "grub" ja existe\n';sleep 1
	else
    	cp /etc/default/grub /etc/default/grub.backup
    	echo -e '\nAtualizando GRUB 2...\n';sleep 1 
    	echo 'GRUB_DEFAULT=saved
GRUB_SAVEDEFAULT=true
#GRUB_HIDDEN_TIMEOUT=0
GRUB_HIDDEN_TIMEOUT_QUIET=true
GRUB_TIMEOUT=-1
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX=""
' > /etc/default/grub
    	update-grub
fi

# Configurar o PostgreSQL
echo -e '\nPara configurar o PostgreSQL execute os seguintes comandos:\n'
echo -e 'sudo -u postgres psql template1\n'
echo -e '\password postgres\n'
echo -e 'Digite a senha do banco\n'
echo -e 'CTRL+D para sair\n'

echo -e 'Terminado, teste as configuracoes e reinicie a maquina.\n'
