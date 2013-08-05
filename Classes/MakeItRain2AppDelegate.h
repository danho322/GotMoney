//
//  MakeItRain2AppDelegate.h
//  MakeItRain2
//
//  Created by Daniel Ho on 3/18/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MakeItRain2ViewController;

@interface MakeItRain2AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MakeItRain2ViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MakeItRain2ViewController *viewController;

@end

