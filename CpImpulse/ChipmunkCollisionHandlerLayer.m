//
//  ChipmunkCollisionHandlerLayer.m
//  BasicCocos2D
//
//  Created by Fan Tsai Ming on 19/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChipmunkCollisionHandlerLayer.h"
#import "AppDelegate.h"

static NSString *borderType = @"borderType";
static NSString *cpObjectType = @"cpObjectType";

@implementation ChipmunkCollisionHandlerLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];	
	ChipmunkCollisionHandlerLayer *layer = [ChipmunkCollisionHandlerLayer node];
	[scene addChild: layer];
  
	return scene;
}

#pragma mark - TouchEvent

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  float speed = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 1000:500;
  cpObject.chipmunkBody.vel = cpv(-speed+2*speed*CCRANDOM_0_1(), -speed+2*speed*CCRANDOM_0_1());
}

#pragma mark -
#pragma mark ChipmunkCollisionHandler

-(BOOL)beginCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space{
  // This macro gets the colliding shapes from the arbiter and defines variables for them.
  CHIPMUNK_ARBITER_GET_SHAPES(arbiter, cpObjectShape, border);
  
  // It expands to look something like this:
	// ChipmunkShape *buttonShape = GetShapeWithFirstCollisionType();
	// ChipmunkShape *border = GetShapeWithSecondCollisionType();
  
  // When we created the collision shape for the FallingButton,
	// we set the data pointer to point at the FallingButton it was associated with.
  OcpObject *ocp = cpObjectShape.data;
  
  // Increment the touchedShapes counter on the FallingButton object.
	// We'll decrement this in the separate callback.
	// If the counter is 0, then you know you aren't touching anything.
	// You can use this technique in platformer games to track if the player is in the air on not.
  ocp.touchedShapes ++;
  
  // Change the background color so we know when the button is touching something.
  [bgLayerColor setColor:ccc3(CCRANDOM_0_1()*255, CCRANDOM_0_1()*255, CCRANDOM_0_1()*255)];
  
  return TRUE;
}

// The post-solve collision callback is called right after Chipmunk has finished calculating all of the
// collision responses. You can use it to find out how hard objects hit each other.
// There is also a pre-solve callback that allows you to reject collisions conditionally.
-(void)postSolveCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space{
  // We only care about the first frame of the collision.
	// If the shapes have been colliding for more than one frame, return early.
  if (!cpArbiterIsFirstContact(arbiter)) return;
  
  // This method gets the impulse that was applied between the two objects to resolve
	// the collision. We'll use the length of the impulse vector to approximate the sound
	// volume to play for the collision.
  cpFloat impulse = cpvlength(cpArbiterTotalImpulse(arbiter));
  float volume = MIN(impulse/1600, 1.0f);
  if (volume > 0.05f) {
    CCLOG(@"volume = %f",volume);
    [[SimpleAudioEngine sharedEngine] setEffectsVolume:volume];
    [[SimpleAudioEngine sharedEngine] playEffect:@"kickBall.mp3"];
  }
}

static CGFloat frand(){return (CGFloat)rand()/(CGFloat)RAND_MAX;}

// The separate callback is called whenever shapes stop touching.
-(void)separateCollision:(cpArbiter *)arbiter space:(ChipmunkSpace *)space{
  CHIPMUNK_ARBITER_GET_SHAPES(arbiter, ocpObjectShape, border);
  
  // Decrement the counter on the FallingButton.
  OcpObject *ocp = ocpObjectShape.data;
  ocp.touchedShapes --;
  
  // If touchedShapes is 0, then we know the falling button isn't touching anything anymore.
  if (ocp.touchedShapes == 0) {
  }
}

#pragma mark -
#pragma mark Update

-(void)update:(ccTime)dt {
  [space step:(dt)];
  
  [cpObject update];
}

/*
 Target: Detect the impulse while the ball is hitting the border.
 
 1. Setup ChipmunkSpace, ChipmunkMultiGrab, DebugLayer and update as usual.
 2. Setup OcpObject to create the ball, tap the ball will change it's velocity.
 3. Setup Collision Handler to detect while the ball is hitting the border.
 4. When detect it, the background color will be changed and the sound will be made.
 */

#pragma mark -
#pragma mark Init

-(id) init
{
	if( (self=[super init])) {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    [[SimpleAudioEngine sharedEngine]preloadEffect:@"kickBall.mp3"];
    
    // Create and initialize the Chipmunk space.
    // Chipmunk spaces are containers for simulating physics.
    // You add a bunch of objects and joints to the space and the space runs the physics simulation on them all together.
    space = [[ChipmunkSpace alloc]init];
    
    // This method adds four static line segment shapes to the space.
    // Most 2D physics games end up putting all the gameplay in a box. This method just makes that easy.
    // We'll tag these segment shapes with the borderType object. You'll see what this is for next.
    [space addBounds:CGRectMake(0, 0, winSize.width, winSize.height) thickness:30.0f elasticity:1.0f friction:0.0f layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
    
    // This adds a callback that happens whenever a shape tagged with the
    // [FallingButton class] object and borderType objects collide.
    // You can use any object you want as a collision type identifier.
    // I often find it convenient to use class objects to define collision types.
    // There are 4 different collision events that you can catch: begin, pre-solve, post-solve and separate.
    // See the documentation for a description of what they are all for.
    [space addCollisionHandler:self typeA:cpObjectType typeB:borderType begin:@selector(beginCollision:space:) preSolve:nil postSolve:@selector(postSolveCollision:space:) separate:@selector(separateCollision:space:)];
    
    // You have to actually put things in a Chipmunk space for it to do anything interesting.
    cpObject = [[OcpObject alloc]init];
    
    cpObject.sprite = [CCSprite spriteWithFile:@"ball.png"];
    [cpObject setChipmunkObjectsWithIsShapeCircleNotSquare:YES mass:1.0 sizeWidth:100 sizeHeight:100 positionX:winSize.width/2 positionY:winSize.height/2 elasticity:1.0 friction:0.0 collisionType:cpObjectType];
    
    // Adding physics objects in Objective-Chipmunk is a snap thanks to the ChipmunkObject protocol.
    // No matter how many physics objects (collision shapes, joints, etc) the fallingButton has, it can be added in a single line!
    [space add:cpObject];
    
    [self addChild:cpObject.sprite];
    
    bgLayerColor = [[CCLayerColor alloc]initWithColor:ccc4(CCRANDOM_0_1()*255, CCRANDOM_0_1()*255, CCRANDOM_0_1()*255, 255) width:winSize.width height:winSize.height];
    [self addChild:bgLayerColor z:-1];
    
    [self schedule:@selector(update:)];
    
    self.isTouchEnabled = YES;
	}
	return self;
}

- (void) dealloc
{
  [cpObject release];
  
	[super dealloc];
}

@end
