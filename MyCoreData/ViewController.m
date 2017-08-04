//
//  ViewController.m
//  MyCoreData
//
//  Created by Aico on 8/3/17.
//  Copyright © 2017 lee. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

static NSString *REUSEID = @"reuseCell";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray<NSManagedObject *> *people;
    NSEntityDescription *entity;
    NSManagedObjectContext *managedContext;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"List";
    
    people = [NSMutableArray array];
    
    [self buildTalbeView];
    [self setEntityDescription];
    [self fetchPeople];
    
    
}

- (IBAction)addClicked:(id)sender {
    [self presentViewController:[self buildAlertView] animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:REUSEID forIndexPath:indexPath];
    cell.textLabel.text = [people[indexPath.row] valueForKeyPath:@"name"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return people.count;
}

- (void)buildTalbeView {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:REUSEID];
}

- (UIAlertController *)buildAlertView {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"New Name" message:@"Add a new name" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"name";
    }];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self save:[[alertView textFields] firstObject].text];
        [self.tableView reloadData];
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Calceled");
    }]];
    return alertView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setEntityDescription {
    // 通过AppDelegate来获取当前的NSManagedObject
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    managedContext = [[appDelegate persistentContainer] viewContext];
    entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:managedContext];
}

- (void)fetchPeople {
    NSError *error = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    [people addObjectsFromArray:[managedContext executeFetchRequest:request error:&error]];
}

- (void)save:(NSString *)name {
    NSManagedObject *person = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedContext];
    [person setValue:name forKey:@"name"];
    
    @try {
        [managedContext save:nil];
        [people addObject:person];
    } @catch (NSException *exception) {
        NSLog(@"Count not save %@", exception);
    } @finally {
        
    }
}

@end
