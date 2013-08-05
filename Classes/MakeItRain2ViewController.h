//
//  MakeItRain2ViewController.h
//  MakeItRain2
//
//  Created by Daniel Ho on 3/18/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioServices.h>

@interface MakeItRain2ViewController : UIViewController {
	IBOutlet UIImageView *dollar;	//dollar being moved around
	IBOutlet UIImageView *fanView;	//used for animating fanning
	IBOutlet UILabel *myLabel;
	IBOutlet UILabel *offsetLabel;
		
	NSInteger gameState;
	CGPoint offset;
	CGPoint lastPoint;
	CGPoint dollarVelocity;
	CGPoint lastVelocity;
	
	NSInteger touchCountdown;	//countdown after touchesEnded
	SystemSoundID pmph1;	//for swish
	SystemSoundID pmph2;	//for music
}

@property(nonatomic, retain) IBOutlet UIImageView *fanView;
@property(nonatomic, retain) IBOutlet UIImageView *dollar;
@property(nonatomic, retain) IBOutlet UILabel *myLabel;
@property(nonatomic, retain) IBOutlet UILabel *offsetLabel;

@property(nonatomic) CGPoint offset;
@property(nonatomic) CGPoint lastPoint;
@property(nonatomic) CGPoint dollarVelocity;
@property(nonatomic) CGPoint lastVelocity;

@end

