FROM amazonlinux:2 as installer
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN yum update -y \
  && yum install -y unzip \
  && unzip awscliv2.zip \
  && ./aws/install --bin-dir /aws-cli-bin/

RUN curl -sS -L https://github.com/gruntwork-io/terragrunt/releases/download/v0.45.4/terragrunt_linux_amd64 -o ./terragrunt \
  && chmod +x ./terragrunt \
  && mv ./terragrunt /usr/local/bin

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod u+x ./kubectl
RUN mv ./kubectl /usr/local/bin


RUN curl https://releases.hashicorp.com/terraform/1.4.5/terraform_1.4.5_linux_amd64.zip -o terraform_1.4.5_linux_amd64.zip \
  && unzip terraform_1.4.5_linux_amd64.zip \
  && mv terraform /usr/local/bin \
  && rm terraform_1.4.5_linux_amd64.zip

RUN yum install -y git \
  && chmod u+x /usr/bin/git

RUN curl https://github.com/mikefarah/yq/releases/download/v4.27.5/yq_linux_amd64 -o yq_linux_amd64 \
  && mv yq_linux_amd64 /usr/local/bin/yq \
  && chmod u+x /usr/local/bin/yq


FROM jenkins/agent
COPY --from=docker /usr/local/bin/docker /usr/local/bin/
COPY --from=installer /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=installer /aws-cli-bin/ /usr/local/bin/
COPY --from=installer /usr/local/bin/ /usr/local/bin/
COPY --from=installer /usr/bin/ /usr/local/bin/

