

# TOY ROBOT Simulator
A robot simulator where you can navigate a platform together with your friends.

## Client Side

### CLI
You can connect via TCP and navigate using the CLI:
``telnet 159.65.236.207 5001``
#### Commands
- PLACE X Y F - Start the robot at the given coordinates, ex: PLACE 1 1 NORTH
- MOVE - Moves in the direction of the robot
- LEFT - Rotate the robot 90º to the left
- RIGHT  - Rotate the robot 90º to the right
- REPORT - Current position of the robot

  
### Front End
![Interface](public/print.png)

You can navigate through the interface at:
http://159.65.236.207:8080/

#### Build local
To build the local application, you will need docker compose installed and run the `docker-compose up` command with free ports 6379, 3000, 5001 and 8080.

#### Docker command without docker compose
```
docker network create network_toy && \
docker run -d --name redis --network network_toy -p 6379:6379 redis:6.2 && \
docker build -t web_app . && \
docker run -d --name web_app --network network_toy -p 3000:3000 -p 5001:5001  -e REDIS_URL=redis://redis:6379/1 my_web_app && \
docker run -d --name robo_front --network network_toy -p 8080:8080 -e VUE_APP_BACKEND_URL=localhost:3000 malves224/toy_robot_front:latest
```

#### Bonus - Multiplayer
Invite your friends to navigate with you! Yes, it's possible to play online together!



