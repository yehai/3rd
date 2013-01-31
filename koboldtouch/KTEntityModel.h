//
//  KTEntityModel.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.09.12.
//
//

#import "KTModel.h"
#import "KTTypes.h"

@class KTAction;

/** Representation of a game entity with position. 
 This could be the player, an enemy, an item to pick up, a puzzle piece, and so on. */
@interface KTEntityModel : KTModel
{
	@protected
	CGPoint _position;
	CGSize _contentSize;
	float _rotation;
	float _scale;
	@private
	NSMutableArray* _actions;
}

/** Position of the entity in absolute, arbitrary game world coordinates. 
 Which units the position uses is up to you. In most cases it will simply be points or pixels.
 The view controller is responsible for translating the entity position to a corresponding view position. */
@property (nonatomic) CGPoint position;

/** The rotation of the entity in arbitrary units. Typically it's in degrees but if you prefer you can use radians
 and have the view controller convert it to degrees for use on the view. */
@property (nonatomic) float rotation;

/** preliminary, not used, may be removed */
@property (nonatomic) float scale;
/** preliminary, not used, may be removed */
@property (nonatomic) CGSize contentSize;


/** List of currently running KTAction on this KTEntityModel. Add/Remove actions via runAction and stopAction methods. */
@property (nonatomic, readonly) NSArray* actions;

/** Runs an action on the model. It is illegal to run the same action on more than one model. */
-(void) runAction:(KTAction*)action;
/** Stops the action, removes it. If no other strong reference to this action exists it will be released from memory. */
-(void) stopAction:(KTAction*)action;
/** Stops all currently running actions. */
-(void) stopAllActions;

// TODO
//-(void) stopAllActionsWithTag:(NSInteger)tag;
//-(void) stopActionByTag:(NSInteger)tag;
//-(KTAction*) actionByTag:(NSInteger)tag;

@end
