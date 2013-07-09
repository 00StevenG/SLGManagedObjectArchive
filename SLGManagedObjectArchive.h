//
//  SLGManagedObjectArchive
//
//  Created by Steven Grace on 6/21/13.
//  Copyright (c) 2013 Steven Grace. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NSManagedObject*(^SLGManagedObjectArchiveUnfoundObjectBlock)(NSManagedObjectID* objectID);


@interface SLGManagedObjectArchive : NSObject <NSCoding>


-(id)initWithArchiveName:(NSString*)name;

@property(nonatomic,readwrite)NSString* archiveName;
@property(nonatomic,readonly)NSUInteger count;
@property(nonatomic,readonly)NSArray* managedObjectIds;


-(void)addObject:(NSManagedObject*)object;
-(BOOL)containsObject:(NSManagedObject*)object;
-(BOOL)removeObject:(NSManagedObject*)object;
-(id)objectAtIndex:(NSUInteger)idx inContext:(NSManagedObjectContext*)context;

-(NSArray*)fetchArchiveObjectsInContext:(NSManagedObjectContext*)context;

-(NSArray*)fetchArchiveObjectsInContext:(NSManagedObjectContext *)context
                              withBlock:(SLGManagedObjectArchiveUnfoundObjectBlock)block;


@end