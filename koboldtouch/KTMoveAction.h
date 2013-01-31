//
//  KTMoveAction.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 16.01.13.
//
//

#import "KTAction.h"

/** Changes the position property of the KTEntityModel until it has arrived at the target location.
 Supports movement to absolute position or by relative position (offset). Can be initialized either with
 a desired time (duration) until destination is reached or with a given speed the object should move at.
 */
@interface KTMoveAction : KTAction
{
	@private
	CGPoint _startPosition;
	CGPoint _destination;
	CGPoint _deltaPosition;
	float _speed;
	BOOL _destinationIsOffset;
}

/** Create a move action with duration (in seconds) and a destination position (in points). Similar to CCMoveTo. */
+(id) actionWithDuration:(float)duration destination:(CGPoint)destination;
/** Create a move action with a speed (in points per frame) and a destination position (in points). Similar to CCMoveTo. */
+(id) actionWithSpeed:(float)speed destination:(CGPoint)destination;

/** Create a move action with duration (in seconds) and a position offset (in points). Similar to CCMoveBy. */
+(id) actionWithDuration:(float)duration offset:(CGPoint)offset;
/** Create a move action with a speed (in points per frame) and a position offset (in points). Similar to CCMoveBy. */
+(id) actionWithSpeed:(float)speed offset:(CGPoint)offset;

@end
