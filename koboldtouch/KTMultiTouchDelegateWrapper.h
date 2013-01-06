//
//  KTMultiTouchDelegateWrapper.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.10.12.
//
//

#import "KTMultiTouchProtocol.h"

@class KTMultiTouchController;
@class KTMultiTouchEvent;

// internal use only
@interface KTMultiTouchDelegateWrapper : NSObject
{
@private
	__weak KTMultiTouchController* _multiTouchController;
	BOOL _implementsTouchesBegan;
	BOOL _implementsTouchesMoved;
	BOOL _implementsTouchesEnded;
	BOOL _implementsTouchesCancelled;
	BOOL _implementsTouchBegan;
	BOOL _implementsTouchMoved;
	BOOL _implementsTouchEnded;
	BOOL _implementsTouchCancelled;
}

@property (nonatomic, weak) id<KTMultiTouchProtocol> delegate;

-(id) initWithDelegate:(id<KTMultiTouchProtocol>)delegate multiTouchController:(KTMultiTouchController*)multiTouchController;

-(void) sendTouchesBeganEvent:(KTMultiTouchEvent*)multiTouchEvent;
-(void) sendTouchesMovedEvent:(KTMultiTouchEvent*)multiTouchEvent;
-(void) sendTouchesEndedEvent:(KTMultiTouchEvent*)multiTouchEvent;
-(void) sendTouchesCancelledEvent:(KTMultiTouchEvent*)multiTouchEvent;
@end
