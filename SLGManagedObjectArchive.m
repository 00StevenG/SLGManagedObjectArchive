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
#pragma mark - Archiving Static Methods
+(SLGManagedObjectArchive*)archiveWithData:(NSData*)data  andContext:(NSManagedObjectContext*)context{
    
    SLGManagedObjectArchive* archive = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    archive.context = context;
    
    return archive;
}
#pragma mark - INIT
//
//
//
-(id)initWithArchiveName:(NSString*)name andContext:(NSManagedObjectContext*)context{
    
    self = [super init];
    if(self){
        _context = context;
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
  
    self = [self initWithArchiveName:nil andContext:nil];
    if(self){
        _archiveName = [aDecoder decodeObjectForKey:@"archiveName"];
        _objectIds = [aDecoder decodeObjectForKey:@"objectIDs"];
    }
    return self;
}
#pragma mark - Getter
//
//
//
-(NSArray*)managedObjectIds{
    return [NSArray arrayWithArray:_objectIds];
}
#pragma mark - Synchronize
//
//
//
-(void)synchronizeWithBlock:(SLGManagedObjectArchiveUnfoundObjectBlock)block{
    
    
    // just fetch all objects and ignore he returned array
    NSArray* arr = [self allObjectsWithBlock:block];
    arr = nil;
    
}
#pragma mark Primitive Methods (NSArray/ NSMutable Array)
//
//
//
-(NSUInteger)count{
    return [_objectIds count];
}
//
//
//
-(id)objectAtIndex:(NSUInteger)index{
 
    
    NSAssert(self.context!=nil,@"%s:Context must be set",__PRETTY_FUNCTION__);
    
    NSURL* uri = [_objectIds objectAtIndex:index];
    
    if(uri){
        
        NSManagedObjectID *objectID =
        [self.context.persistentStoreCoordinator managedObjectIDForURIRepresentation:uri];
        NSManagedObject* object = [self.context objectWithID:objectID];
        return object;
    }
    return nil;
}
//
//
//
- (void)addObject:(id)anObject{

    NSAssert([anObject isKindOfClass:[NSManagedObject class]]==YES,@"%s:Passed Object is unsupported",__PRETTY_FUNCTION__);
    
              
    [self _updateManagedObjectIDIfNeeded:anObject];
    
    if([self containsObject:anObject]==YES)
        return;
    
    NSURL *uri = [[anObject objectID] URIRepresentation];
    [_objectIds addObject:uri];
    
}
//
//
//
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
    
    NSAssert([anObject isKindOfClass:[NSManagedObject class]]==YES,@"%s:Passed Object is unsupported",__PRETTY_FUNCTION__);

    [self _updateManagedObjectIDIfNeeded:anObject];

    if([self containsObject:anObject]==YES)
        return;
    
    NSURL *uri = [[anObject objectID] URIRepresentation];
    [_objectIds insertObject:uri atIndex:index];
    
}
//
//
//
- (void)removeLastObject{
    
    [_objectIds removeLastObject];
}
//
//
//
- (void)removeObjectAtIndex:(NSUInteger)index{
    
    [_objectIds removeObjectAtIndex:index];
}
//
//
//
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    
    NSAssert([anObject isKindOfClass:[NSManagedObject class]]==YES,@"%s:Passed Object is unsupported",__PRETTY_FUNCTION__);
    
    [self _updateManagedObjectIDIfNeeded:anObject];

    NSURL *uri = [[anObject objectID] URIRepresentation];

    [_objectIds replaceObjectAtIndex:index withObject:uri];
    
}
//
//
//
-(void)removeObject:(id)object{
    
    NSURL *uri = [[object objectID] URIRepresentation];
    
    __block NSURL* match = nil;
    [_objectIds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSURL* aURI = obj;
        
        if([aURI isEqual:uri]==YES){
            match = aURI;
            *stop = YES;
            
        }
    }];
    
    if(match)
        [_objectIds removeObject:match];
    
    return ;
    
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
-(NSArray*)allObjects{
    
    NSAssert(self.context!=nil,@"%s:Context must be set",__PRETTY_FUNCTION__);
    

    NSMutableArray* mARR = [[NSMutableArray alloc]init];
    
    for(NSURL* uri in _objectIds){
        
        NSManagedObjectID *objectID =
        [self.context.persistentStoreCoordinator managedObjectIDForURIRepresentation:uri];
        
        NSManagedObject* object = [self.context objectWithID:objectID];
        if(object){
            [mARR addObject:object];
        }
    }
    return [NSArray arrayWithArray:mARR];
}
#pragma mark - Unfound Object Support
//
//
//
-(id)objectAtIndex:(NSUInteger)index withBlock:(SLGManagedObjectArchiveUnfoundObjectBlock)block{
    
    id object  = [self objectAtIndex:index];
    if(!object && block){
        
        NSURL* uri = [_objectIds objectAtIndex:index];
        NSManagedObjectID *objectID =
        [self.context.persistentStoreCoordinator managedObjectIDForURIRepresentation:uri];
        BOOL removeReference = NO;
        object =  block(objectID,&removeReference);
        
        if(object){
            
            [self _updateManagedObjectIDIfNeeded:object];
            NSURL *uri = [[object objectID] URIRepresentation];
            [_objectIds replaceObjectAtIndex:index withObject:uri];
            
        }
        else if(removeReference==YES){
            [_objectIds removeObject:uri];
        }
    
        
        
        
        
    }
    return object;
    
}
//
//
//
-(NSArray*)allObjectsWithBlock:(SLGManagedObjectArchiveUnfoundObjectBlock)block{
    
    
    NSMutableArray* mARR = [[NSMutableArray alloc]init];
    NSMutableIndexSet* indexesToRemove = [[NSMutableIndexSet alloc]init];
    
    NSMutableIndexSet* indexesToReplace = [[NSMutableIndexSet alloc]init];
    NSMutableArray* URIsToReplace = [[NSMutableArray alloc]init];
    
    
    [_objectIds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSURL* uri = (NSURL*)obj;
        NSManagedObjectID *objectID =
        [self.context.persistentStoreCoordinator managedObjectIDForURIRepresentation:uri];
        
        NSManagedObject* object = [self.context objectWithID:objectID];

        if(!object && block){
            BOOL removeReference = NO;
            object = block(objectID,&removeReference);
        
            if(object){
                [self _updateManagedObjectIDIfNeeded:object];
                NSURL *uri = [[object objectID] URIRepresentation];
                
                [indexesToReplace addIndex:idx];
                [URIsToReplace addObject:uri];
                [mARR addObject:object];
                
            }else if(removeReference==YES){
                [indexesToRemove addIndex:idx];
            }
        }
        else{
            [mARR addObject:object];

        }

    }];

    
    if([indexesToReplace count]>0)
        [_objectIds replaceObjectsAtIndexes:indexesToReplace withObjects:URIsToReplace];
    
    
    if([indexesToRemove count]>0)
        [_objectIds removeObjectsAtIndexes:indexesToRemove];
    
    
    
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
