#!/bin/bash
source ./services_helpers.sh
source ./service_data_new.sh

#Creating Secret Key and Patching Account

kubectl create -f secret.yaml
kubectl create -f pg-secrert.yaml 
kubectl patch serviceaccount default -p "{\"imagePullSecrets\": [{\"name\": \"datazoomsecret\"}]}"

#Creating datadog pods for monitoring 

#kubectl apply -f services/datadog/kube-state-metrics

#kubectl create -f services/datadog/dd-agent-rbac.yaml

#kubectl create -f services/datadog/datadog-agent.yaml

# Scripts to copy out the dbinit scripts

echo " Remove Exited containers -- "

sudo docker ps -a | grep created | cut -d ' ' -f 1 | xargs sudo docker rm
sudo docker rmi $(sudo docker images -q)

# Creating Casandara Postgres and other DB's

echo ">>>>>>>>>>>  Creating Cassandra and independant depservices  "
#kubectl create -f services/dz-databases

echo "+++++++++++++++   Wait to create Cassandra "
#sleep 180

# Introducing health check for Cassandra

echo "Checking cassandra pods status"
./dz-cas-healthcheck.sh

echo "Checking cassandra cluster health"
# cassandra cluster check
./dz-cas-cluster-check.sh

#Init datadog on postgress
cd services/datadog/
pwd
#echo "running Init on datadog"
#./datadoginit.sh
#cd ../../
#pwd



# Task to pull out dbinit scripts from services and restore it to Cassandra

echo " ############## Creating containers to copy dbinit :  "
cassandra_pod=`kubectl get pods | grep dz-cassandra | xargs | cut -f 1 -d ' '`
postgres_pod=`kubectl get pods | grep dz-postgres | xargs | cut -f 1 -d ' '`


echo "Bringing up kong with migration as job while dbinit take places"
#kubectl create -f services/kong-mig/dz-kong-migration.yaml


echo " Let's begin              =++++++++++++++++++++="
serviceindex=0

mkdir servicefiles
cd servicefiles

for service in "${depservices[@]}"
do
	  echo "${service}"
	    pwd
	      mkdir -p ${depservicesdir[$serviceindex]}
	        service_name=${depservicesdir[$serviceindex]}
		  service_image_name=${depserviceimage[$serviceindex]}
		    echo "Creating contaner : " $service_name
		      echo " With image : " $service_image_name

		        echo "---------------------------------"


			  sudo docker container create  --name $service_name  $service_image_name bash cmd
			    echo "docker container created for :  " $service_name 
			      sudo docker ps -aqf name=$service_name
			        echo "                       >>>>            "
				  service_container=`sudo docker ps -aqf name=$service_name`
				    echo $service_name $service_container
				      sudo docker cp $service_container:/usr/app/build/repos/$service_name/dbinit.cql $service_name/dbinit.cql
				        sudo docker cp $service_container:/usr/app/build/repos/$service_name/routeall.sh $service_name/routeall.sh
					  sudo docker cp $service_container:/usr/app/build/repos/$service_name/dbinit.psql $service_name/dbinit.psql
					    echo " Copying to local dir " $service_name
					      echo " ---- "
					        echo "Lets see whats inside " $service_name
						  ls -al $service_name
						    echo $service_name
						      echo "--"
						        echo "========================"
							  sudo docker rm $service_container
							    echo "Deleted container : " $service_container $service_name

							      kubectl cp $service_name/dbinit.cql $cassandra_pod:/tmp/
							        echo "copied to cassandra " $cassandra_pod
								  echo " Running cql init for  " $service_name
								    dbinitcql ${depservicescqlinit[$serviceindex]}

								      echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

								        kubectl cp $service_name/dbinit.psql $postgres_pod:/tmp/ 
									  echo "copied to postgres  " $postgres_pod
									    echo " Running psql init for  " $service_name
									      dbinitpsql ${depservicespsqlinit[$serviceindex]} 


									        echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"


										  serviceindex=$(($serviceindex+1))
									  done

									  cd ..
									  # Bringup Kong for Migration up and deleting it after the migration up task is completed

									  echo "Bringing up kong with migration as job"
									  #kubectl create -f services/kong-mig/dz-kong-migration.yaml
									  #sleep 120
									  kubectl delete -f services/kong-mig/dz-kong-migration.yaml
									  echo "Kong job deleted"
									  sleep 30
									  echo " Let's create Kong "
									  kubectl create -f services/dz-kong/
									  sleep 10
									  echo "Creating Zookeeper "
									  kubectl create -f services/dz-zookeeper/
									  sleep 10
									  echo " Let's create Kafka "
									  kubectl create -f services/dz-kafka/
									  sleep 10


									  echo "Creating Beacon engine and services "
									  kubectl create -f services/dz-beacon-service/
									  kubectl create -f services/dz-beacon-engine/

									  echo "Creating Beacon engine admin frontend Backend and ui"
									  kubectl create -f services/dz-ui/
									  #kubectl create -f services/dz-admin-ui/
									  kubectl create -f services/dz-admin-backend/
									  kubectl create -f services/dz-admin-frontend/

									  echo "Creating broker analytics wrapper and management"
									  kubectl create -f services/dz-message-broker/
									  kubectl create -f services/dz-analytics-proxy/
									  kubectl create -f services/dz-cache-wrapper/
									  kubectl create -f services/dz-configuration-management/
									  #kubectl create -f services/dz-user-management-service/

									  echo "Creating Connectors "
									  kubectl create -f services/dz-connector-admin/
									  kubectl create -f services/dz-connectors/

									  echo " Creating exposed services"
									  kubectl create -f svc/

									  echo " Lets wait few min... "
									  sleep 240

									  #Checking Kong and cassandra health

									  echo "Checking health on kong and cassandra"
									  ./dz-dev-healthcheck.sh

									  echo " Set route------ :   "

									  # Run  Route all
									  #copy routeall to kong

									  kong_pod=`kubectl get pods | grep dz-kong | xargs | cut -f 1 -d ' '`
									  echo "Copying post route scripts to kong : "  $kong_pod
									  kubectl cp routeall.sh  $kong_pod:/tmp/

									  # install curl and curl-dev on kong and proceed with routing
									  kubectl exec -it $kong_pod  -- bash -c "apk update; apk add curl; apk add curl-dev"
									  kubectl exec -it $kong_pod -- bash -c "cd /tmp;bash routeall.sh"


									  cd post
									  ./postscript.sh

									  cd ..
									  echo " All done "

									  kubectl get pods -o wide --show-all
									  kubectl get svc --show-all
									  :
