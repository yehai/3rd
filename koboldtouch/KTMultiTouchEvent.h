//
//  KTMultiTouchEvent.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 17.01.13.
//
//

#import <Foundation/Foundation.h>
#import "KTTypes.h"

/** Touch event that contains all information about a multitouch event. */
@interface KTMultiTouchEvent : NSObject
{
@private
	NSMutableArray* _touchEvents;
}
/** A set of KTTouchEvent objects representing each touch. */
@property (nonatomic) NSArray* touchEvents;
/** If a touch delegate sets this property to YES, the touches will not be forwarded to other delegates. Defaults to NO. */
@property (nonatomic) BOOL swallowTouches;

// internal
-(void) reset;
-(void) updateWithTouches:(NSSet*)touches event:(KTEvent*)event;
@end
