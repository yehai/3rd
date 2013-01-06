//
//  KTPhysicsDebugViewController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 29.09.12.
//
//

#import "KTViewController.h"

@class KTPhysicsController;

/** The physics-engine agnostic debug view controller. For Box2D, enables the GLES-Render and b2DebugDraw overlay.
 Note: it matter where you add this view controller in the hierarchy. You definitely want to add this after all of the
 physics-controlled views, otherwise their sprites will be drawn over the debug view. */
@interface KTPhysicsDebugViewController : KTViewController

/** Initializes the debug view controller with a physics controller instance. It returns either a Box2D or Chipmunk specific
 implementation. */
+(id) physicsDebugViewControllerWithPhysicsController:(KTPhysicsController*)physicsController;

@end
