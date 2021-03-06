//
//  KTDebugController.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 29.09.12.
//
//

#import <Foundation/Foundation.h>
#import "KTController.h"

/** Controller that helps with debugging. For example allows you to dump the controller/model/view hierarchy as a string.
 The debug controller is part of the game controller if the DEBUG macro is defined. */
@interface KTDebugController : KTController

/** Returns the entire MVC object graph as formatted string, starting with the game controller. */
-(NSString*) objectGraph;

/** Returns the MVC object graph as formatted string starting with the given controller object. */
-(NSString*) objectGraphWithRootController:(KTController*)controller;

/** Returns the size (in bytes) of instances of the class. Useful for estimating memory usage. */
-(size_t) sizeOfClassInstance:(Class)class_;

/** Prints the size (in bytes) of instances of the class to the Debug Console. */
-(void) logSizeOfClassInstance:(Class)class_;

@end
