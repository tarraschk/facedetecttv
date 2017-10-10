# Observatoire politique
Application de suivi des interventions TV des candidats à l'élection présidentielle

# Installation de l'environnement de développement
1) Télécharger et installer VirtualBox https://www.virtualbox.org/wiki/Downloads

2) Créer une machine virtuelle basée sur Ubuntu 16.04 Desktop https://www.ubuntu.com/download/desktop

3) Installer Ubuntu sur la machine virtuelle https://openclassrooms.com/courses/reprenez-le-controle-a-l-aide-de-linux/installez-linux-dans-une-machine-virtuelle

4) Se connecter comme administrateur sur la machine Ubuntu lancée via VirtualBox en local (lancer la machine sous VirtualBox, puis se connecter sur sa session administrateur (utilisateur d'administration sur Linux : root)

4bis) En cas de doute sur le fait que vous soyez administrateur, tapez ```sudo su```, si ça vous demande un mot de passe, tapez celui du compte Linux créé, vous serez alors root (administrateur).

5) Une fois connecté en tant que root (administrateur), installer OpenCV avec :
```bash
apt-get install build-essential
apt-get install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
apt-get install python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
cd /opt
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git
cd /opt/opencv
mkdir release
cd release
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules /opt/opencv/
make
make install
```

6) Vérifier que la commande suivante affiche "3.2.0"
```bash
pkg-config --modversion opencv
```

7) Installer RVM, Ruby, et bundler:
```bash
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
gem install bundler
```

8) Télécharger le code source de l'application avec :
```bash
cd /root/
git clone https://github.com/tarraschk/observatoire-politique.git
```

9) Installer les dépendances de l'application avec :```
```bash
cd /root/observatoire-politique/
bundle install
```

10) Lancer l'application :
```bash
rails s
```

Vous pouvez alors accéder à l'application sur http://127.0.0.1:3000


# Annexes

- Problème d'exécution de Runtime JS ? `apt-get install nodejs`

- Problème de secrets.yml ? `bash utils_createsecrets.sh`