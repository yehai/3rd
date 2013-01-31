//
//  KTTilemapModel.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 13.10.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KTEntityModel.h"
#import "KTTilemap.h"

/** Model for a TMX tilemap. Currently only holds a reference to the KTTilemap object which is in in-memory representation of the TMX file. */
@interface KTTilemapModel : KTModel
{
@protected
@private
}

@property (nonatomic, readonly) KTTilemap* tilemap;

@end
