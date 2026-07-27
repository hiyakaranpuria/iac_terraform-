# Task 3: Infrastructure as Code (IaC) with Terraform

## Objective
Provision a local Docker container using Terraform.

## Tools Used
- Terraform v1.x
- Docker Desktop
- Docker Hub Image: `hiya855/url-shortener:latest`

## Project Structure
```
IAC_terraform/
├── main.tf              # Terraform configuration
├── execution_log.txt    # Command execution logs
└── README.md            # This file
```

---

## Workflow Flowchart

```
┌─────────────────────────────────┐
│        START                    │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│  STEP 1: Write main.tf          │
│  - Define required_providers    │
│  - Configure Docker provider    │
│  - Define docker_image resource │
│  - Define docker_container      │
│  - Add variables & outputs      │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│  STEP 2: terraform init         │
│  - Reads main.tf                │
│  - Detects required providers   │
│  - Downloads kreuzwerker/docker │
│    plugin from Terraform        │
│    Registry                     │
│  - Creates .terraform/ folder   │
│  - Creates .terraform.lock.hcl  │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│  STEP 3: terraform plan         │
│  - Compares main.tf with        │
│    current state                │
│  - Shows what WILL be created   │
│  - No actual changes made yet   │
│  - Symbols: + create            │
│             ~ update            │
│             - destroy           │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│  STEP 4: terraform apply        │
│  - Asks for confirmation (yes)  │
│  - Pulls image from Docker Hub  │
│  - Creates & starts container   │
│  - Writes terraform.tfstate     │
│  - Prints output values         │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│  STEP 5: terraform state list   │
│  - Shows all resources          │
│    tracked by Terraform         │
│  - Reads from tfstate file      │
│                                 │
│  terraform state show <name>    │
│  - Shows full details of one    │
│    resource (IP, ports, ID...)  │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│  STEP 6: Verify container       │
│  - docker ps                    │
│  - Open http://localhost:3000   │
│  - App is live!                 │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│  STEP 7: terraform destroy      │
│  - Shows resources to delete    │
│  - Asks for confirmation (yes)  │
│  - Stops & removes container    │
│  - Removes Docker image         │
│  - Clears terraform.tfstate     │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│        END                      │
│  Infrastructure fully removed   │
└─────────────────────────────────┘
```

---

## Step-by-Step Command Sequence

### Step 1 — Write `main.tf`
Create your Terraform configuration file with:
- Provider block (tells Terraform to use Docker)
- Variables (image name, container name, ports)
- `docker_image` resource (pulls image from Docker Hub)
- `docker_container` resource (creates and runs the container)
- Outputs (prints useful info after apply)

---

### Step 2 — `terraform init`
```bash
terraform init
```
**What happens internally:**
- Terraform reads the `required_providers` block in `main.tf`
- Contacts the Terraform Registry (`registry.terraform.io`)
- Downloads the `kreuzwerker/docker` provider plugin
- Creates `.terraform/` folder with the plugin binary
- Creates `.terraform.lock.hcl` to lock the provider version

---

### Step 3 — `terraform plan`
```bash
terraform plan
```
**What happens internally:**
- Reads your `main.tf` configuration
- Checks current `terraform.tfstate` (empty on first run)
- Calculates the difference (what needs to be created/changed/deleted)
- Displays the execution plan — no changes made to real infrastructure yet
- `+` = will create, `~` = will update, `-` = will destroy

---

### Step 4 — `terraform apply`
```bash
terraform apply
```
**What happens internally:**
- Shows the plan again and asks: `Enter a value: yes`
- Contacts Docker daemon via the Docker provider
- Pulls `hiya855/url-shortener:latest` from Docker Hub
- Creates and starts the container with port `3000:3000`
- Saves all resource details to `terraform.tfstate`
- Prints output values (container name, ID, app URL)

---

### Step 5 — `terraform state list`
```bash
terraform state list
```
**What happens internally:**
- Reads `terraform.tfstate` file
- Lists all resources currently managed by Terraform

```
docker_container.url_shortener
docker_image.url_shortener
```

```bash
terraform state show docker_container.url_shortener
```
- Shows full details of the container resource (IP, ports, hostname, image ID, etc.)

---

### Step 6 — Verify Container is Running
```bash
docker ps
```
Open in browser:
```
http://localhost:3000
```

---

### Step 7 — `terraform destroy`
```bash
terraform destroy
```
**What happens internally:**
- Reads `terraform.tfstate` to know what exists
- Shows destruction plan (all resources marked with `-`)
- Asks: `Enter a value: yes`
- Stops and removes the container
- Removes the Docker image (because `keep_locally = false`)
- Updates `terraform.tfstate` to empty

---

## Resources Provisioned
| Resource | Type | Description |
|----------|------|-------------|
| `docker_image.url_shortener` | `docker_image` | Pulls image from Docker Hub |
| `docker_container.url_shortener` | `docker_container` | Runs the URL shortener app on port 3000 |

---

## Key Concepts Learned
| Concept | Explanation |
|---------|-------------|
| **IaC** | Infrastructure defined in code, not manual clicks |
| **Provider** | Plugin that lets Terraform talk to a platform (Docker, AWS, etc.) |
| **terraform init** | Downloads required providers |
| **terraform plan** | Preview changes before applying |
| **terraform apply** | Actually creates the infrastructure |
| **terraform state** | Tracks real-world infrastructure in a `.tfstate` file |
| **terraform destroy** | Cleanly removes all provisioned resources |
| **Variables** | Makes config reusable, avoids hardcoding values |
| **Outputs** | Prints useful values after apply (URLs, IDs, etc.) |
