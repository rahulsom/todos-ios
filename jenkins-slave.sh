# === Instructions for setting up a build slave for iOS projects ===
#
# 1. Install latest XCode correctly.
# 2. Configure xcode-select correctly.
#
# --- Pause for a breath ---
#
# 3. Install homebrew (and run brew doctor).
# 4. Run this script.
#
# --- Cross your fingers ---

# Install tools for future steps
/usr/local/bin/brew install npm xctool wget rbenv ruby-build rbenv-gem-rehash
rbenv rehash
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
JAVA_HOME=$(ls -1d /Library/Java/JavaVirtualMachines/*/Contents/Home | tail -1)
eval "$(rbenv init -)"
rbenv install 2.1.2

# Install cask so java can be installed
/usr/local/bin/brew install caskroom/cask/brew-cask

# Install java
/usr/local/bin/brew cask install java
echo 'JAVA_HOME=$(ls -1d /Library/Java/JavaVirtualMachines/*/Contents/Home | tail -1)' >> ~/.bash_profile

# Install and launch appium using npm
/usr/local/bin/npm install -g appium
cat > appium-svc.sh << EOF
#!/bin/bash
case $1 in
  start )
    /usr/local/bin/npm install -g appium #This can update your appium before launching
    nohup /usr/local/bin/appium &
    ;;
  stop )
    ps -ef | grep appium | grep -v grep | grep -v appium-svc.sh | tr -s " " | cut -d " " -f 3 | xargs -n 1 kill
    ;;
  * )
    echo "Usage: "
    echo "$0 start|stop"
    ;;
esac
EOF
chmod u+x appium-svc.sh

# Install and configure cocoapods
rbenv shell 2.1.2
gem install bundler
bundle install
pod setup

# Configure ssh keys
mkdir -p ~/.ssh
cat > ~/.ssh/id_rsa << EOF
-----BEGIN RSA PRIVATE KEY-----
... Put your ssh key here ...
-----END RSA PRIVATE KEY-----
EOF

cat > ~/.ssh/id_rsa.pub << EOF
... Put your ssh public key here ...
EOF

chmod 644 ~/.ssh/id_rsa.pub
chmod 600 ~/.ssh/id_rsa

# Accept XCode license
sudo xcodebuild -license accept

# Download and run Jenkins Slave
cat > jslave-svc.sh << EOF
#!/bin/bash
wget https://jenkins.ci.cloudbees.com/jnlpJars/jenkins-cli.jar
caffeinate -si \
    java -jar jenkins-cli.jar \
    -s https://my-cloudbees-instance.ci.cloudbees.com \
    -i ~/.ssh/id_rsa \
    on-premise-executor \
    -fsroot \$HOME/jsroot \
    -labels ios \
    -executors 1
sleep 10
EOF

chmod u+x jslave-svc.sh
nohup ./jslave-svc.sh > /dev/null &

# You might have to do this - xcrun simctl list devices | grep unavailable | xargs -n 1 echo | grep -E "\([0-9A-F\-]*\)" | sed -e "s/(//" | sed -e "s/)//" | xargs -n 1 xcrun simctl delete
