//
//  MakeItRain2ViewController.m
//  MakeItRain2
//
//  Created by Daniel Ho on 3/18/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MakeItRain2ViewController.h"
#define SLOWDOWN .97
#define NOTANIMATING 0	//gamestate
#define FANOUT 1
#define FANIN 2
#define ANIMATING 3
#define WAITTIME 12		//amount of iterations of gameloop to wait until the stack actually fans out on touchesbegan
#define VELOCITYSOUNDTHRESH 30	//how fast a dollar must go for the swish sound

@implementation MakeItRain2ViewController
@synthesize fanView, dollar, myLabel, offsetLabel, offset, lastPoint, dollarVelocity, lastVelocity;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	lastPoint = dollar.center;
	dollarVelocity.x = 0;
	dollarVelocity.y = 0;
	touchCountdown = 0;
	gameState = NOTANIMATING;
	
	//UIImageView *animateView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
	//animateView.animationImages = [NSArray arrayWithObjects: [UIImage imageNamed:@"02.png"], [UIImage imageNamed:@"23.png"], [UIImage imageNamed:@"55.png"], nil];
	//animateView.animationDuration = 0.40;
	//animateView.animationRepeatCount = 0;
	//[animateView startAnimating];
	[fanView setAlpha:0.0f];
	[dollar setAlpha:1.0f];
	//[fanView addSubview:animateView];
	//[animateView release];
	
	id sndpath = [[NSBundle mainBundle] pathForResource:@"swoosh" ofType:@"wav" inDirectory:@"/"];
	CFURLRef baseURL = (CFURLRef)[[NSURL alloc] initFileURLWithPath:sndpath];
	AudioServicesCreateSystemSoundID(baseURL, &pmph1);
	//sndpath = [[NSBundle mainBundle] pathForResource:@"fatjoerain" ofType:@"mp3" inDirectory:@"/"];
	//baseURL = (CFURLRef)[[NSURL alloc] initFileURLWithPath:sndpath];
	//AudioServicesCreateSystemSoundID(baseURL, &pmph2);
	
	[NSTimer scheduledTimerWithTimeInterval:0.020 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}

-(void) gameLoop {
	CGPoint current = dollar.center;
	if (gameState == FANIN){
		if (![fanView isAnimating]){
			gameState = NOTANIMATING;
			[fanView setAlpha:0.0f];	
			[dollar setAlpha:1.0f];
			current.x = 160;
			current.y = 240;
			dollar.center = current;
			AudioServicesPlaySystemSound(pmph2);
			dollarVelocity.x = 0;
			dollarVelocity.y = 0;
		} 
	} else if (gameState == FANOUT){ 
		
		if (touchCountdown < WAITTIME){
			//keep track of how far along the fanout animation is
			touchCountdown ++;
		} else if (touchCountdown == WAITTIME) {
			[fanView setAlpha:1.0f];
			[dollar setAlpha:0.0f];
			touchCountdown ++;
		}
	} 
	if (gameState == NOTANIMATING){	//record velocity, dollar is being touched
		lastVelocity = dollarVelocity;
		dollarVelocity.x = current.x - lastPoint.x;
		dollarVelocity.y = current.y - lastPoint.y;
		
	} else {					//move dollar, dollar was flicked and not touched
		//use last velocity just to compensate for quick stop
		current.x = dollar.center.x + lastVelocity.x;
		current.y = dollar.center.y + lastVelocity.y;
		dollar.center = current;
		lastVelocity = dollarVelocity;
		dollarVelocity.x = dollarVelocity.x * SLOWDOWN;
		dollarVelocity.y = dollarVelocity.y * SLOWDOWN;
	}
	if (!(current.x > -93 && current.x < 412 && current.y > -202 && current.y < 662)){	//dollar is offscreen
		current.x = 160;
		current.y = 240;
		dollar.center = current;
		if (abs(dollarVelocity.x) > VELOCITYSOUNDTHRESH || abs(dollarVelocity.y) > VELOCITYSOUNDTHRESH){
			AudioServicesPlaySystemSound(pmph1);
		}
		AudioServicesPlaySystemSound(pmph2);
		dollarVelocity.x = 0;
		dollarVelocity.y = 0;
		gameState = NOTANIMATING;
	} else {
		if (touchCountdown > 0 && gameState != FANOUT && gameState!= FANIN) 
			touchCountdown --;
	}
	lastPoint = dollar.center;
	
	//[myLabel setText:[NSString stringWithFormat:@"%f, %f",dollarVelocity.x, dollarVelocity.y]];
	//check gamestate, if no touching, keep track of iterations
	//if iterations is greater than NUM, fade out music
	//create second sound, one for music, one for FTFTFT
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
	
	//if ((UIImageView *)temp == dollar){
		offset.x = location.x - dollar.center.x;
		offset.y = location.y - dollar.center.y;
		
	//}
	touchCountdown = 0;
	if (location.x>110 && location.x<220 && location.y>390){
		gameState = FANOUT;
		[fanView setImage: [UIImage imageNamed:@"49.png"]];
		fanView.animationDuration = .63;
		fanView.animationRepeatCount = 1;
		fanView.animationImages = [NSArray arrayWithObjects: 
								   [UIImage imageNamed:@"01 stack.png"], [UIImage imageNamed:@"01 stack.png"], [UIImage imageNamed:@"01 stack.png"], [UIImage imageNamed:@"01 stack.png"],
							   [UIImage imageNamed:@"01 stack.png"], [UIImage imageNamed:@"02.png"], [UIImage imageNamed:@"10.png"], [UIImage imageNamed:@"18.png"], 
							[UIImage imageNamed:@"26.png"], [UIImage imageNamed:@"32.png"], [UIImage imageNamed:@"40.png"], [UIImage imageNamed:@"48.png"], nil];
		[fanView startAnimating];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint location = [touch locationInView:touch.view];
	
	//[offsetLabel setText:[NSString stringWithFormat:@"%d, %d",abs(location.x - dollar.center.x),abs(location.y - dollar.center.y)]];
	if (location.x>110 && location.x<220 && location.y>390 && gameState == FANOUT){
		return;
	} 
	if (abs(location.x-dollar.center.x) > 120 || abs(location.y-dollar.center.y) > 190){
		return;
	}
		
	//if (gameState == FANOUT){
		gameState = NOTANIMATING;
		[fanView setAlpha:0.0f];
		[dollar setAlpha:1.0f];
	//}
	
	location.x = location.x - offset.x;
	location.y = location.y - offset.y;
	dollar.center = location;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (gameState == FANOUT){
		if (touchCountdown > WAITTIME){
			touchCountdown = 20;
			gameState = FANIN;
			[fanView setImage:[UIImage imageNamed:@"02.png"]];
			fanView.animationDuration = 0.40;
			fanView.animationRepeatCount = 1;
			fanView.animationImages = [NSArray arrayWithObjects: [UIImage imageNamed:@"48.png"], [UIImage imageNamed:@"40.png"], [UIImage imageNamed:@"32.png"], 
								   [UIImage imageNamed:@"26.png"], [UIImage imageNamed:@"18.png"], [UIImage imageNamed:@"10.png"], nil];
			[fanView startAnimating];
		} else {
			[fanView setImage:[UIImage imageNamed:@"01 stack.png"]];
			[fanView stopAnimating];
			gameState = NOTANIMATING;
		}
	} else {
		gameState = ANIMATING;
		touchCountdown = 0;
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
	[dollar release];
	[myLabel release];
}

@end
