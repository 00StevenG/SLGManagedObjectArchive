//
//  SelectCarsTableViewController.m
//  SLGManagedObjectArchive
//
//  Created by Steven Grace on 7/4/13.
//  Copyright (c) 2013 Steven Grace. All rights reserved.
//

#import "SelectCarsTableViewController.h"
#import "Car.h"
#import "Automaker.h"

@interface SelectCarsTableViewController (){
    
    
    
    NSMutableArray* _selectedCars;
    NSArray*_allCars;
    
}


@end

@implementation SelectCarsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _selectedCars = [[NSMutableArray alloc]init];
    
    
    self.tableView.allowsMultipleSelection = YES;
    
    NSFetchRequest* allCarsRequest = [[NSFetchRequest alloc]init];
    
    NSEntityDescription* entity = 
    [NSEntityDescription entityForName:@"Car" inManagedObjectContext:self.context];
    [allCarsRequest setEntity:entity];
    
    NSError* err = nil;
    
    _allCars =
    [self.context executeFetchRequest:allCarsRequest error:&err];
    if (err) {
        
    
    }
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_allCars count];
    
}
//
//
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"carCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    Car *car = [_allCars objectAtIndex:indexPath.row];
    cell.textLabel.text = car.automaker.name;
    cell.detailTextLabel.text  =car.model;

    return cell;
}
#pragma mark - IBActions
-(IBAction)doneButtonAction:(id)sender{
    
    NSArray* selectedCars = [NSArray arrayWithArray:_selectedCars];
    [self.delegate selectCarTableController:self didSelectCars:selectedCars];
    
}
#pragma mark - Table view delegate
//
//
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Car *car = [_allCars objectAtIndex:indexPath.row];
    BOOL isSelected  = [_selectedCars containsObject:car];
    if(isSelected){
        [_selectedCars removeObject:car];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
        
    }
    
    // add the car to the object
    [_selectedCars addObject:car];
    
}

@end
