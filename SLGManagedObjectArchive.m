//
//  SLGManagedObjectArchive
//
//  Created by Steven Grace on 6/21/13.
//  Copyright (c) 2013 Steven Grace. All rights reserved.
//

#import "SLGManagedObjectArchive.h"

@implementation SLGManagedObjectArchive{
    
    NSMutableArray* _objectIds;
    
}
#pragma mark - INIT
//
//
//
-(id)initWithArchiveName:(NSString*)name{
    
    self = [super init];
    if(self){
        _archiveName = name;
        _objectIds = [[NSMutableArray alloc]init];
    }
    return self;
}
#pragma mark - NSCoding
//
//
//
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_archiveName forKey:@"archiveName"];
    [aCoder encodeObject:_objectIds forKey:@"objectIDs"];
}
//
//
//
- (id)initWithCoder:(NSCoder *)aDecoder{
  
    self = [super init];
    if(self){
        _archiveName = [aDecoder decodeObjectForKey:@"archiveName"];
        _objectIds = [aDecoder decodeObjectForKey:@"objectIDs"];
    }
    return self;
}
#pragma mark - Getters
//
//
//
-(NSUInteger)count{
    return [_objectIds count];
}
//
//
//
-(NSArray*)managedObjectIds{
    return [NSArray arrayWithArray:_objectIds];
}
#pragma mark - Public
//
//
//
-(void)addObject:(NSManagedObject*)object{
    
    [self _updateManagedObjectIDIfNeeded:object];
    
    if([self containsObject:object]==YES)
        return;

    
    NSURL *uri = [[object objectID] URIRepresentation];
    [_objectIds addObject:uri];
    
}
//
//
//
-(BOOL)containsObject:(NSManagedObject*)object{
  
    NSURL *uri = [[object objectID] URIRepresentation];
    
    __block NSURL* match = nil;
    [_objectIds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSURL* aURI = obj;
        
        if([aURI isEqual:uri]==YES){
            match = aURI;
            *stop = YES;
        }
    }];
    
    if(match){
        return YES;
    }
    return NO;
}
//
//
//
-(id)objectAtIndex:(NSUInteger)idx inContext:(NSManagedObjectContext*)context{
    
    
    if(idx>=[_objectIds count])
        return nil;
    
    NSURL* uri = [_objectIds objectAtIndex:idx];
    
    
    NSManagedObjectID *objectID =
    [context.persistentStoreCoordinator managedObjectIDForURIRepresentation:uri];
    
    NSManagedObject* object = [context objectWithID:objectID];
    
    return object;
    
}
//
//
//
-(BOOL)removeObject:(NSManagedObject*)object{
    
    NSURL *uri = [[object objectID] URIRepresentation];
    
    __block NSURL* match = nil;
    [_objectIds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      
        NSURL* aURI = obj;
        
        if([aURI isEqual:uri]==YES){
            match = aURI;
            *stop = YES;
            
        }
    }];
    
    if(match){
        [_objectIds removeObject:match];
        return YES;
    }
    return NO;
    
}
//
//
//
-(NSArray*)fetchArchiveObjectsInContext:(NSManagedObjectContext*)context{
    
    NSMutableArray* mARR = [[NSMutableArray alloc]init];
    
    for(NSURL* uri in _objectIds){
       
        NSManagedObjectID *objectID =
        [context.persistentStoreCoordinator managedObjectIDForURIRepresentation:uri];
        
        NSManagedObject* object = [context objectWithID:objectID];
        if(object){
            [mARR addObject:object];
        }
    }
    return [NSArray arrayWithArray:mARR];
    
    
}
//
//
//
-(NSArray*)fetchArchiveObjectsInContext:(NSManagedObjectContext *)context
                              withBlock:(SLGManagedObjectArchiveUnfoundObjectBlock)block{
    
    
    NSMutableArray* mARR = [[NSMutableArray alloc]init];
    
    for(NSURL* uri in _objectIds){
        
        NSManagedObjectID *objectID =
        [context.persistentStoreCoordinator managedObjectIDForURIRepresentation:uri];
        
        NSManagedObject* object = [context objectWithID:objectID];
        if(!object && block){
            object = block(objectID);
        }
        
        if(object)
            [mARR addObject:object];
        
    }
    return [NSArray arrayWithArray:mARR];
    
}
#pragma mark - Internal
//
//
//
-(void)_updateManagedObjectIDIfNeeded:(NSManagedObject*)object{
    
    if([object.objectID isTemporaryID]==YES){
        
        NSManagedObjectContext* context = object.managedObjectContext;
        
        NSError* err =nil;
        [context obtainPermanentIDsForObjects:[NSArray arrayWithObject:object]
                                        error:&err];
        NSAssert(err==nil,@"Error obtaining managed Object ID in %s",__PRETTY_FUNCTION__);
    }
}


@end
