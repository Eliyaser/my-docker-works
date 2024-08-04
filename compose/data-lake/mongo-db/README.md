1. Clone the repository:
    ```sh
    sudo git clone https://github.com/Eliyaser/my-docker-works.git
    sudo chown -R $USER:$USER /opt/my-docker-works
    cd /opt/my-docker-works
    ```

#to start the data lake mango-db project

  ```sh
sudo docker compose -f compose/data-lake/mongo-db/main.yml --env-file compose/data-lake/mongo-db/Dev.env -p mangodb-cluster up -d
 ```


#Initiate the Replica Set

```
docker exec -it mongo1 mongosh --eval "rs.initiate({
 _id: \"myReplicaSet\",
 members: [
   {_id: 0, host: \"mongo1\"},
   {_id: 1, host: \"mongo2\"},
   {_id: 2, host: \"mongo3\"}
 ]
})"
```

##Test and Verify the Replica Set
```
docker exec -it mongo1 mongosh --eval "rs.status()"

docker stop mongo1

docker exec -it mongo2 mongosh --eval "rs.status()"

docker start mongo1

```
