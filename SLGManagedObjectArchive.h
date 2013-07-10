//
//  SLGManagedObjectArchive
//
//  Created by Steven Grace on 6/21/13.
//  Copyright (c) 2013 Steven Grace. All rights reserved.
//
//  NSArray wrapper for storing extrenal persistent references to NSManagedObjects
//  via the NSManagedObjectID
//

#import <Foundation/Foundation.h>


// block object called when stored reference (NSManagedObjectID) is unfound in the archives set context
// Return an managedObject to have it inserted into the archive in it's place
// or nil to ignore
typedef NSManagedObject*(^SLGManagedObjectArchiveUnfoundObjectBlock)(NSManagedObjectID* objectID,BOOL *removeReference);



@interface SLGManagedObjectArchive : NSObject <NSCoding>

+(SLGManagedObjectArchive*)archiveWithData:(NSData*)data  andContext:(NSManagedObjectContext*)context;

- (id)initWithArchiveName:(NSString*)name andContext:(NSManagedObjectContext*)context;

// returns copy of the internal array of NSManagedObjectIDs
@property(nonatomic,readonly)NSArray* managedObjectIds;


@property(nonatomic,readwrite)NSString* archiveName;


/*
   Failing to set the context will before retrieving objects will result in an Exception
 */
@property(nonatomic,readwrite)NSManagedObjectContext* context;



/*
  Synchronize the Archive the currently set context
*/
-(void)synchronizeWithBlock:(SLGManagedObjectArchiveUnfoundObjectBlock)block;


// NSArray primitive methods
- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;


/*
  Following methods will fail if the passed object that is not an NSManagedObject
*/
// NSMutable Array primitive methods
- (void)addObject:(id)anObject;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)removeObject:(id)object;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

- (NSArray*)allObjects;


// unfound objects support
- (id)objectAtIndex:(NSUInteger)index withBlock:(SLGManagedObjectArchiveUnfoundObjectBlock)block;
- (NSArray*)allObjectsWithBlock:(SLGManagedObjectArchiveUnfoundObjectBlock)block;



@end
