FROM amazonlinux:2 as installer
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN yum update -y \
  && yum install -y unzip \
  && unzip awscliv2.zip \
  && ./aws/install --bin-dir /aws-cli-bin/

RUN curl -sS -L https://github.com/gruntwork-io/terragrunt/releases/download/v0.45.4/terragrunt_linux_arm64 -o ./terragrunt \
  && chmod u+x ./terragrunt \
  && mv ./terragrunt /usr/local/bin

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod u+x ./kubectl
RUN mv ./kubectl /usr/local/bin


RUN curl https://releases.hashicorp.com/terraform/1.4.5/terraform_1.4.5_linux_amd64.zip -o terraform_1.4.5_linux_amd64.zip \
  && unzip terraform_1.4.5_linux_amd64.zip \
  && mv terraform /usr/bin \
  && rm terraform_1.4.5_linux_amd64.zip

FROM jenkins/agent
COPY --from=docker /usr/local/bin/docker /usr/local/bin/
COPY --from=installer /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=installer /aws-cli-bin/ /usr/local/bin/
COPY --from=installer /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=installer /usr/bin/terraform /usr/local/bin/terraform
COPY --from=installer /usr/local/bin/terragrunt /usr/local/bin/
RUN chmod +x /usr/local/bin/terragrunt

