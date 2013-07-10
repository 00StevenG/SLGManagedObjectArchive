//
//  CarsTableViewController.m
//  SLGManagedObjectArchive
//
//  Created by Steven Grace on 7/4/13.
//  Copyright (c) 2013 Steven Grace. All rights reserved.
//

#import "CarsTableViewController.h"
#import "Car.h"
#import "Automaker.h"
#import "SLGManagedObjectArchive.h"
#import "SelectCarsTableViewController.h"

@interface CarsTableViewController ()<SelectCarsTableViewControllerDelegate>


@end

@implementation CarsTableViewController{
    
    
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IBACTIONS
-(IBAction)addCarAction:(id)sender{
    
    
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"SelectCars" bundle:nil];
    UINavigationController* nController =[storyBoard instantiateInitialViewController];
    SelectCarsTableViewController* carsController =(SelectCarsTableViewController*)nController.topViewController;
    
    carsController.delegate = self;
    carsController.context = self.context;
    
    [self presentViewController:nController
                       animated:YES
                     completion:NULL];
    

    
    
    
}
-(IBAction)editButtonAction:(id)sender{
    
    [self setEditing:!self.editing animated:YES];
}
#pragma mark SelectCarsTableViewControllerDelegate
-(void)selectCarTableController:(SelectCarsTableViewController*)controller didSelectCars:(NSArray*)cars{
    

    for(Car *car in cars){
        [_carArchive addObject:car];
    }
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 [self.tableView reloadData];
                                 
                             }];
    
    
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_carArchive count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"carCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    _carArchive.context = self.context;
    Car *car = [_carArchive objectAtIndex:indexPath.row];
    

    
    cell.textLabel.text = car.automaker.name;
    cell.detailTextLabel.text  =car.model;
    return cell;
}
#pragma mark - Table view delegate
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        // Delete the row from the data source
        _carArchive.context = self.context;
        Car *aCar = [_carArchive objectAtIndex:indexPath.row];
        [_carArchive removeObject:aCar];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {

    
    
    }
}

@end
