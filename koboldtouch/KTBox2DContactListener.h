//
//  KTBox2DContactListener.h
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 29.09.12.
//
//

#ifndef __Kobold2D_Libraries__KTBox2DContactListener__
#define __Kobold2D_Libraries__KTBox2DContactListener__

#include "Box2D.h"
#import "KTPhysicsBodyCollisionProtocol.h"

// internal use only
class KTBox2DContactListener : public b2ContactListener
{
private:
	void SendCollisionEvent(b2Contact* contact, KTPhysicsContactPhase phase);
	
	void BeginContact(b2Contact* contact);
	void EndContact(b2Contact* contact);

	//void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
	//void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
};

#endif /* defined(__Kobold2D_Libraries__KTBox2DContactListener__) */
