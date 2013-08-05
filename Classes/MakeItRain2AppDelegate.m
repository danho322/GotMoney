//
//  MakeItRain2AppDelegate.m
//  MakeItRain2
//
//  Created by Daniel Ho on 3/18/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MakeItRain2AppDelegate.h"
#import "MakeItRain2ViewController.h"

@implementation MakeItRain2AppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];  //hide status bar
	//[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;  //turn status area black
	
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
