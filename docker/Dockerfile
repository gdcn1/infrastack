FROM alpine:latest

RUN apk add --update --no-cache bash openssh git jq curl py3-pip && \
    pip3 install --upgrade pip && \
    pip3 install pre-commit && \
    wget -O /tmp/terraform.zip $(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].builds[].url' | egrep 'terraform_[0-9]\.[0-9]{1,2}\.[0-9]{1,2}_linux.*amd64' | sort -V | tail -1) && \
    unzip /tmp/terraform.zip -d /usr/local/bin/ && chmod +x /usr/local/bin/terraform && rm /tmp/terraform.zip && \
    curl -sLO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl && \
    curl -sL https://get.helm.sh/helm-v3.1.0-linux-amd64.tar.gz |tar xvz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && rm -rf linux-amd64 && \
    curl -sL "$(curl -Ls https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" -o tflint.zip && unzip tflint.zip && rm tflint.zip && \
    mv ./tflint /usr/local/bin/tflint && chmod +x /usr/local/bin/tflint && \
    scversion="stable" && wget -qO- "https://github.com/koalaman/shellcheck/releases/download/${scversion?}/shellcheck-${scversion?}.linux.x86_64.tar.xz" | tar -xJv && \
    mv "shellcheck-${scversion}/shellcheck" /usr/local/bin/shellcheck && chmod +x /usr/local/bin/shellcheck && rm -rf  "shellcheck-${scversion}"
