//
//  ARViewController.m
//  ArbiTrackTutorial
//
//  Created by Tom Smith on 06/05/2016.
//  Copyright © 2016 Tom Smith. All rights reserved.
//

#import "ARViewController.h"

typedef NS_ENUM(NSInteger, ArbiTrackState)
{
    ARBI_PLACEMENT,
    ARBI_TRACKING,
};

@interface ARViewController ()
{
    ArbiTrackState __arbiButtonState;
}

@property (nonatomic) ARModelNode *modelNode;
@property (weak, nonatomic) IBOutlet UIButton *arbiTrackButton;

@end

@implementation ARViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


// Sets up your AR content while running in the background thread
- (void)setupContent
{
    [self setupModel];
    [self setupArbiTrack];
}

- (void)setupModel
{
    
    // Import model
    ARModelImporter *importer = [[ARModelImporter alloc] initWithBundled:@"ben.armodel"];
    ARModelNode *modelNode = [importer getNode];
    
    // Apply ambient light to model mesh nodes
    for(ARMeshNode *meshNode in modelNode.meshNodes){
        ARLightMaterial *material = (ARLightMaterial *)meshNode.material;
        material.ambient.value = [ARVector3 vectorWithValuesX:0.8 y:0.8 z:0.8];;
        
    }
    
    // Scale model
    [modelNode scaleByUniform:0.25f];
    
    self.modelNode = modelNode;
}


- (void)setupArbiTrack
{
    // Create an image node to be used as a target node
    ARImageNode *targetImageNode = [[ARImageNode alloc] initWithImage:[UIImage imageNamed:@"target.png"]];
    
    // Scale and rotate the image to the correct transformation.
    [targetImageNode scaleByUniform:0.3];
    [targetImageNode rotateByDegrees:90 axisX:1 y:0 z:0];
    
    // Initialise gyro placement. Gyro placement positions content on a virtual floor plane where the device is aiming.
    ARGyroPlaceManager *gyroPlaceManager = [ARGyroPlaceManager getInstance];
    [gyroPlaceManager initialise];
    
    // Add target node to gyro place manager
    [gyroPlaceManager.world addChild:targetImageNode];
    
    // Initialise the arbiTracker
    ARArbiTrackerManager *arbiTrack = [ARArbiTrackerManager getInstance];
    [arbiTrack initialise];
    
    // Set the arbiTracker target node to the node moved by the user.
    arbiTrack.targetNode = targetImageNode;
    
    // Add model node to world
    [arbiTrack.world addChild:_modelNode];
}

- (IBAction)arbiTrackButtonPressed:(id)sender
{
    
    ARArbiTrackerManager *arbiTrack = [ARArbiTrackerManager getInstance];
    
    // If in placement mode start arbi track, hide target node and alter label
    if (__arbiButtonState == ARBI_PLACEMENT) {
        
        //Starts arbi Track
        [arbiTrack start];
        
        //Hide target node
        arbiTrack.targetNode.visible = NO;
        
        //Change enum and label to reflect Arbi Track state
        __arbiButtonState = ARBI_TRACKING;
        [self.arbiTrackButton setTitle:@"Stop Tracking" forState:UIControlStateNormal];
        
        return;
    }
    
    // If tracking stop tracking, show target node and alter label
    else if (__arbiButtonState == ARBI_TRACKING) {
        
        // Display target node
        arbiTrack.targetNode.visible = YES;
        
        // Stop arbi track
        [arbiTrack stop];
        
        //Change enum and label to reflect Arbi Track state
        __arbiButtonState = ARBI_PLACEMENT;
        [self.arbiTrackButton setTitle:@"Place Model" forState:UIControlStateNormal];
        
        return;
    }
}


@end
