#ifndef MODULES_DIRECTORY
    #define MODULES_DIRECTORY node_modules
#endif

class enigmaTraffic {
    class civilian {
        file = MODULES_DIRECTORY\enigmaTraffic\functions\civilian;

        class addFleeingBehaviour {};
        class fleeYouFool {};
        class randomCivilian {};
        class stripUnit {};
   };
   class common {
      file = MODULES_DIRECTORY\enigmaTraffic\functions\common;

      class configAndStart {};
      class markerExists {};
      class positionIsInsideMarker {};
      class init {postInit = 1;};
   };
   class debug {
         file = MODULES_DIRECTORY\enigmaTraffic\functions\debug;

         class deleteDebugMarkerAllClients {};
         class deleteDebugMarkerLocal {};
         class initDebug {};
         class setDebugMarkerAllClients {};
         class setDebugMarkerLocal {};
         class showDebugTextAllClients {};
         class showDebugTextLocal {};
   };
   class server {
        file = MODULES_DIRECTORY\enigmaTraffic\functions\server;

        class findEdgeRoads {};
        class findSpawnSegment {};
        class moveVehicle {};
        class startTraffic {};
   };
   class vehicle {
       file = MODULES_DIRECTORY\enigmaTraffic\functions\vehicle;

       class createCargo {};
       class createDriver {};
       class createRebelVehicle {};
   };
};
