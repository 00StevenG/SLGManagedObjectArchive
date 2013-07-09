//
//  Car.h
//  SLGCoreDataObjectCollection
//
//  Created by Steven Grace on 7/4/13.
//  Copyright (c) 2013 Steven Grace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Automaker;

@interface Car : NSManagedObject

@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) Automaker *automaker;

@end
