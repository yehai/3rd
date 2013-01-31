//
//  KTSaveLoadController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 29.09.12.
//
//

#import "KTController.h"

/** Returned as archive version if archive is not a compatible archive. */
const static int KTArchiveNotCompatible = -1;
/** Returned as archive version if archive file does not exist. */
const static int KTArchiveFileNotFound = -2;
/** Returned as archive version if not currently unarchiving. */
const static int KTArchiveNotDecoding = -3;


@class KTSceneViewController;

/** Creates model archives and restores model objects from an archive. Proof of concept, not supported
 by most KT classes yet. Needs refactoring. */
@interface KTArchiveController : KTController
{
	@private
}

/** Creates save/load controller with a specific archive version. */
+(id) saveLoadControllerWithArchiveVersion:(int)archiveVersion;

/** The current archive version. New archives will have this version. You can later detect older (or newer) archive data
 by comparing archiveVersion (should have) and unarchiveVersion (does have). Default is 0.
 
 The archive version can only be set once when creating the save/load controller. */
@property (nonatomic, readonly) int archiveVersion;
/** The archive version of the archive currently being decoded. Returns KTArchiveNotDecoding if there's no archive currently being decoded. */
@property (nonatomic, readonly) int archiveVersionBeingDecoded;

/** Returns the version of the archive. Use this before actually unarchiving to influence how you setup the scene,
 ie in a previous version save a specific controller may not exist, or is expected to exist.
 Returns KTIncompatibleArchive if data is not a compatible archive. */
-(int) archiveVersionForData:(NSData*)data;
/** Returns the version of an archive file. Returns KTIncompatibleArchive if data is not a compatible archive,
 and KTArchiveFileNotFound if the file does not exist. */
-(int) archiveVersionFromFile:(NSString*)file;

/** Starts archiving models beginning with the given controller. It should be a KTSceneViewController. */
-(NSData*) archivedDataWithController:(KTSceneViewController*)controller;
/** Same as archivedDataWithController but saves data to given file in user's documents directory. */
-(void) writeToFile:(NSString*)file controller:(KTController*)controller;

/** Unarchives the models from data. */
-(void) unarchiveController:(KTSceneViewController*)controller withData:(NSData*)data;
/** Unarchives a controller's model from the given archive file. */
-(void) loadFromFile:(NSString*)file controller:(KTController*)controller;

@end
