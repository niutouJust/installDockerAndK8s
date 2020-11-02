#swap   vim /etc/fstab  always close

#swap close 
sudo swapoff -a

# firewall close 
sudo systemctl stop firewalld

# SElinux close
sudo setenforce 0 

# update date
sudo ntpdate time1.aliyun.com


# add k8s config
cat > /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

# install docker
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine \

sudo yum install -y yum-utils


sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo


sudo yum install -y docker-ce docker-ce-cli containerd.io

sudo systemctl start docker

# install k8s
cat > /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

sudo yum install -y kubeadm kubelet kubectl


systemctl enable kubelet

sudo systemctl start kubelet
