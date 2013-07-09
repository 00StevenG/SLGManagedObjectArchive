//
//  ArchivesTableViewController.m
//  SLGCoreDataObjectCollection
//
//  Created by Steven Grace on 7/4/13.
//  Copyright (c) 2013 Steven Grace. All rights reserved.
//

#import "ArchivesTableViewController.h"
#import "SLGManagedObjectArchive.h"
#import "SelectCarsTableViewController.h"
#import "CarsTableViewController.h"
#import "Car.h"
#import "SLGAppDelegate.h"

@interface ArchivesTableViewController () <SelectCarsTableViewControllerDelegate>


@end

@implementation ArchivesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([[segue identifier]isEqualToString:@"carsSegue"]){
        
        CarsTableViewController* carsController = (CarsTableViewController*)segue.destinationViewController;
        SLGManagedObjectArchive* archive = [_archives objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        carsController.carArchive = archive;
        carsController.context = self.context;
        
        
    }
    
    
}
-(void)_writeArchivesToDisk{
    

    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:_archives];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"archives"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    
}
-(void)_readArchivesFromDisk{
    
    NSData* data =
    [[NSUserDefaults standardUserDefaults]objectForKey:@"archives"];
    
    if(data){
        _archives = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];



    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    
    [self _readArchivesFromDisk];
    
    
    if(_archives==nil)
        _archives = [[NSMutableArray alloc]init];

    SLGAppDelegate* appD = [UIApplication sharedApplication].delegate;
    self.context = [appD context];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    

    [self.tableView reloadData];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_archives count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"archiveCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SLGManagedObjectArchive* archive = [_archives objectAtIndex:indexPath.row];
    cell.textLabel.text = archive.archiveName;
    cell.detailTextLabel.text= [NSString stringWithFormat:@"%i objects",[archive count]];
    
    return cell;
}
//
//
//
-(IBAction)addArchiveAction:(id)sender{
    
    
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
-(void)selectCarTableController:(SelectCarsTableViewController*)controller didSelectCars:(NSArray*)cars{
    
    
    NSString* newName= [NSString stringWithFormat:@"New Archive %i",[_archives count]+1];
    SLGManagedObjectArchive* newArchive = [[SLGManagedObjectArchive alloc]initWithArchiveName:newName];
    
    
    for(Car *car in cars){
        [newArchive addObject:car];
    }
    
    [_archives addObject:newArchive];    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 [self.tableView reloadData];

                                 
                                 [self _writeArchivesToDisk];
                                 _archives = nil;
                                 [self _readArchivesFromDisk];
                                 
                                 
                             }];
    
    

}
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
        [_archives removeObject:[_archives objectAtIndex:indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



#pragma mark - Table view delegate

@end
