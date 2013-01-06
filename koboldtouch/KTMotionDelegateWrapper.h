//
//  KTMotionDelegateWrapper.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 27.10.12.
//
//

#import "KTMotionController.h"

// internal use only
@interface KTMotionDelegateWrapper : NSObject
{
	@private
	__weak KTMotionController* _motionController;
	BOOL _implementsDidAccelerate;
}

@property (nonatomic, weak) id<KTMotionProtocol> delegate;

-(id) initWithDelegate:(id<KTMotionProtocol>)delegate motionController:(KTMotionController*)motionController;

-(void) sendAccelerometerDidAccelerate:(KTAccelerometerData*)accelerometerData;

@end
