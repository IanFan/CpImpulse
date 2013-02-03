//
//  OcpObject.h
//  BasicCocos2D
//
//  Created by Ian Fan on 13/12/12.
//
//

#import "ObjectiveChipmunk.h"
#import "cocos2d.h"

@interface OcpObject : NSObject <ChipmunkObject>
{
}

@property (nonatomic,retain) ChipmunkBody *chipmunkBody;
@property (nonatomic,retain) ChipmunkShape *chipmunkShape;
@property (nonatomic,retain) NSArray *chipmunkObjects;
@property int touchedShapes;

@property (nonatomic,retain) CCSprite *sprite;
@property (nonatomic,retain) CCMenuItemImage *itemIamge;

-(void)setChipmunkObjectsWithIsShapeCircleNotSquare:(BOOL)isCircleNotSquare mass:(float)mas sizeWidth:(int)sizeW sizeHeight:(int)sizeH positionX:(float)posX positionY:(float)posY elasticity:(float)elas friction:(float)fric collisionType:(NSString*)colliType;
-(void)update;

@end
