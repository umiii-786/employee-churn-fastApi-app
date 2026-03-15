#!/bin/bash

            
docker stop churn-app || true
docker rm churn-app || true

docker run -d -p 80:8000 \
            --restart unless-stopped \
            -e DAGSHUB_PAT=a55ae4d7356bf84fa662753c4cff9084c43da67d \
            --name churn-app \
            528043283929.dkr.ecr.ap-south-1.amazonaws.com/churn-application-image:v1

docker logs churn-app --tail 50