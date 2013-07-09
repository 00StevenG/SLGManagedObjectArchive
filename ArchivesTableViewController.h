//
//  ArchivesTableViewController.h
//  SLGCoreDataObjectCollection
//
//  Created by Steven Grace on 7/4/13.
//  Copyright (c) 2013 Steven Grace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchivesTableViewController : UITableViewController


@property(nonatomic,readwrite)NSManagedObjectContext* context;
@property(nonatomic,readwrite)IBOutlet UIBarButtonItem *addButton;
@property(nonatomic,readwrite)NSMutableArray* archives;

-(IBAction)addArchiveAction:(id)sender;


@end
