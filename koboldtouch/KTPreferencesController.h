//
//  KTPreferencesController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 24.09.12.
//
//

#import "KTController.h"

/** Stub: Base class for a Preferences controller, which handles common game settings such as volume, difficulty, etc.
 
 Subclasses may support saving to different locations, be it NSUserDefaults,
 exposing preferences in the Settings app, archiving to files (save/load), storing files on iCloud. Those could
 also be completely separate controllers. TBD */
@interface KTPreferencesController : KTController

@end
