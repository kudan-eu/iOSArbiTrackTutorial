#Kudan Tutorials - ArbiTrack Basics
-

This tutorial will go through the basics of using Kudan's ArbiTrack class. This will lead on from our tutorial which described how to add content to a marker.  If you have not already set up a project where you place content onto a marker, we suggest you check it out before going any further.

For this sample we have used:

* Model 	: ben.armodel / ben.jet 
* Model Texture : bigBenTexture.png
* Target Node : target.png

Which can all be downloaded [here](assets.zip).

###Initial Setup

Before you can use ArbiTrack you will need to set up an Android/iOS project with an ARActivity/ARCameraViewController. 

###Initialise ArbiTrack And Gyro Placer

ArbiTrack and the Gyro placer will need to be initialised before they can be used. As ArbiTrack and Gyro placer are singletons they can be called using getInstance from anywhere in the program. The gyro placer uses your device’s gyro to position a node and ArbiTrack locks your model in place instantly, by keeping track of arbitrary feature points.

Note: If you are in a low feature environment this can cause your tracking to be unstable.

~~~objectivec
// Initialise ArbiTrack
ARArbiTrackerManager *arbiTrack = [ARArbiTrackerManager getInstance];
[arbiTrack initialise];

// Initialise gyro placement. Gyro placement positions content on a virtual floor plane where the device is aiming.
ARGyroPlaceManager *gyroPlaceManager = [ARGyroPlaceManager getInstance];
[gyroPlaceManager initialise]; 
~~~

###Create Target Node
To position your model you will need to use a target node. As the target node’s position is altered by the GyroPlacer it is useful to have a graphical representation of where the target node is. We have used an image although using the same model is also possible. 

~~~objectivec
// Add a visual reticule to the target node for the user.
ARImageNode *targetImageNode = [[ARImageNode alloc] initWithImage:[UIImage imageNamed:@"target.png"]];
[gyroPlaceManager.world addChild:targetImageNode];
    
// Scale and rotate the image to the correct transformation.
[targetImageNode scaleByUniform:0.3];
[targetImageNode rotateByDegrees:90 axisX:1 y:0 z:0];

// Set the ArbiTracker target node to the node moved by the user.
arbiTrack.targetNode = targetImageNode;
~~~

###Start ArbiTrack

Starting ArbiTrack will lock your model in place. You may also wish to hide your target node as it will not reposition your model until ArbiTrack has been stopped.

~~~objectivec
//Starts ArbiTrack
[arbiTrack start];
    
//Hide target node
arbiTrack.targetNode.visible = NO;
    
//Change enum and label to reflect ArbiTrack state
__arbiButtonState = ARBI_TRACKING;
~~~

###Stopping ArbiTrack

You may wish to reposition your model in order to do this you will need to stop ArbiTrack and reveal your target node. You can restart ArbiTrack after this and your model will be locked to new possition of the target node.

Note: You can also adjust your model's position by altering the model’s position property.

~~~objectivec
// Display target node
arbiTrack.targetNode.visible = YES;
    
// Stop ArbiTrack
[arbiTrack stop];
    
//Change enum and label to reflect ArbiTrack state
__arbiButtonState = ARBI_PLACEMENT;

~~~
