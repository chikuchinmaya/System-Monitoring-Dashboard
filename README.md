# 🖥️ System Monitoring Dashboard with SNS Alerts  

**A real-time system monitoring solution** using **Bash scripting, Apache HTTPD, and AWS SNS**. This project tracks system metrics like **CPU usage, memory, disk space, and top processes**, while also triggering **automated SNS notifications** when resource thresholds are exceeded.

🔧 Use Cases: ✅ Server monitoring ✅ Resource management ✅ Lightweight tracking

## 🚀 Features

- 📌 **OS Information** – Displays system name and version.
- ⏳ **CPU Uptime** – Shows total uptime in days, hours, minutes, and seconds.
- 🔥 **CPU Usage** – Dynamically updates CPU utilization percentage.
- 🧠 **Memory Usage** – Monitors used/free memory in MB.
- 💾 **Disk Usage** – Tracks total size, used space, and available space with percentage.
- 🔥 **Top Processes** – Lists the top 5 processes by CPU and memory usage.
- 🌐 **Web-Based Dashboard** – Accessible via a browser with a simple HTML and CSS interface.
- ✔ **SNS Alerts for High Usage** – Sends **automatic notifications** for critical CPU, memory, and disk space thresholds  

## 📢 SNS Alert Integration  
Now, the dashboard includes **AWS SNS Alerts** to notify users when system metrics exceed safe limits.  
🚀 If **CPU usage exceeds 80%**, **memory exceeds 85%**, or **disk space exceeds 90%**, an SNS notification is triggered!  
🚀 Features ✔ Live system insights (CPU, Memory, Disk) ✔ Top processes by CPU & Memory ✔ Web-based dashboard (HTML, CSS) ✔ Auto-refresh with Apache CGI

## 🏗️ Setup & Installation

### **1. Install Apache HTTPD**
Install and start Apache:
```bash
sudo apt update && sudo apt install apache2 -y  # Ubuntu/Debian
sudo yum install httpd -y  # CentOS/RHEL
sudo systemctl start httpd
sudo systemctl enable httpd
```

2. Move Bash Script to CGI Directory
```bash
git pull https://github.com/chikuchinmaya/System-Monitoring-Dashboard.git
sudo mv system_info.sh /var/www/cgi-bin/
sudo chmod +x /var/www/cgi-bin/system_info.sh
```

3. Enable CGI in Apache
Modify your Apache config file:

```bash
sudo nano /etc/httpd/conf/httpd.conf  # CentOS/RHEL
sudo nano /etc/apache2/apache2.conf  # Ubuntu/Debian
```

Add:

```bash
ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"
<Directory "/var/www/cgi-bin">
    AllowOverride None
    Options +ExecCGI
    Require all granted
</Directory>
Restart Apache:
```

```bash
sudo systemctl restart httpd
```
Access the Dashboard
Open your browser and visit:

http://your_IP/cgi-bin/system_info.sh

![Dashboard](./Dashboard.png)

Also you you can run your CMD in Same system.

```bash
./system_info.sh
```

![in same system](./CMD_status.png)

## 📢 SNS Alert 

📌 Step 1: Install & Configure AWS CLI
First, install AWS CLI and configure your credentials:

```bash
sudo apt install awscli -y   # Ubuntu/Debian
sudo yum install awscli -y   # CentOS/RHEL
aws configure
```

Enter your AWS Access Key, Secret Key, Region, and Output format.

📌 Step 2: Create an SNS Topic
Go to AWS SNS Console.

Click "Create Topic" → Choose Standard.

Name the topic (e.g., HighMetricsAlerts).

Click "Create Topic".

📌 Step 3: Create an SNS Subscription
Click on your SNS Topic.

Select "Create Subscription".

Choose Protocol (e.g., Email, SMS).

Enter the recipient endpoint (e.g., email or phone).

Click "Create Subscription".

Run the Alert Script Separately

📌 Step 4: Keep your SNS alert script (system_alerts.sh) as a background process.
Use Cron Jobs to schedule it every 5 minutes:

```bash
crontab -e
```

Add:

```bash
*/5 * * * * /path/to/system_alerts.sh
```

📢 What Happens?
🔹 Dashboard (system_info.sh) → Displays live system metrics in the browser. 
🔹 Alerts (system_alerts.sh) → Runs separately & triggers SNS alerts when metrics exceed thresholds.

🚀 Now, your system will have both a web-based dashboard AND automated notifications!
