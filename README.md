<div align="center">

![Shell](https://github-repo-img.s3.eu-central-1.amazonaws.com/shell.png)

</div>

## System and Process Management Commands
  #### System Monitoring:
    
        top -> Displays system tasks, CPU, and memory usage in real-time.
        
        htop -> An interactive version of top with more visual details (if installed).
        
        uptime -> Shows how long the system has been running and the load averages.

        df -h -> Reports disk space usage in a human-readable format.
        
        free -m -> Displays available and used memory in megabytes.
        
        vmstat -> Provides information about system processes, memory, paging, block IO, traps, and CPU activity.

  #### Process Management:
    
        ps -aux -> Lists all running processes with detailed information.
        
        kill -9 PID -> Forces termination of a process using its Process ID (PID).
        
        pkill process_name -> Kills processes by name.
        
        nohup command & -> Runs a command in the background, unaffected by hangups.
        
        nice -n 10 command -> Runs a command with a lower priority.

## File and Directory Operations

  #### File Manipulation:
    
        touch file.txt -> Creates an empty file or updates the timestamp of an existing file.
        
        cp file1.txt /destination/ -> Copies files from one location to another.
        
        mv file.txt /destination/ -> Moves or renames files.
        
        rm -rf /directory -> Recursively removes directories (be cautious with this command).
        
        cat file.txt -> Displays file contents.
        
        head -n 10 file.txt -> Shows the first 10 lines of a file.
        
        tail -n 10 file.txt -> Shows the last 10 lines of a file.
        
        less file.txt -> Paginates through a file.

  #### Directory Operations:
    
        mkdir my_folder -> Creates a new directory.
        
        rmdir my_folder -> Removes an empty directory.
        
        cd /path/to/directory -> Changes the working directory.
        
        pwd -> Prints the current working directory.
        
        ls -al -> Lists all files and directories with detailed permissions and sizes.

## Automation and Scripting Basics

  #### Variables:

```bash

  NAME="Weronika"
  echo "Hello, $NAME"
```

#### Conditionals:

```bash

if [ -f /etc/passwd ]; then
    echo "File exists"
else
    echo "File does not exist"
fi
```

#### Loops:

```bash

for i in {1..5}; do
    echo "Number: $i"
done
```

#### Functions:

```bash

    my_function() {
        echo "This is a function"
    }
    my_function
```

## Package Management Commands

  #### Debian-based Systems (e.g., Ubuntu):
    
        apt update -> Updates package index.
        
        apt upgrade -y -> Upgrades installed packages.
        
        apt install package_name -y -> Installs a new package.
        
        apt remove package_name -y -> Removes a package.

  #### Red Hat-based Systems (e.g., CentOS, Fedora):
    
        yum update -> Updates all packages.
        
        yum install package_name -> Installs a new package.
        
        yum remove package_name -> Removes a package.

## Networking and Connectivity Commands

  #### Network Configuration:
    
        ifconfig or ip addr -> Displays network interface information.
        
        ping google.com -> Tests network connectivity.
        
        netstat -tuln -> Shows active network connections and listening ports.
        
        curl -I http://example.com -> Sends a request to a URL and shows the HTTP headers.
        
        wget https://example.com/file.zip -> Downloads files from the internet.

  #### Firewall Management:
    
        ufw status -> Checks the status of the firewall (Ubuntu/Debian).
        
        ufw allow 22 -> Allows traffic on port 22 (SSH).
        
        iptables -L -> Lists all current firewall rules (Red Hat-based systems).

## User and Permission Management

  #### User Commands:
    
        adduser username -> Creates a new user.
        
        passwd username -> Changes the password for a user.
        
        usermod -aG sudo username -> Adds a user to the sudo group.
        
        whoami -> Displays the current logged-in user.

  #### Permission Commands:
    
        chmod 755 file.txt -> Sets file permissions.
        
        chown user:group file.txt -> Changes the owner of a file.
        
        sudo -> Runs commands with elevated privileges.

## Disk and File System Management

  #### Disk Operations:
  
        lsblk -> Lists block devices.
        
        fdisk -l -> Displays partition information.
        
        mount /dev/sda1 /mnt -> Mounts a partition.
        
        umount /mnt -> Unmounts a partition.

  #### File System Management:
  
        du -sh /path -> Shows disk usage for a directory.
        
        df -h -> Displays disk space usage for all mounted filesystems.
        
        fsck /dev/sda1 -> Checks and repairs a filesystem.

## DevOps and Automation Specific Commands

  #### Cron Jobs:
  
        crontab -e -> Edits the crontab for scheduling tasks.
        
```bash
# Example crontab entry:
0 2 * * * /path/to/backup.sh

# Runs a backup script every day at 2 AM.
```


  #### Service Management:
  
        systemctl status nginx -> Checks the status of the Nginx service.
        
        systemctl start nginx -> Starts the Nginx service.
        
        systemctl enable nginx -> Enables the service to start on boot.

  #### Log Management:
  
        tail -f /var/log/syslog -> Follows the system log in real-time.
        
        journalctl -u nginx.service -> Shows logs for the Nginx service.

## Docker Commands 

  #### Container Operations:
  
        docker run -d --name my_app nginx -> Runs a Docker container in the background.
        
        docker ps -a -> Lists all containers.
        
        docker exec -it my_app /bin/bash -> Accesses a running container.

  #### Image Management:
  
        docker images -> Lists Docker images.
        
        docker build -t my_app . -> Builds an image from a Dockerfile.
        
        docker rmi my_app -> Removes a Docker image.

## Kubernetes Commands 

  #### Basic Operations:
  
        kubectl get pods -> Lists all pods in the cluster.
        
        kubectl get services -> Lists all services.
        
        kubectl apply -f deployment.yaml -> Applies a configuration file.

  #### Namespace Management:
  
        kubectl get namespaces -> Lists all namespaces.
        
        kubectl create namespace my-namespace -> Creates a new namespace.

  #### Scaling and Rolling Updates:
  
        kubectl scale deployment my-deployment --replicas=3 -> Scales a deployment to 3 replicas.
        
        kubectl rollout status deployment/my-deployment -> Checks the rollout status.

## Security and Encryption

  #### SSH Commands:
  
        ssh user@host -> Connects to a remote host via SSH.
        
        scp file.txt user@host:/destination/ -> Securely copies files between hosts.

  #### File Encryption:
  
        gpg -c file.txt -> Encrypts a file using GPG.
        
        gpg file.txt.gpg -> Decrypts a GPG-encrypted file.
