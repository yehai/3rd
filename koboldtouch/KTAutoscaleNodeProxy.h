//
//  KTAutoscaleNodeProxy.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 26.12.12.
//
//

#import <Foundation/Foundation.h>

#import "KTAutoscaleController.h"

/** Proxy object that is added to a CCNode's userObject property. The proxy performs the scaling of the node's position.
 
 Note: You don't need to use or know about this class' details. */
@interface KTAutoscaleNodeProxy : NSObject
{
}

/** Reference to the node whose userObject will point to the proxy. */
@property (nonatomic, readonly) CCNode* node;
/** Weak reference to the autoscale controller which provides the scale factor. */
@property (nonatomic, weak) KTAutoscaleController* autoscaleController;
/** Which of the node's properties should be scaled. */
@property (nonatomic) KTAutoscaleProperty scaledProperties;
/** Contains the unscaledPosition which will be updated just before rendering and used to set the position back just after rendering. */
@property (nonatomic) CGPoint unscaledPosition;

-(id) initWithNode:(CCNode*)node autoscaleController:(KTAutoscaleController*)autoscaleController;
-(void) cleanup;

/** Returns the position scaled by scale factors, provided that position scaling is enabled. */
-(CGPoint) scaledPosition:(CGPoint)position;

@end
