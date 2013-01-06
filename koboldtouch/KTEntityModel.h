//
//  KTEntityModel.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 25.09.12.
//
//

#import "KTModel.h"
#import "KTTypes.h"

/** Representation of a game entity with position. 
 This could be the player, an enemy, an item to pick up, a puzzle piece, and so on. */
@interface KTEntityModel : KTModel

/** Position of the entity in absolute, arbitrary game world coordinates. 
 Which units the position uses is up to you. In most cases it will simply be points or pixels.
 The view controller is responsible for translating the entity position to a corresponding view position. */
@property (nonatomic) CGPoint position;

/** The rotation of the entity in arbitrary units. Typically it's in degrees but if you prefer you can use radians
 and have the view controller convert it to degrees for use on the view. */
@property (nonatomic) float rotation;

@property (nonatomic) float scale;
@property (nonatomic) CGSize contentSize;

@end
