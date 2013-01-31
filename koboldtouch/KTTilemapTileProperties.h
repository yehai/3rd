//
//  KTTilemapTileProperties.h
//  KoboldTouch-Libraries
//
//  Created by Steffen Itterheim on 21.01.13.
//
//

#import <Foundation/Foundation.h>

@class KTTilemapProperties;
@class KTMutableNumber;

/** Wrapper for tile properties. KTTilemapProperties can be set & accessed for/with a tile gid. */
@interface KTTilemapTileProperties : NSObject
{
@private
	NSMutableDictionary* _tileProperties;
}

/** Sets the number for the key on the tile gid's properties. Creates an instance of KTTilemapProperties if the gid has no properties yet. Returns that tile's properties. */
-(KTTilemapProperties*) propertiesForGid:(gid_t)gid setNumber:(KTMutableNumber*)number forKey:(NSString*)key;
/** Sets the string for the key on the tile gid's properties. Creates an instance of KTTilemapProperties if the gid has no properties yet. Returns that tile's properties. */
-(KTTilemapProperties*) propertiesForGid:(gid_t)gid setString:(NSString*)string forKey:(NSString*)key;
/** (KTTMXParser only) Sets a string or number (if string is convertible to number) for the key on the tile gid's properties. 
 Creates an instance of KTTilemapProperties if the gid has no properties yet. Returns that tile's properties. */
-(KTTilemapProperties*) propertiesForGid:(gid_t)gid setValue:(NSString*)string forKey:(NSString*)key;

/** Returns the properties for a tile gid. Returns nil if the gid has no properties. */
-(KTTilemapProperties*) propertiesForGid:(gid_t)gid;

/** Returns the properties for a tile gid. If createNonExistingProperties is YES and if the gid has no properties, will create a new
 KTTilemapProperties object, set it as the tile gid's properties object, and return it. If createNonExistingProperties is NO behaves
 identical to propertiesForGid: by returning nil for non-existing tile properties. */
-(KTTilemapProperties*) propertiesForGid:(gid_t)gid createNonExistingProperties:(BOOL)createNonExistingProperties;

@end
