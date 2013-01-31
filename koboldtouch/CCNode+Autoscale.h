//
//  CCNode+Autoscale.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 26.12.12.
//
//

#import "CCNode.h"

@class KTAutoscaleNodeProxy;

/** Autoscale category for CCNode. Handles insertion/removal of the autoscale proxy, and adds the will/didRenderFrame methods. */
@interface CCNode (Autoscale)

/** Set the class of KTAutoscaleNodeProxy. Minor performance optimization. */
+(void) setAutoscaleNodeProxyClass;

/** Returns the KTAutoscaleNodeProxy by returning userObject and casting it accordingly. This is used to determine if a CCNode uses autoscaling or not. */
-(KTAutoscaleNodeProxy*) autoscaleNodeProxy;

/** Allows KTAutoscaleNodeProxy to receive cleanup message, in order to remove itself from the CCNode. */
-(void) cleanupReplacement;

/** This method will be called instead of visit in order to send willRenderFrame and didRenderFrame before and after the actual visit method. */
-(void) visitReplacement;

/** Received just before the node renders itself (just before visit method runs). */
-(void) willRenderFrame;
/** Received just after the node rendered itself (just after visit method ran). */
-(void) didRenderFrame;

@end
