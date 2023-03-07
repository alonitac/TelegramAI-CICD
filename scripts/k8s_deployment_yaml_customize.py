import yaml
import os


env = os.getenv("APP_ENV")
image = os.getenv("BOT_IMAGE_NAME")
file_to_save = f'infra/k8s/{os.getenv("K8S_DEPLOYMENT_FILE")}'

with open(f"{file_to_save}") as file:
    y = yaml.safe_load(file)
    y["metadata"]["labels"]["env"] = env
    y["spec"]["selector"]["matchLabels"]["env"] = env
    y["spec"]["template"]["metadata"]["labels"]["env"] = env
    y["spec"]["template"]["spec"]["containers"][0]["image"] = image

with open(file_to_save, 'w') as deploy:
    yaml.dump(y, deploy)
