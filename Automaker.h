//
//  Automaker.h
//  SLGCoreDataObjectCollection
//
//  Created by Steven Grace on 7/4/13.
//  Copyright (c) 2013 Steven Grace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Automaker : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *cars;
@end

@interface Automaker (CoreDataGeneratedAccessors)

- (void)addCarsObject:(NSManagedObject *)value;
- (void)removeCarsObject:(NSManagedObject *)value;
- (void)addCars:(NSSet *)values;
- (void)removeCars:(NSSet *)values;

@end
