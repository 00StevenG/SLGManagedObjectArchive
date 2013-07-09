//
//  CarsTableViewController.h
//  SLGManagedObjectArchive
//
//  Created by Steven Grace on 7/4/13.
//  Copyright (c) 2013 Steven Grace. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLGManagedObjectArchive;

@interface CarsTableViewController : UITableViewController

@property(nonatomic,readwrite)SLGManagedObjectArchive* carArchive;
@property(nonatomic,readwrite)NSManagedObjectContext* context;


-(IBAction)addCarAction:(id)sender;


@end
