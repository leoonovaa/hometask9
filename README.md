
# Anna Leonova 4CS-32
# Hometask9

**Topic:** Remote Docker configuration on AWS EC2 + building and running NGINX container via SSH tunnel

Objective

* Launch an EC2 instance based on  **Ubuntu 22.04** (`ami-053b0d53c279acc90`)
* Install and configure Docker using user-data, enabling remote access through TCP 127.0.0.1:2375
* Create a local Dockerfile based on fedora:latest that deploys an NGINX web server
* Establish an SSH tunnel from the local machine to the EC2 instance
* Build a Docker image remotely using the tunnel
* Run an NGINX container on the EC2 instance 

Steps to Run

**Step 1 — Launch the EC2 Instance**

1. Open your AWS Management Console or use **AWS CLI**.
2. Create a new **EC2 instance** with:

   * Image: `Ubuntu Server 22.04`
   * Instance type: `t3.micro`
   * Key pair: your existing key (`.pem` file)
   * Security Group: allow inbound 80
   * **User data**: attach your prepared Docker installation & configuration script

Wait until the instance is in the **running** state.

**Step 2 — Create SSH Tunnel for Remote Docker Access**

```bash
ssh -i "<your-key>.pem" -L 5566:127.0.0.1:2375 ubuntu@<your-instance-ip>
```

**Step 3 — Verify Docker Status on the Instance**

Check that Docker is active:

```bash
sudo systemctl status docker
```

Confirm that Docker is listening on the required TCP port:

```bash
sudo ss -tlnp | grep 2375
```

**Step 4 — Build the Docker Image Remotely**

```bash
docker -H localhost:5566 build -t hometask9 .
```

**Step 5 — Run the NGINX Container on EC2**

```bash
docker -H localhost:5566 run -d -p 80:80 hometask9
```

**Step 6 — Verify Web Server in Browser**

```bash
http://<your-instance-ip>
```

