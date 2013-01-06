//
//  KTMacros.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 10.10.12.
//
//

#ifndef Kobold2D_Libraries_KTMacros_h
#define Kobold2D_Libraries_KTMacros_h

#import "CCFileUtils.h"

/** @file KTMacros.h */


/** If defined, logs the save/load process */
#ifndef KT_DEBUGLOG_SAVE_LOAD
#define KT_DEBUGLOG_SAVE_LOAD 1
#endif

#ifdef DEBUG
#define KTASSERT_FILEEXISTS(file) NSAssert1([[NSFileManager defaultManager] fileExistsAtPath:[[CCFileUtils sharedFileUtils] fullPathFromRelativePath:file]], @"file '%@' not found in bundle!", file);
#else
#define KTASSERT_FILEEXISTS(file) do {} while (0)
#endif

#endif
