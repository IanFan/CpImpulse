//
//  ChipmunkCollisionHandlerLayer.h
//  BasicCocos2D
//
//  Created by Fan Tsai Ming on 19/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import <UIKit/UIKit.h>
#import "ObjectiveChipmunk.h"
#import "SimpleAudioEngine.h"
#import "OcpObject.h"

@interface ChipmunkCollisionHandlerLayer : CCLayer
{
  ChipmunkSpace *space;
  OcpObject *cpObject;
  CCLayerColor *bgLayerColor;
}

+(CCScene *) scene;

- (void)update:(ccTime)dt;

- (BOOL)beginCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space;
- (void)postSolveCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space;
- (void)separateCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space;

@end
