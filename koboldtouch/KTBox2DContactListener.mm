//
//  KTBox2DContactListener.cpp
//  Kobold2D-Libraries
//
//  Created by Steffen Itterheim on 29.09.12.
//
//

#include "KTBox2DContactListener.h"
#import "KTPhysicsBodyCollisionProtocol.h"
#import "KTPhysicsBody.h"

void KTBox2DContactListener::SendCollisionEvent(b2Contact* contact, KTPhysicsContactPhase phase)
{
	b2Body* bodyA = contact->GetFixtureA()->GetBody();
	b2Body* bodyB = contact->GetFixtureB()->GetBody();
	KTPhysicsBody* physicsBodyA = (__bridge KTPhysicsBody*)bodyA->GetUserData();
	KTPhysicsBody* physicsBodyB = (__bridge KTPhysicsBody*)bodyB->GetUserData();
	[physicsBodyA.collisionDelegate contactWithOtherBody:physicsBodyB phase:phase];
	[physicsBodyB.collisionDelegate contactWithOtherBody:physicsBodyA phase:phase];
}

void KTBox2DContactListener::BeginContact(b2Contact* contact)
{
	this->SendCollisionEvent(contact, kPhysicsContactPhaseBegan);
}

void KTBox2DContactListener::EndContact(b2Contact* contact)
{
	this->SendCollisionEvent(contact, kPhysicsContactPhaseEnded);
}

/*
void ContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
{
}

void ContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)
{
}
*/