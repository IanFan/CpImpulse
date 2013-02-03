//
//  OcpObject.m
//  BasicCocos2D
//
//  Created by Ian Fan on 13/12/12.
//
//

#import "OcpObject.h"

@implementation OcpObject

@synthesize chipmunkObjects,chipmunkBody,chipmunkShape,touchedShapes;

-(void)setChipmunkObjectsWithIsShapeCircleNotSquare:(BOOL)isCircleNotSquare mass:(float)mas sizeWidth:(int)sizeW sizeHeight:(int)sizeH positionX:(float)posX positionY:(float)posY elasticity:(float)elas friction:(float)fric collisionType:(NSString *)colliType {
  ChipmunkBody *body;
  ChipmunkShape *shape;
  cpFloat moment;
  
  if (isCircleNotSquare == YES) {
    moment = cpMomentForCircle(mas, 0, sizeH, cpv(0.0f, 0.0f));
    body = [[ChipmunkBody alloc] initWithMass:mas andMoment:moment];
    shape = [ChipmunkCircleShape circleWithBody:body radius:(0.5*sizeW) offset:CGPointMake(0, 0)];
  }else {
    moment = cpMomentForBox(mas, 0, sizeH);
    body = [[ChipmunkBody alloc]initWithMass:mas andMoment:moment];
    shape = [ChipmunkPolyShape boxWithBody:body width:sizeW height:sizeH];
  }
  
  [body setPos:cpv(posX, posY)];
  [shape setElasticity:elas];
  [shape setFriction:fric];
  [shape setCollisionType:colliType];
  [shape setData:self];
  
  NSArray *cpArray = [NSArray arrayWithObjects:body,shape, nil];
  
  self.chipmunkObjects = cpArray;
  self.chipmunkBody = body;
  self.chipmunkShape = shape;
  
  if (self.itemIamge != nil) {
    self.itemIamge.position = ccp(posX, posY);
    self.itemIamge.scaleX = 1.0*(sizeW/self.itemIamge.boundingBox.size.width);
    self.itemIamge.scaleY = 1.0*(sizeH/self.itemIamge.boundingBox.size.height);
  } else if (self.sprite != nil) {
    self.sprite.position = ccp(posX, posY);
    self.sprite.scaleX = 1.0*(sizeW/self.sprite.boundingBox.size.width);
    self.sprite.scaleY = 1.0*(sizeH/self.sprite.boundingBox.size.height);
  }
  
  [body release];
  [cpArray release];
}

-(void)update {
  if (self.itemIamge != nil) {
    self.itemIamge.position = chipmunkBody.pos;
    self.itemIamge.rotation = -CC_RADIANS_TO_DEGREES(chipmunkBody.angle);
  } else if (self.sprite != nil) {
    self.sprite.position = chipmunkBody.pos;
    self.sprite.rotation = -CC_RADIANS_TO_DEGREES(chipmunkBody.angle);
  }
}

-(id)init
{
  if ((self = [super init])) {
  }
  
  return self;
}

-(void)dealloc {
  self.sprite = nil;
  self.itemIamge = nil;
  
  self.chipmunkBody = nil;
  self.chipmunkShape = nil;
  self.chipmunkObjects = nil;
  
  [super dealloc];
}

@end
