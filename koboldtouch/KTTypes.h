//
//  KTTypes.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 28.09.12.
//
//

#ifndef Kobold2D_Libraries_KTTypes_h
#define Kobold2D_Libraries_KTTypes_h

/** @file KTTypes.h */

static NSString* const KTDirectorDidReshapeProjectionNotification = @"KTDirectorDidReshapeProjectionNotification";

/** gid (globally unique tile index) is an unsigned int (32 bit) value */
typedef uint32_t gid_t;

#if KK_PLATFORM_IOS
typedef UIEvent KTEvent;
typedef UITouch KTTouch;

#elif KK_PLATFORM_MAC
typedef NSEvent KTEvent;
typedef NSTouch KTTouch;

#endif // KK_PLATFORM_MAC


#endif // Kobold2D_Libraries_KTTypes_h
