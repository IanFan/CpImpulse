//
//  AppDelegate.h
//  BasicCocos2D
//
//  Created by Fan Tsai Ming on 11/07/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

typedef enum {
	RotateOnlyPortrait = 1,
  RotateOnlyPortraitUpsideDown = 2,
  RotateOnlyLandscapeLeft = 3,
  RotateOnlyLandscapeRight = 4,
  RotateIsPortrait = 5,
  RotateIsLandscape = 6,
  RotateAllExceptPortraitUpsideDown = 7,
	RotateAll = 8,
} ShouldRotateDirection;

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
//	UINavigationController *navController_;
  UINavigationController *navController;
  
  CCGLView *glView;
	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
//@property (readonly) UINavigationController *navController;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;

+(AppController *)sharedAppDelegate;

@end
