//
//  SelectCarsTableViewController.h
//  SLGManagedObjectArchive
//
//  Created by Steven Grace on 7/4/13.
//  Copyright (c) 2013 Steven Grace. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectCarsTableViewController;

@protocol SelectCarsTableViewControllerDelegate <NSObject>

-(void)selectCarTableController:(SelectCarsTableViewController*)controller didSelectCars:(NSArray*)cars;


@end
@interface SelectCarsTableViewController : UITableViewController


@property(weak)id<SelectCarsTableViewControllerDelegate>delegate;
@property(nonatomic,readwrite)NSManagedObjectContext* context;

-(IBAction)doneButtonAction:(id)sender;

@end
